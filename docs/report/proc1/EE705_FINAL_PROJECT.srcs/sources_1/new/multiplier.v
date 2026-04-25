`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 11:01:52 AM
// Design Name: 
// Module Name: multiplier
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
// multiplier.v
// Dummy combinational 32x32 -> 64-bit multiplier for the RV32IM core.
// No pipelining; produces results in a single cycle.
//
// mul_op encoding (matches the control unit):
//   00 = no multiply (outputs are zero)
//   01 = signed   x signed     (MUL, MULH)
//   10 = unsigned x signed     (MULHSU)
//   11 = unsigned x unsigned   (MULHU)
//
// MULHSU note: rs1 is treated as UNSIGNED, rs2 as SIGNED.
// (RISC-V spec: "MULHSU is used in multi-word signed-unsigned multiplications
//  where rs1 contains the unsigned value and rs2 contains the signed value.")
//
// Outputs:
//   mul_low  : lower 32 bits of the 64-bit product (used by MUL)
//   mul_high : upper 32 bits of the 64-bit product (used by MULH/MULHU/MULHSU)
//
// The ex_result_mux uses ex_result_src to pick mul_low (code 100) or mul_high
// (code 101) based on which multiply variant the instruction is.
// =============================================================================

module multiplier (
    input  wire [1:0]  mul_op,
    input  wire [31:0] a,        // rs1
    input  wire [31:0] b,        // rs2
    output reg  [31:0] mul_low,
    output reg  [31:0] mul_high
);

    // 64-bit operand extensions for each variant
    wire signed [63:0] a_sext = {{32{a[31]}}, a};
    wire signed [63:0] b_sext = {{32{b[31]}}, b};
    wire        [63:0] a_zext = {32'b0, a};
    wire        [63:0] b_zext = {32'b0, b};

    // 64-bit products for each combination
    wire signed [63:0] prod_ss = a_sext * b_sext;          // signed   x signed
    wire        [63:0] prod_uu = a_zext * b_zext;          // unsigned x unsigned
    // For unsigned x signed: a is unsigned (zero-extend), b is signed (sign-extend)
    wire signed [63:0] prod_us = $signed(a_zext) * b_sext;

    always @(*) begin
        case (mul_op)
            2'b00: begin
                mul_low  = 32'b0;
                mul_high = 32'b0;
            end
            2'b01: begin  // signed x signed (MUL, MULH)
                mul_low  = prod_ss[31:0];
                mul_high = prod_ss[63:32];
            end
            2'b10: begin  // unsigned x signed (MULHSU)
                mul_low  = prod_us[31:0];
                mul_high = prod_us[63:32];
            end
            2'b11: begin  // unsigned x unsigned (MULHU)
                mul_low  = prod_uu[31:0];
                mul_high = prod_uu[63:32];
            end
            default: begin
                mul_low  = 32'b0;
                mul_high = 32'b0;
            end
        endcase
    end

endmodule
