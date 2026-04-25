`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 07:48:19 AM
// Design Name: 
// Module Name: branch_comparator
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
// branch_comparator.v
// Determines branch taken/not-taken from ALU flags and branch type (funct3).
// Used in EX stage. The ALU performs SUB on rs1 and rs2 for branches and
// exposes Z, N, V, C flags; this module interprets them per branch type.
//
// branch_type encoding (matches RISC-V funct3 for branches):
//   000 BEQ   001 BNE   100 BLT   101 BGE   110 BLTU   111 BGEU
//
// Signed less-than:    rs1 < rs2  iff  N != V  (after rs1 - rs2)
// Unsigned less-than:  rs1 < rs2  iff  C == 1  (borrow occurred)
// =============================================================================

module branch_comparator (
    input  wire       is_branch,
    input  wire [2:0] branch_type,
    input  wire       flag_z,
    input  wire       flag_n,
    input  wire       flag_v,
    input  wire       flag_c,
    output reg        is_taken
);

    always @(*) begin
        if (!is_branch) begin
            is_taken = 1'b0;
        end else begin
            case (branch_type)
                3'b000: is_taken = flag_z;             // BEQ:  rs1 == rs2
                3'b001: is_taken = ~flag_z;            // BNE:  rs1 != rs2
                3'b100: is_taken = (flag_n ^ flag_v);  // BLT:  signed 
                3'b101: is_taken = ~(flag_n ^ flag_v); // BGE:  signed >=
                3'b110: is_taken = ~flag_c;            // BLTU swapped
                3'b111: is_taken = flag_c;             // BGEU swapped          // BGEU: unsigned >=
                default: is_taken = 1'b0;
            endcase
        end
    end

endmodule
