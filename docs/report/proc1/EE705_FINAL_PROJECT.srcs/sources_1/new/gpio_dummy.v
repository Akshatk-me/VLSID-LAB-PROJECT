`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2026 05:34:26 AM
// Design Name: 
// Module Name: gpio_dummy
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
// gpio_dummy.v
// Functional 4-pin GPIO model for interrupt path testing.
// Not a real GPIO - does not interface with actual pins.
//
// Registers (mmio_addr offsets within GPIO region):
//   0x0 IN          : current pin states (4 bits, low)
//   0x4 INT_PENDING : per-pin pending interrupt bits (4 bits)
//                     Software clears by writing 1 to that bit position.
//   0x8 INT_ENABLE  : per-pin interrupt enable mask (4 bits)
//
// External events:
//   pin_event[3:0] : 1-cycle pulse per pin from testbench. Sets the
//                    corresponding pending bit.
//   pin_state[3:0] : current pin state, exposed via IN register.
//
// Interrupts:
//   irq_gpio[3:0] : per-pin interrupt outputs = int_pending & int_enable
// =============================================================================

module gpio_dummy (
    input  wire        clk,
    input  wire        rst,

    // MMIO interface
    input  wire        mmio_wen,
    input  wire [3:0]  mmio_addr,
    input  wire [31:0] mmio_wdata,
    input  wire        mmio_ren,
    output reg  [31:0] mmio_rdata,

    // External events
    input  wire [3:0]  pin_event,
    input  wire [3:0]  pin_state,

    // Interrupts to controller
    output wire [3:0]  irq_gpio
);

    localparam [3:0] REG_IN          = 4'h0;
    localparam [3:0] REG_INT_PENDING = 4'h4;
    localparam [3:0] REG_INT_ENABLE  = 4'h8;

    reg [3:0] int_pending;
    reg [3:0] int_enable;

    always @(posedge clk) begin
        if (rst) begin
            int_pending <= 4'b0;
            int_enable  <= 4'b0;
        end else begin
            // INT_ENABLE writes
            if (mmio_wen && mmio_addr == REG_INT_ENABLE) begin
                int_enable <= mmio_wdata[3:0];
            end

            // INT_PENDING: write 1 to clear (per bit)
            // Combine clear with new pin events: events set, writes clear.
            if (mmio_wen && mmio_addr == REG_INT_PENDING) begin
                int_pending <= (int_pending & ~mmio_wdata[3:0]) | pin_event;
            end else begin
                int_pending <= int_pending | pin_event;
            end
        end
    end

    // Read mux
    always @(*) begin
        case (mmio_addr)
            REG_IN:          mmio_rdata = {28'b0, pin_state};
            REG_INT_PENDING: mmio_rdata = {28'b0, int_pending};
            REG_INT_ENABLE:  mmio_rdata = {28'b0, int_enable};
            default:         mmio_rdata = 32'b0;
        endcase
    end

    assign irq_gpio = int_pending & int_enable;

endmodule
