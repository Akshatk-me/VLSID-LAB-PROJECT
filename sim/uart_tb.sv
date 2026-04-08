`timescale 1ns/1ps

module uart_tb;
  // Clock / reset
  reg clk;
  reg resetn;

  // Serial lines
  wire ser_tx;
  reg  ser_rx;

  // Divider register interface
  reg  [3:0]  reg_div_we;
  reg  [31:0] reg_div_di;
  wire [31:0] reg_div_do;

  // Data register interface
  reg         reg_dat_we;
  reg         reg_dat_re;
  reg  [31:0] reg_dat_di;
  wire [31:0] reg_dat_do;
  wire        reg_dat_wait;

  // Instantiate DUT
  uart dut (
    .clk(clk),
    .resetn(resetn),
    .ser_tx(ser_tx),
    .ser_rx(ser_rx),
    .reg_div_we(reg_div_we),
    .reg_div_di(reg_div_di),
    .reg_div_do(reg_div_do),
    .reg_dat_we(reg_dat_we),
    .reg_dat_re(reg_dat_re),
    .reg_dat_di(reg_dat_di),
    .reg_dat_do(reg_dat_do),
    .reg_dat_wait(reg_dat_wait)
  );

  // Clock: 100 MHz
  initial clk = 1'b0;
  always #5 clk = ~clk;

  task fail(input [1023:0] msg);
    begin
      $display("FAIL: %0s", msg);
      $finish;
    end
  endtask

  // Helpers for register-style strobes
  task uart_write_divider_masked(input [31:0] div, input [3:0] mask);
    begin
      // Drive on negedge to avoid races with DUT sampling on posedge.
      @(negedge clk);
      reg_div_di = div;
      reg_div_we = mask;
      @(posedge clk);
      @(negedge clk);
      reg_div_we = 4'h0;
      reg_div_di = 32'h0;
      @(posedge clk);
    end
  endtask

  task uart_write_divider(input [31:0] div);
    begin
      uart_write_divider_masked(div, 4'hF);
    end
  endtask

  task uart_write_data_byte(input [7:0] b);
    integer guard;
    begin
      // This interface is a wait/hold handshake:
      // - Master asserts reg_dat_we with data
      // - Slave asserts reg_dat_wait to stall while busy
      // - Transaction completes on the first cycle where reg_dat_we==1 and reg_dat_wait==0
      @(negedge clk);
      reg_dat_di = {24'h0, b};
      reg_dat_we = 1'b1;

      guard = 0;
      // Wait until we observe an actual clock edge where wait==0.
      // That posedge is the acceptance cycle for this write.
      begin : wait_for_accept
        while (1) begin
          @(posedge clk);
          guard = guard + 1;
          if (reg_dat_wait === 1'b0) begin
            $display("INFO: TX write accepted at t=%0t (ser_tx=%b)", $time, ser_tx);
            disable wait_for_accept;
          end
          if (guard > 200000) begin
            fail("timeout waiting for reg_dat_wait to drop (TX never became idle?)");
            disable wait_for_accept;
          end
        end
      end
      @(negedge clk);
      reg_dat_we = 1'b0;
      reg_dat_di = 32'h0;
    end
  endtask

  task uart_pulse_dat_re;
    begin
      @(negedge clk);
      reg_dat_re = 1'b1;
      @(posedge clk);
      @(negedge clk);
      reg_dat_re = 1'b0;
      @(posedge clk);
    end
  endtask

  task uart_start_data_write(input [7:0] b);
    begin
      @(negedge clk);
      reg_dat_di = {24'h0, b};
      reg_dat_we = 1'b1;
    end
  endtask

  task uart_finish_data_write;
    begin
      @(negedge clk);
      reg_dat_we = 1'b0;
      reg_dat_di = 32'h0;
    end
  endtask

  // Serial stimulus: drive a byte onto ser_rx (8N1, LSB first).
  // Timing matches the DUT's divider convention:
  // - TX/RX advance when divcnt > cfg_divider, i.e. every (cfg_divider + 2) clocks
  //   due to the strict '>' compare against an incrementing counter starting at 0.
  // - RX samples bit0 about 1.5 bit-times after start detection.
  task uart_drive_rx_byte(input [7:0] b, input integer div);
    integer i;
    integer bit_clks;
    begin
      bit_clks = div + 2;

      // Idle high for at least one bit
      @(negedge clk);
      ser_rx = 1'b1;
      repeat (bit_clks) @(posedge clk);

      // Start bit
      @(negedge clk);
      ser_rx = 1'b0;
      repeat (bit_clks) @(posedge clk);

      // Data bits (LSB first)
      for (i = 0; i < 8; i = i + 1) begin
        @(negedge clk);
        ser_rx = b[i];
        repeat (bit_clks) @(posedge clk);
      end

      // Stop bit
      @(negedge clk);
      ser_rx = 1'b1;
      repeat (bit_clks) @(posedge clk);
    end
  endtask

  // Decode TX into a byte using the same divider timing.
  task uart_capture_tx_byte(output [7:0] b, input integer div);
    integer i;
    integer bit_clks;
    integer half_clks;
    integer guard;
    begin
      bit_clks  = div + 2;
      half_clks = (bit_clks / 2);

      // Wait for start bit (ser_tx low)
      guard = 0;
      while (ser_tx !== 1'b0) begin
        @(posedge clk);
        guard = guard + 1;
        if (guard > 200000)
          fail("timeout waiting for TX start bit");
      end

      // Move to center of bit0
      repeat (half_clks + bit_clks) @(posedge clk);

      // Sample 8 bits
      for (i = 0; i < 8; i = i + 1) begin
        b[i] = ser_tx;
        repeat (bit_clks) @(posedge clk);
      end

      // Basic stop-bit check (should be high)
      if (ser_tx !== 1'b1)
        fail("stop bit was not high");
    end
  endtask

  // Test sequence
  reg [31:0] div;
  reg [7:0] tx_b, rx_b, tx_b2;
  reg [7:0] cap_b, cap_b2;
  integer rx_guard;
  integer busy_guard;
  reg saw_busy_wait;

  initial begin
    // Global watchdog to prevent WSL stalls on hangs
    #5000000;
    fail("global timeout");
  end

  initial begin
    // Defaults
    resetn     = 1'b0;
    ser_rx     = 1'b1;
    reg_div_we = 4'h0;
    reg_div_di = 32'h0;
    reg_dat_we = 1'b0;
    reg_dat_re = 1'b0;
    reg_dat_di = 32'h0;

    // Reset
    repeat (5) @(posedge clk);
    resetn = 1'b1;
    repeat (2) @(posedge clk);

    // Baseline: divider comes up as 1 (current DEFAULT_DIV)
    if (reg_div_do !== 32'd1)
      fail("reg_div_do reset value mismatch (expected 1)");
    if (reg_dat_wait !== 1'b0)
      fail("reg_dat_wait should be low after reset when no write is active");

    // Partial divider writes should respect byte enables.
    uart_write_divider(32'h0000_0000);
    if (reg_div_do !== 32'h0000_0000)
      fail("reg_div_do mismatch after clear");

    uart_write_divider_masked(32'h0000_00AA, 4'b0001);
    if (reg_div_do !== 32'h0000_00AA)
      fail("reg_div_do mismatch after low-byte write");

    uart_write_divider_masked(32'h5500_0000, 4'b1000);
    if (reg_div_do !== 32'h5500_00AA)
      fail("reg_div_do mismatch after high-byte write");

    // Program a small divider for faster sim and deterministic timing
    div = 32'd6;
    uart_write_divider(div);
    $display("INFO: divider write: reg_div_do=%0d expected=%0d at t=%0t", reg_div_do, div, $time);
    if (reg_div_do !== div)
      fail("reg_div_do mismatch after write");
    $display("INFO: divider programmed to %0d at t=%0t", div, $time);

    // TX test: write byte, capture on ser_tx
    tx_b = 8'hA6;
    $display("INFO: starting TX of 0x%02h at t=%0t (ser_tx=%b)", tx_b, $time, ser_tx);
    fork
      begin
        uart_capture_tx_byte(cap_b, div);
      end
      begin
        uart_write_data_byte(tx_b);
        $display("INFO: write_data_byte completed at t=%0t (ser_tx=%b)", $time, ser_tx);
      end
    join
    if (cap_b !== tx_b) begin
      $display("ERROR: TX capture mismatch: got=%02h exp=%02h", cap_b, tx_b);
      fail("TX capture mismatch");
    end
    if (reg_dat_wait !== 1'b0)
      fail("reg_dat_wait should return low after TX completes");

    // Busy-path check: hold a second write request while the first byte is still transmitting.
    tx_b  = 8'h5A;
    tx_b2 = 8'hC3;
    $display("INFO: starting busy-path TX test at t=%0t", $time);
    fork
      begin
        uart_capture_tx_byte(cap_b, div);
        uart_capture_tx_byte(cap_b2, div);
      end
      begin
        uart_write_data_byte(tx_b);
        // Wait a couple of clocks so the first frame is unquestionably in flight,
        // then hold a second write request until the transmitter becomes idle again.
        repeat (2) @(posedge clk);
        uart_start_data_write(tx_b2);
        saw_busy_wait = 1'b0;
        busy_guard = 0;
        begin : wait_for_second_accept
          while (1) begin
            @(posedge clk);
            busy_guard = busy_guard + 1;
            if (reg_dat_wait === 1'b1)
              saw_busy_wait = 1'b1;
            if (reg_dat_wait === 1'b0 && saw_busy_wait)
              disable wait_for_second_accept;
            if (busy_guard > 200000) begin
              fail("timeout waiting for queued TX write acceptance");
              disable wait_for_second_accept;
            end
          end
        end
        uart_finish_data_write();
      end
    join
    if (!saw_busy_wait)
      fail("reg_dat_wait never asserted while a second write was held during active TX");
    if (cap_b !== tx_b) begin
      $display("ERROR: first busy-path TX mismatch: got=%02h exp=%02h", cap_b, tx_b);
      fail("first busy-path TX mismatch");
    end
    if (cap_b2 !== tx_b2) begin
      $display("ERROR: second busy-path TX mismatch: got=%02h exp=%02h", cap_b2, tx_b2);
      fail("second busy-path TX mismatch");
    end
    if (reg_dat_wait !== 1'b0)
      fail("reg_dat_wait should be low after queued TX sequence completes");

    // RX test: drive a byte on ser_rx, wait for reg_dat_do to become valid
    rx_b = 8'h3C;
    $display("INFO: starting RX drive of 0x%02h at t=%0t", rx_b, $time);
    uart_drive_rx_byte(rx_b, div);

    // Wait until the received byte appears on reg_dat_do (exact match avoids X-state false positives)
    rx_guard = 0;
    while (reg_dat_do !== {24'h0, rx_b}) begin
      @(posedge clk);
      rx_guard = rx_guard + 1;
      if (rx_guard > 200000)
        fail("timeout waiting for RX data match");
    end

    // Consume RX and ensure valid clears (goes back to ~0)
    uart_pulse_dat_re();
    if (reg_dat_do !== 32'hFFFF_FFFF)
      fail("reg_dat_do did not clear after reg_dat_re");

    // Idle RX line should not spontaneously create received data.
    repeat (3 * (div + 2)) @(posedge clk);
    if (reg_dat_do !== 32'hFFFF_FFFF)
      fail("reg_dat_do should stay invalid while RX line is idle");

    // A second clean RX frame should be accepted after clearing the first one.
    rx_b = 8'h96;
    $display("INFO: starting second RX drive of 0x%02h at t=%0t", rx_b, $time);
    uart_drive_rx_byte(rx_b, div);
    rx_guard = 0;
    while (reg_dat_do !== {24'h0, rx_b}) begin
      @(posedge clk);
      rx_guard = rx_guard + 1;
      if (rx_guard > 200000)
        fail("timeout waiting for second RX data match");
    end
    uart_pulse_dat_re();
    if (reg_dat_do !== 32'hFFFF_FFFF)
      fail("reg_dat_do did not clear after second reg_dat_re");

    $display("PASS: uart core TB completed successfully.");
    $finish;
  end

endmodule

