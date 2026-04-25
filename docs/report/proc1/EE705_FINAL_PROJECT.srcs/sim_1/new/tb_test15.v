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

module tb_test15;

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
        $readmemh("test15.mem", u_processor.u_memory_subsystem.u_bram.ram);
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
$display("Array sum test:");
$display("  x6 = %08h (expected 00000024)", u_processor.u_datapath.u_id_stage.u_regfile.regs[6]);
$display("  x3 = %08h (expected 00000000)", u_processor.u_datapath.u_id_stage.u_regfile.regs[3]);

if (u_processor.u_datapath.u_id_stage.u_regfile.regs[6] == 32'h00000024 &&
    u_processor.u_datapath.u_id_stage.u_regfile.regs[3] == 32'h00000000) begin
    $display("*** ARRAY SUM PASSED ***");
end else begin
    $display("*** ARRAY SUM FAILED ***");
end
        $finish;
    end

    // -------------------------------------------------------------------------
    // Waveform dump (optional)
    // -------------------------------------------------------------------------


endmodule


