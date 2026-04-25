`timescale 1ns / 1ps

module tb_demo;

    reg clk;
    reg rst;

    reg        uart_rx_event;
    reg [7:0]  uart_rx_event_data;
    reg [3:0]  gpio_pin_event;
    reg [3:0]  gpio_pin_state;

    wire [31:0] wb_rd_data;
    wire [4:0]  wb_rd_addr;
    wire        wb_reg_write;
    wire [31:0] wb_pc;
    wire        wb_valid;

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
        $readmemh("test_demo.mem", u_processor.u_memory_subsystem.u_bram.ram);
    end

    // Stimulus
    initial begin
        clk                = 0;
        rst                = 1;
        uart_rx_event      = 1'b0;
        uart_rx_event_data = 8'b0;
        gpio_pin_event     = 4'b0;
        gpio_pin_state     = 4'b0;
        cycle_count        = 0;

        #40;
        rst = 0;

        // Run long enough for the program to complete
        repeat (500) @(posedge clk);

        // Results
        $display("");
        $display("=============================================");
        $display("Demo results after %0d cycles:", cycle_count);
        $display("  x10 = %08h (expected 00000100 - array base)",
                 u_processor.u_datapath.u_id_stage.u_regfile.regs[10]);
        $display("  x11 = %08h (expected 00000000 - loop counter)",
                 u_processor.u_datapath.u_id_stage.u_regfile.regs[11]);
        $display("  x12 = %08h (expected 00000120 - end pointer)",
                 u_processor.u_datapath.u_id_stage.u_regfile.regs[12]);
        $display("  x13 = %08h (expected 000000cc - sum of squares = 204)",
                 u_processor.u_datapath.u_id_stage.u_regfile.regs[13]);
        $display("  x14 = %08h (expected 00000008 - last value loaded)",
                 u_processor.u_datapath.u_id_stage.u_regfile.regs[14]);
        $display("  x15 = %08h (expected 00000040 - last square = 64)",
                 u_processor.u_datapath.u_id_stage.u_regfile.regs[15]);
        $display("  x20 = %08h (expected 00000555 - halt marker)",
                 u_processor.u_datapath.u_id_stage.u_regfile.regs[20]);
        $display("=============================================");

        if (u_processor.u_datapath.u_id_stage.u_regfile.regs[10] == 32'h00000100 &&
            u_processor.u_datapath.u_id_stage.u_regfile.regs[11] == 32'h00000000 &&
            u_processor.u_datapath.u_id_stage.u_regfile.regs[12] == 32'h00000120 &&
            u_processor.u_datapath.u_id_stage.u_regfile.regs[13] == 32'h000000cc &&
            u_processor.u_datapath.u_id_stage.u_regfile.regs[14] == 32'h00000008 &&
            u_processor.u_datapath.u_id_stage.u_regfile.regs[15] == 32'h00000040 &&
            u_processor.u_datapath.u_id_stage.u_regfile.regs[20] == 32'h00000555) begin
            $display("*** DEMO TEST PASSED ***");
        end else begin
            $display("*** DEMO TEST FAILED ***");
        end

        $finish;
    end

endmodule