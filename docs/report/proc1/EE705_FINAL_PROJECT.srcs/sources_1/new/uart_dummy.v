`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2026 05:34:26 AM
// Design Name: 
// Module Name: uart_dummy
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
// uart_dummy.v
// Functional UART model for interrupt path testing.
// Not a real UART - does not actually send/receive serial data.
//
// Registers (mmio_addr offsets within UART region):
//   0x0 STATUS : bit 0 = RX ready (1 = byte available)
//                Reading STATUS auto-clears RX ready and deasserts irq.
//   0x4 DATA   : received byte (low 8 bits, upper 24 bits = 0)
//   0x8 CTRL   : bit 0 = enable (gates irq generation)
//
// External event:
//   rx_event : 1-cycle pulse from testbench. Sets RX ready, latches a byte
//              into DATA from rx_event_data. If RX ready is already set, the
//              new event overwrites the old byte (functional model only).
//
// Interrupt:
//   irq_uart : asserted when (rx_ready && enable). Cleared when software
//              reads STATUS register.
// =============================================================================

module uart_dummy (
    input  wire        clk,
    input  wire        rst,

    // MMIO interface
    input  wire        mmio_wen,
    input  wire [3:0]  mmio_addr,
    input  wire [31:0] mmio_wdata,
    input  wire        mmio_ren,        // read strobe (needed for STATUS auto-clear)
    output reg  [31:0] mmio_rdata,

    // External event from testbench
    input  wire        rx_event,
    input  wire [7:0]  rx_event_data,

    // Interrupt to controller
    output wire        irq_uart
);

    // Register offsets
    localparam [3:0] REG_STATUS = 4'h0;
    localparam [3:0] REG_DATA   = 4'h4;
    localparam [3:0] REG_CTRL   = 4'h8;

    reg        rx_ready;
    reg [7:0]  rx_data;
    reg        enable;

    // Auto-clear RX ready on STATUS read
    wire status_read = mmio_ren && (mmio_addr == REG_STATUS);

    always @(posedge clk) begin
        if (rst) begin
            rx_ready <= 1'b0;
            rx_data  <= 8'b0;
            enable   <= 1'b0;
        end else begin
            // CTRL writes
            if (mmio_wen && mmio_addr == REG_CTRL) begin
                enable <= mmio_wdata[0];
            end

            // RX event from testbench: latch data and set ready
            if (rx_event) begin
                rx_data  <= rx_event_data;
                rx_ready <= 1'b1;
            end

            // Auto-clear on STATUS read (lower priority than rx_event so a
            // simultaneous event doesn't get lost)
            if (status_read && !rx_event) begin
                rx_ready <= 1'b0;
            end
        end
    end

    // Read mux
    always @(*) begin
        case (mmio_addr)
            REG_STATUS: mmio_rdata = {31'b0, rx_ready};
            REG_DATA:   mmio_rdata = {24'b0, rx_data};
            REG_CTRL:   mmio_rdata = {31'b0, enable};
            default:    mmio_rdata = 32'b0;
        endcase
    end

    assign irq_uart = rx_ready & enable;

endmodule