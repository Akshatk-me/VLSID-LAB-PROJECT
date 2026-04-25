// =============================================================================
// processor_tb.v
// Test wrapper around processor.v for the Fibonacci demo.
// Ties off peripherals and exposes only the registers used by the program.
// =============================================================================

module processor_tb (
    input  wire        clk,
    input  wire        rst,

    // Symbolic register taps for the Fibonacci demo
    output wire [31:0] fib_n,          // x5  - input counter
    output wire [31:0] fib_prev2,      // x6  - F[i-2]
    output wire [31:0] fib_prev1,      // x7  - F[i-1]
    output wire [31:0] fib_result,     // x10 - current/final result
    output wire [31:0] fib_const_one   // x28 - constant 1
);

    // Peripheral event inputs tied to 0 (no interrupts for this demo)
    wire        uart_rx_event      = 1'b0;
    wire [7:0]  uart_rx_event_data = 8'b0;
    wire [3:0]  gpio_pin_event     = 4'b0;
    wire [3:0]  gpio_pin_state     = 4'b0;

    // Writeback stream from processor - required by port list but not exposed
    wire [31:0] wb_rd_data_int;
    wire [4:0]  wb_rd_addr_int;
    wire        wb_reg_write_int;
    wire [31:0] wb_pc_int;
    wire        wb_valid_int;

    // Instantiate the real processor
    processor u_processor (
        .clk                (clk),
        .rst                (rst),
        .uart_rx_event      (uart_rx_event),
        .uart_rx_event_data (uart_rx_event_data),
        .gpio_pin_event     (gpio_pin_event),
        .gpio_pin_state     (gpio_pin_state),
        .wb_rd_data         (wb_rd_data_int),
        .wb_rd_addr         (wb_rd_addr_int),
        .wb_reg_write       (wb_reg_write_int),
        .wb_pc              (wb_pc_int),
        .wb_valid           (wb_valid_int)
    );

    // Hierarchical taps into the regfile
    assign fib_n         = u_processor.u_datapath.u_id_stage.u_regfile.regs[5];
    assign fib_prev2     = u_processor.u_datapath.u_id_stage.u_regfile.regs[6];
    assign fib_prev1     = u_processor.u_datapath.u_id_stage.u_regfile.regs[7];
    assign fib_result    = u_processor.u_datapath.u_id_stage.u_regfile.regs[10];
    assign fib_const_one = u_processor.u_datapath.u_id_stage.u_regfile.regs[28];

endmodule