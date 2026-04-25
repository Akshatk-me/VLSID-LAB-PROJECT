`timescale 1ns / 1ps

module tb_trap;

    reg clk;
    reg rst;

    // Testbench-driven event inputs
    reg        uart_rx_event;
    reg [7:0]  uart_rx_event_data;
    reg [3:0]  gpio_pin_event;
    reg [3:0]  gpio_pin_state;

    // Observation outputs
    wire [31:0] wb_rd_data;
    wire [4:0]  wb_rd_addr;
    wire        wb_reg_write;
    wire [31:0] wb_pc;
    wire        wb_valid;

    // DUT
    processor u_processor (
        .clk                (clk),
        .rst                (rst),
        .uart_rx_event      (uart_rx_event),
        .uart_rx_event_data (uart_rx_event_data),
        .gpio_pin_event     (gpio_pin_event),
        .gpio_pin_state     (gpio_pin_state),
        .wb_rd_data         (wb_rd_data),
        .wb_rd_addr         (wb_rd_addr),
        .wb_reg_write       (wb_reg_write),
        .wb_pc              (wb_pc),
        .wb_valid           (wb_valid)
    );

    // Clock
    always #5 clk = ~clk;

    // Cycle counter
    integer cycle_count;
    always @(posedge clk) begin
        if (rst) cycle_count <= 0;
        else     cycle_count <= cycle_count + 1;
    end

    // Writeback trace
    always @(posedge clk) begin
        if (!rst && wb_valid && wb_reg_write && wb_rd_addr != 5'd0) begin
            $display("[cyc %4d] WB: pc=%08h  x%0d <= %08h",
                     cycle_count, wb_pc, wb_rd_addr, wb_rd_data);
        end
    end

    // Load program
    initial begin
        $readmemh("test_trap.mem", u_processor.u_memory_subsystem.u_bram.ram);
    end

    // Stimulus
    initial begin
        clk                = 0;
        rst                = 1;
        uart_rx_event      = 1'b0;
        uart_rx_event_data = 8'h00;
        gpio_pin_event     = 4'b0000;
        gpio_pin_state     = 4'b0000;
        cycle_count        = 0;

        #40;
        rst = 0;

        // Wait for main program to reach the spinloop
        repeat (80) @(posedge clk);

        // Fire UART RX event
        $display("[cyc %4d] *** Firing UART RX event ***", cycle_count);
        uart_rx_event      = 1'b1;
        uart_rx_event_data = 8'h42;
        @(posedge clk);
        uart_rx_event      = 1'b0;
        $display("[cyc %4d] *** UART event released ***", cycle_count);

        // Let handler run and return
        repeat (400) @(posedge clk);

        // Results
        $display("");
        $display("=============================================");
        $display("Trap test results after %0d cycles:", cycle_count);
        $display("  x10 = %08h (expected 00000555 - pre-trap marker)",
                 u_processor.u_datapath.u_id_stage.u_regfile.regs[10]);
        $display("  x11 = %08h (spin counter, should be > 0)",
                 u_processor.u_datapath.u_id_stage.u_regfile.regs[11]);
        $display("  x20 = %08h (expected 00000666 - handler marker)",
                 u_processor.u_datapath.u_id_stage.u_regfile.regs[20]);
        $display("  x21 = %08h (mcause)",
                 u_processor.u_datapath.u_id_stage.u_regfile.regs[21]);
        $display("  x22 = %08h (mepc - should be 0x1C or 0x20)",
                 u_processor.u_datapath.u_id_stage.u_regfile.regs[22]);
        $display("=============================================");

        if (u_processor.u_datapath.u_id_stage.u_regfile.regs[10] == 32'h00000555 &&
            u_processor.u_datapath.u_id_stage.u_regfile.regs[20] == 32'h00000666 &&
            u_processor.u_datapath.u_id_stage.u_regfile.regs[11] != 32'h00000000 &&
            (u_processor.u_datapath.u_id_stage.u_regfile.regs[22] == 32'h0000001C ||
             u_processor.u_datapath.u_id_stage.u_regfile.regs[22] == 32'h00000020)) begin
            $display("*** TRAP TEST PASSED ***");
        end else begin
            $display("*** TRAP TEST FAILED ***");
        end

        $finish;
    end

endmodule