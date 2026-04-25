`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2026 04:22:57 AM
// Design Name: 
// Module Name: imm_gen
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
// imm_gen.v
// Immediate generator for RV32IM (subset).
// Extracts and sign-extends the immediate from the instruction based on format.
// Format is determined entirely by opcode (instr[6:0]).
// Purely combinational.
// =============================================================================

module imm_gen (
    input  wire [31:0] instr,
    output reg  [31:0] imm
);

    // Opcode lives in instr[6:0]. Pull it out for readability.
    wire [6:0] opcode;
    assign opcode = instr[6:0];

    // Opcode constants
    localparam [6:0] OP_IMM     = 7'b0010011;  // ADDI, SLTI, ANDI, shifts, etc.
    localparam [6:0] OP_LOAD    = 7'b0000011;  // LB, LH, LW, LBU, LHU
    localparam [6:0] OP_JALR    = 7'b1100111;  // JALR
    localparam [6:0] OP_SYSTEM  = 7'b1110011;  // CSRRW/S/C, MRET
    localparam [6:0] OP_STORE   = 7'b0100011;  // SB, SH, SW
    localparam [6:0] OP_BRANCH  = 7'b1100011;  // BEQ, BNE, BLT, BGE, BLTU, BGEU
    localparam [6:0] OP_LUI     = 7'b0110111;  // LUI
    localparam [6:0] OP_AUIPC   = 7'b0010111;  // AUIPC
    localparam [6:0] OP_JAL     = 7'b1101111;  // JAL
    localparam [6:0] OP_REG     = 7'b0110011;  // R-type (no immediate)

    always @(*) begin
        case (opcode)

            // ---------------------------------------------------------------
            // I-type: imm[11:0] = instr[31:20], sign-extended
            // Used by: ADDI/SLTI/ANDI/ORI/XORI/SLLI/SRLI/SRAI, loads,
            //          JALR, CSRRW/S/C (imm[11:0] = CSR address)
            // ---------------------------------------------------------------
            OP_IMM, OP_LOAD, OP_JALR, OP_SYSTEM: begin
                imm = {{21{instr[31]}}, instr[30:20]};
            end

            // ---------------------------------------------------------------
            // S-type: imm[11:0] = {instr[31:25], instr[11:7]}, sign-extended
            // Used by: SB, SH, SW
            // ---------------------------------------------------------------
            OP_STORE: begin
                imm = {{21{instr[31]}}, instr[30:25], instr[11:7]};
            end

            // ---------------------------------------------------------------
            // B-type: imm[12:1] = {instr[31], instr[7], instr[30:25], instr[11:8]}
            //         imm[0]    = 0 (hardwired)
            // Sign-extended from bit 12.
            // Used by: BEQ, BNE, BLT, BGE, BLTU, BGEU
            // ---------------------------------------------------------------
            OP_BRANCH: begin
                imm = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
            end

            // ---------------------------------------------------------------
            // U-type: imm[31:12] = instr[31:12], imm[11:0] = 0
            // No sign-extension (already occupies top of word).
            // Used by: LUI, AUIPC
            // ---------------------------------------------------------------
            OP_LUI, OP_AUIPC: begin
                imm = {instr[31:12], 12'b0};
            end

            // ---------------------------------------------------------------
            // J-type: imm[20:1] = {instr[31], instr[19:12], instr[20], instr[30:21]}
            //         imm[0]    = 0 (hardwired)
            // Sign-extended from bit 20.
            // Used by: JAL
            // ---------------------------------------------------------------
            OP_JAL: begin
                imm = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
            end

            // ---------------------------------------------------------------
            // R-type and unknown opcodes: no immediate.
            // Output zero so waveforms stay clean and X doesn't propagate.
            // Control unit ensures the ALU doesn't use this path for R-type.
            // ---------------------------------------------------------------
            default: begin
                imm = 32'b0;
            end

        endcase
    end

endmodule
