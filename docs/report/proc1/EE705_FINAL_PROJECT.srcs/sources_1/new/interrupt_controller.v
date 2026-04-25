`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2026 10:02:12 AM
// Design Name: 
// Module Name: interrupt_controller
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
// interrupt_controller.v
// 5-input interrupt controller with 3-state FSM.
// Sources (priority: bit 0 highest): UART (bit 0), GPIO0..3 (bits 1..4)
// =============================================================================

module interrupt_controller (
    input  wire       clk,
    input  wire       rst,

    // Raw interrupt lines from peripherals
    input  wire [4:0] irq_lines,

    // CSR hardware interface
    input  wire [4:0] hw_int_en,
    input  wire       hw_mstatus_mie,

    // Handshake with hazard/trap logic
    input  wire       trap_entry,   // ack: trap has been taken
    input  wire       mret,         // ack: handler finished

    // Outputs
    output reg        trap_req,
    output reg  [2:0] trap_cause    // 0..4 = source ID
);

    // FSM states
    localparam [1:0] S0_IDLE      = 2'b00;
    localparam [1:0] S1_REQUEST   = 2'b01;
    localparam [1:0] S2_SERVICING = 2'b10;

    reg [1:0] state;
    reg [2:0] cause_latch;

    // Combinational: masked interrupt vector
    wire [4:0] masked = irq_lines & hw_int_en & {5{hw_mstatus_mie}};
    wire       any_pending = |masked;

    // Combinational priority encoder: lowest bit wins
    reg [2:0] priority_cause;
    always @(*) begin
        casez (masked)
            5'b????1: priority_cause = 3'd0;  // UART
            5'b???10: priority_cause = 3'd1;  // GPIO0
            5'b??100: priority_cause = 3'd2;  // GPIO1
            5'b?1000: priority_cause = 3'd3;  // GPIO2
            5'b10000: priority_cause = 3'd4;  // GPIO3
            default:  priority_cause = 3'd0;
        endcase
    end

    // FSM
    always @(posedge clk) begin
        if (rst) begin
            state       <= S0_IDLE;
            cause_latch <= 3'd0;
        end else begin
            case (state)
                S0_IDLE: begin
                    if (any_pending) begin
                        cause_latch <= priority_cause;
                        state       <= S1_REQUEST;
                    end
                end

                S1_REQUEST: begin
                    if (trap_entry) begin
                        state <= S2_SERVICING;
                    end
                end

                S2_SERVICING: begin
                    if (mret) begin
                        if (any_pending) begin
                            cause_latch <= priority_cause;
                            state       <= S1_REQUEST;
                        end else begin
                            state <= S0_IDLE;
                        end
                    end
                end

                default: state <= S0_IDLE;
            endcase
        end
    end

    // Outputs
    always @(*) begin
        case (state)
            S1_REQUEST: begin
                trap_req   = 1'b1;
                trap_cause = cause_latch;
            end
            default: begin
                trap_req   = 1'b0;
                trap_cause = cause_latch;
            end
        endcase
    end

endmodule