`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 10:08:59 AM
// Design Name: 
// Module Name: alu
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
// alu.v
// 32-bit ALU for the RV32I core. Behavioral implementation.
//
// alu_op encoding:
//   0000 ADD     0001 SUB     0010 AND     0011 OR
//   0100 XOR     0101 SLL     0110 SRL     0111 SRA
//   1000 SLT     1001 SLTU    1010 ANDN (a & ~b, used for CSRRC)
//
// Outputs:
//   alu_out : 32-bit result
//   flag_z  : zero flag    (alu_out == 0)
//   flag_n  : negative     (alu_out[31])
//   flag_v  : signed overflow (only meaningful for ADD/SUB)
//   flag_c  : carry/borrow (only meaningful for ADD/SUB; for SUB it's
//             the unsigned-less-than indicator: 1 if a < b unsigned)
//
// Flags are produced for every op (so the branch comparator can read them
// after a SUB), but only the SUB result's flags are used for branches.
//
// Shift amount for SLL/SRL/SRA is taken from b[4:0] (RV32I rule).
// =============================================================================

module alu (
    input  wire [3:0]  alu_op,
    input  wire [31:0] a,
    input  wire [31:0] b,
    output reg  [31:0] alu_out,
    output wire        flag_z,
    output wire        flag_n,
    output reg         flag_v,
    output reg         flag_c
);

    // Op constants
    localparam [3:0] OP_ADD  = 4'b0000;
    localparam [3:0] OP_SUB  = 4'b0001;
    localparam [3:0] OP_AND  = 4'b0010;
    localparam [3:0] OP_OR   = 4'b0011;
    localparam [3:0] OP_XOR  = 4'b0100;
    localparam [3:0] OP_SLL  = 4'b0101;
    localparam [3:0] OP_SRL  = 4'b0110;
    localparam [3:0] OP_SRA  = 4'b0111;
    localparam [3:0] OP_SLT  = 4'b1000;
    localparam [3:0] OP_SLTU = 4'b1001;
    localparam [3:0] OP_ANDN = 4'b1010;

    // Shared add/sub computation, 33-bit so we can capture carry/borrow
    wire [32:0] add_result = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_result = {1'b0, a} - {1'b0, b};

    // Signed overflow for ADD/SUB
    // ADD overflow: sign(a) == sign(b) && sign(result) != sign(a)
    // SUB overflow: sign(a) != sign(b) && sign(result) != sign(a)
    wire add_v = (a[31] == b[31]) && (add_result[31] != a[31]);
    wire sub_v = (a[31] != b[31]) && (sub_result[31] != a[31]);

    // Signed and unsigned less-than (combinational, used by SLT/SLTU)
    wire slt_result  = ($signed(a) < $signed(b));
    wire sltu_result = (a < b);

    always @(*) begin
        // Defaults
        alu_out = 32'b0;
        flag_v  = 1'b0;
        flag_c  = 1'b0;

        case (alu_op)
            OP_ADD: begin
                alu_out = add_result[31:0];
                flag_v  = add_v;
                flag_c  = add_result[32];   // unsigned carry-out
            end
            OP_SUB: begin
                alu_out = sub_result[31:0];
                flag_v  = sub_v;
                // For SUB: borrow occurred if a < b unsigned.
                // Equivalent to sub_result[32] in 33-bit subtraction.
                flag_c  = sub_result[32];
            end
            OP_AND:  alu_out = a & b;
            OP_OR:   alu_out = a | b;
            OP_XOR:  alu_out = a ^ b;
            OP_SLL:  alu_out = a << b[4:0];
            OP_SRL:  alu_out = a >> b[4:0];
            OP_SRA:  alu_out = $signed(a) >>> b[4:0];
            OP_SLT:  alu_out = {31'b0, slt_result};
            OP_SLTU: alu_out = {31'b0, sltu_result};
            OP_ANDN: alu_out = a & ~b;
            default: alu_out = 32'b0;
        endcase
    end

    assign flag_z = (alu_out == 32'b0);
    assign flag_n = alu_out[31];

endmodule