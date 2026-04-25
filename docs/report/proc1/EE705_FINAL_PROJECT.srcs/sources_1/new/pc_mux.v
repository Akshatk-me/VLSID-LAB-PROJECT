`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2026 12:22:33 PM
// Design Name: 
// Module Name: pc_mux
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
// pc_mux.v
// PC mux for the front end. Selects the next PC from one of:
//   00 = pc_plus_4    (sequential)
//   01 = branch_addr  (taken branch/jump from EX/MEM1)
//   10 = mtvec        (trap entry, base address from CSR)
//   11 = mepc         (MRET, return address from CSR)
//
// Driven by the hazard unit's pc_sel signal.
// Purely combinational.
// =============================================================================

module pc_mux (
    input  wire [1:0]  pc_sel,
    input  wire [31:0] pc_plus_4,
    input  wire [31:0] branch_addr,
    input  wire [31:0] mtvec,
    input  wire [31:0] mepc,
    output reg  [31:0] next_pc
);

    always @(*) begin
        case (pc_sel)
            2'b00: next_pc = pc_plus_4;
            2'b01: next_pc = branch_addr;
            2'b10: next_pc = mtvec;
            2'b11: next_pc = mepc;
            default: next_pc = pc_plus_4;
        endcase
    end

endmodule
