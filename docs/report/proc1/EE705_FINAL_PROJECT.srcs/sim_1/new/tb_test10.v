`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2026 05:17:20 AM
// Design Name: 
// Module Name: tb_test10
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2026 02:01:52 AM
// Design Name: 
// Module Name: tb_test1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2026 05:10:00 PM
// Design Name: 
// Module Name: tb_processor_fib
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// =============================================================================
// tb_processor_fib.v
// Testbench for processor.v running the Fibonacci program.
//
// Loads fibonacci.mem into the BRAM via $readmemh, resets the processor,
// runs for a bounded number of cycles, then checks the regfile for the
// expected end state.
//
// Expected after convergence (n=10, program returns F(9)=34):
//   x5  = 1
//   x6  = 21
//   x7  = 34
//   x10 = 34
//   x28 = 1
//   PC stuck at 0x44 (infinite loop)
// =============================================================================

`timescale 1ns / 1ps

module tb_test10;

    // -------------------------------------------------------------------------
    // Clock and reset
    // -------------------------------------------------------------------------
    reg clk;
    reg rst;

    always #5 clk = ~clk;  // 10ns period, 100 MHz

    // -------------------------------------------------------------------------
    // Peripheral event inputs (unused for this test)
    // -------------------------------------------------------------------------
    reg        uart_rx_event      = 1'b0;
    reg  [7:0] uart_rx_event_data = 8'b0;
    reg  [3:0] gpio_pin_event     = 4'b0;
    reg  [3:0] gpio_pin_state     = 4'b0;

    // -------------------------------------------------------------------------
    // Observation signals from processor
    // -------------------------------------------------------------------------
    wire [31:0] wb_rd_data;
    wire [4:0]  wb_rd_addr;
    wire        wb_reg_write;
    wire [31:0] wb_pc;
    wire        wb_valid;

    // -------------------------------------------------------------------------
    // DUT
    // -------------------------------------------------------------------------
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

    // -------------------------------------------------------------------------
    // Load program into BRAM
    // -------------------------------------------------------------------------
    initial begin
        // Path: hierarchical reference to the BRAM's internal storage.
        // Adjust "mem" to match the actual reg array name inside bram.v.
        $readmemh("test10.mem", u_processor.u_memory_subsystem.u_bram.ram);
    end

    // -------------------------------------------------------------------------
    // Writeback tracing
    // -------------------------------------------------------------------------
    integer cycle_count;
    integer commit_count;

    always @(posedge clk) begin
        if (rst) begin
            cycle_count  <= 0;
            commit_count <= 0;
        end else begin
            cycle_count <= cycle_count + 1;

            if (wb_valid && wb_reg_write && (wb_rd_addr != 5'd0)) begin
                commit_count <= commit_count + 1;
                $display("[cyc %4d] WB: pc=%08h  x%0d <= %08h",
                         cycle_count, wb_pc, wb_rd_addr, wb_rd_data);
            end
        end
    end

    // -------------------------------------------------------------------------
    // Timeout / verification
    // -------------------------------------------------------------------------
    initial begin
        // Initialize
        clk = 0;
        rst = 1;

        // Release reset after a few cycles
        #25 rst = 0;

        // Run for 500 cycles
        #5000;

        // -----------------------------------------------------------------
        // Check final register state
        // Adjust the hierarchical path if your regfile instance name differs.
        // -----------------------------------------------------------------
$display("Mega branch test results after %0d cycles:", cycle_count);
$display("  x1  = %08h (expected 00000005)", u_processor.u_datapath.u_id_stage.u_regfile.regs[1]);
$display("  x4  = %08h (expected ffffffff)", u_processor.u_datapath.u_id_stage.u_regfile.regs[4]);
$display("  x5  = %08h (expected 00000000)", u_processor.u_datapath.u_id_stage.u_regfile.regs[5]);
$display("  x6  = %08h (expected 00000006)", u_processor.u_datapath.u_id_stage.u_regfile.regs[6]);
$display("  x10 = %08h (expected 00000000)", u_processor.u_datapath.u_id_stage.u_regfile.regs[10]);
$display("  x11 = %08h (expected 00000000)", u_processor.u_datapath.u_id_stage.u_regfile.regs[11]);
$display("  x12 = %08h (expected 00000000)", u_processor.u_datapath.u_id_stage.u_regfile.regs[12]);
$display("  x13 = %08h (expected 00000000)", u_processor.u_datapath.u_id_stage.u_regfile.regs[13]);
$display("  x14 = %08h (expected 0000002a)", u_processor.u_datapath.u_id_stage.u_regfile.regs[14]);
$display("  x15 = %08h (expected 00000000)", u_processor.u_datapath.u_id_stage.u_regfile.regs[15]);
$display("  x16 = %08h (expected 00000044)", u_processor.u_datapath.u_id_stage.u_regfile.regs[16]);
$display("  x17 = %08h (expected 00000000)", u_processor.u_datapath.u_id_stage.u_regfile.regs[17]);
$display("  x18 = %08h (expected 00000068)", u_processor.u_datapath.u_id_stage.u_regfile.regs[18]);
$display("  x19 = %08h (expected 00000064)", u_processor.u_datapath.u_id_stage.u_regfile.regs[19]);
$display("  x20 = %08h (expected 00000000)", u_processor.u_datapath.u_id_stage.u_regfile.regs[20]);
$display("  x21 = %08h (expected 0000004d)", u_processor.u_datapath.u_id_stage.u_regfile.regs[21]);

if (u_processor.u_datapath.u_id_stage.u_regfile.regs[5]  == 32'h00000000 &&
    u_processor.u_datapath.u_id_stage.u_regfile.regs[6]  == 32'h00000006 &&
    u_processor.u_datapath.u_id_stage.u_regfile.regs[10] == 32'h00000000 &&
    u_processor.u_datapath.u_id_stage.u_regfile.regs[11] == 32'h00000000 &&
    u_processor.u_datapath.u_id_stage.u_regfile.regs[12] == 32'h00000000 &&
    u_processor.u_datapath.u_id_stage.u_regfile.regs[13] == 32'h00000000 &&
    u_processor.u_datapath.u_id_stage.u_regfile.regs[14] == 32'h0000002a &&
    u_processor.u_datapath.u_id_stage.u_regfile.regs[15] == 32'h00000000 &&
    u_processor.u_datapath.u_id_stage.u_regfile.regs[16] == 32'h00000044 &&
    u_processor.u_datapath.u_id_stage.u_regfile.regs[17] == 32'h00000000 &&
    u_processor.u_datapath.u_id_stage.u_regfile.regs[18] == 32'h00000068 &&
    u_processor.u_datapath.u_id_stage.u_regfile.regs[19] == 32'h00000064 &&
    u_processor.u_datapath.u_id_stage.u_regfile.regs[20] == 32'h00000000 &&
    u_processor.u_datapath.u_id_stage.u_regfile.regs[21] == 32'h0000004d) begin
    $display("*** MEGA BRANCH TEST PASSED ***");
end else begin
    $display("*** MEGA BRANCH TEST FAILED ***");
end
        $finish;
    end

    // -------------------------------------------------------------------------
    // Waveform dump (optional)
    // -------------------------------------------------------------------------


endmodule


