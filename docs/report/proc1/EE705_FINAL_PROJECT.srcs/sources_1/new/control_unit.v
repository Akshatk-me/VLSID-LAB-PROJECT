`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2026 07:52:40 AM
// Design Name: 
// Module Name: control_unit
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
// control_unit.v
// Main decoder for RV32IM (subset).
// Inputs:  opcode, funct3, funct7
// Outputs: full bundle of EX/MEM/WB control signals (combinational)
//
// SLT/SLTU are now ALU ops (ALU_SLT, ALU_SLTU) producing 0/1 on alu_out.
// Branch is_taken is computed in EX from ALU flags + branch_type, NOT here.
//
// ex_result_src codes:
//   000 = alu_out
//   001 = imm        (LUI)
//   010 = csr_read   (CSR rd <- old value)
//   011 = pc_plus_4  (JAL/JALR link)
//   100 = mul_low    (MUL)
//   101 = mul_high   (MULH/MULHU/MULHSU)
//
// alu_op codes:
//   0000 ADD     0001 SUB     0010 AND     0011 OR
//   0100 XOR     0101 SLL     0110 SRL     0111 SRA
//   1000 SLT     1001 SLTU    1010 AND_NOT (for CSRRC)
// =============================================================================

module control_unit (
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,

    // EX control
    output reg        alu_src_a,
    output reg [1:0]  alu_src_b,
    output reg [3:0]  alu_op,
    output reg        is_branch,
    output reg [2:0]  branch_type,
    output reg        is_jump,
    output reg [1:0]  csr_op,
    output reg        csr_wdata_src,
    output reg        is_mret,
    output reg [1:0]  mul_op,
    output reg [2:0]  ex_result_src,

    // MEM control
    output reg        mem_read,
    output reg        mem_write,
    output reg [3:0]  wen,
    output reg [2:0]  ld_select,

    // WB control
    output reg        reg_write
);

    // -------- Opcode constants --------
    localparam [6:0] OP_REG     = 7'b0110011;
    localparam [6:0] OP_IMM     = 7'b0010011;
    localparam [6:0] OP_LOAD    = 7'b0000011;
    localparam [6:0] OP_STORE   = 7'b0100011;
    localparam [6:0] OP_BRANCH  = 7'b1100011;
    localparam [6:0] OP_JAL     = 7'b1101111;
    localparam [6:0] OP_JALR    = 7'b1100111;
    localparam [6:0] OP_LUI     = 7'b0110111;
    localparam [6:0] OP_AUIPC   = 7'b0010111;
    localparam [6:0] OP_SYSTEM  = 7'b1110011;

    // -------- ALU op constants --------
    localparam [3:0] ALU_ADD    = 4'b0000;
    localparam [3:0] ALU_SUB    = 4'b0001;
    localparam [3:0] ALU_AND    = 4'b0010;
    localparam [3:0] ALU_OR     = 4'b0011;
    localparam [3:0] ALU_XOR    = 4'b0100;
    localparam [3:0] ALU_SLL    = 4'b0101;
    localparam [3:0] ALU_SRL    = 4'b0110;
    localparam [3:0] ALU_SRA    = 4'b0111;
    localparam [3:0] ALU_SLT    = 4'b1000;
    localparam [3:0] ALU_SLTU   = 4'b1001;
    localparam [3:0] ALU_ANDN   = 4'b1010;

    // -------- ex_result_src codes --------
    localparam [2:0] RES_ALU    = 3'b000;
    localparam [2:0] RES_IMM    = 3'b001;
    localparam [2:0] RES_CSR    = 3'b010;
    localparam [2:0] RES_PC4    = 3'b011;
    localparam [2:0] RES_MULL   = 3'b100;
    localparam [2:0] RES_MULH   = 3'b101;

    always @(*) begin
        // Defaults: do nothing
        alu_src_a     = 1'b0;
        alu_src_b     = 2'b00;
        alu_op        = ALU_ADD;
        is_branch     = 1'b0;
        branch_type   = 3'b000;
        is_jump       = 1'b0;
        csr_op        = 2'b00;
        csr_wdata_src = 1'b0;
        is_mret       = 1'b0;
        mul_op        = 2'b00;
        ex_result_src = RES_ALU;
        mem_read      = 1'b0;
        mem_write     = 1'b0;
        wen           = 4'b0000;
        ld_select     = 3'b000;
        reg_write     = 1'b0;

        case (opcode)

            // ---------- R-type: ALU + M-extension multiply ----------
            OP_REG: begin
                alu_src_a     = 1'b0;     // rs1
                alu_src_b     = 2'b00;    // rs2
                reg_write     = 1'b1;
                ex_result_src = RES_ALU;

                if (funct7 == 7'b0000001) begin
                    // M-extension multiply
                    case (funct3)
                        3'b000: begin  // MUL
                            mul_op        = 2'b01;
                            ex_result_src = RES_MULL;
                        end
                        3'b001: begin  // MULH
                            mul_op        = 2'b01;
                            ex_result_src = RES_MULH;
                        end
                        3'b010: begin  // MULHSU
                            mul_op        = 2'b10;
                            ex_result_src = RES_MULH;
                        end
                        3'b011: begin  // MULHU
                            mul_op        = 2'b11;
                            ex_result_src = RES_MULH;
                        end
                        default: ;
                    endcase
                end else begin
                    // Standard R-type ALU
                    case (funct3)
                        3'b000: alu_op = (funct7[5]) ? ALU_SUB  : ALU_ADD;
                        3'b001: alu_op = ALU_SLL;
                        3'b010: alu_op = ALU_SLT;
                        3'b011: alu_op = ALU_SLTU;
                        3'b100: alu_op = ALU_XOR;
                        3'b101: alu_op = (funct7[5]) ? ALU_SRA  : ALU_SRL;
                        3'b110: alu_op = ALU_OR;
                        3'b111: alu_op = ALU_AND;
                    endcase
                end
            end

            // ---------- I-type ALU ----------
            OP_IMM: begin
                alu_src_a     = 1'b0;     // rs1
                alu_src_b     = 2'b01;    // imm
                reg_write     = 1'b1;
                ex_result_src = RES_ALU;

                case (funct3)
                    3'b000: alu_op = ALU_ADD;                              // ADDI
                    3'b010: alu_op = ALU_SLT;                              // SLTI
                    3'b011: alu_op = ALU_SLTU;                             // SLTIU
                    3'b100: alu_op = ALU_XOR;                              // XORI
                    3'b110: alu_op = ALU_OR;                               // ORI
                    3'b111: alu_op = ALU_AND;                              // ANDI
                    3'b001: alu_op = ALU_SLL;                              // SLLI
                    3'b101: alu_op = (funct7[5]) ? ALU_SRA : ALU_SRL;      // SRAI/SRLI
                endcase
            end

            // ---------- Loads ----------
            OP_LOAD: begin
                alu_src_a     = 1'b0;     // rs1
                alu_src_b     = 2'b01;    // imm
                alu_op        = ALU_ADD;  // address = rs1 + imm
                mem_read      = 1'b1;
                reg_write     = 1'b1;
                ex_result_src = RES_ALU;  // (overridden by load mux in MEM)
                ld_select     = funct3;   // funct3 directly encodes LB/LH/LW/LBU/LHU
            end

            // ---------- Stores ----------
            OP_STORE: begin
                alu_src_a     = 1'b0;     // rs1
                alu_src_b     = 2'b01;    // imm
                alu_op        = ALU_ADD;  // address = rs1 + imm
                mem_write     = 1'b1;
                reg_write     = 1'b0;
                case (funct3)
                    3'b000: wen = 4'b0001;  // SB
                    3'b001: wen = 4'b0011;  // SH
                    3'b010: wen = 4'b1111;  // SW
                    default: wen = 4'b0000;
                endcase
            end

            // ---------- Branches ----------
            OP_BRANCH: begin
                alu_src_a     = 1'b0;     // rs1
                alu_src_b     = 2'b00;    // rs2
                alu_op        = ALU_SUB;  // produces flags for branch comparator
                is_branch     = 1'b1;
                branch_type   = funct3;
                reg_write     = 1'b0;
                ex_result_src = RES_IMM;
            end

            // ---------- JAL ----------
            OP_JAL: begin
                alu_src_a     = 1'b1;     // PC
                alu_src_b     = 2'b01;    // imm
                alu_op        = ALU_ADD;  // target = PC + imm
                is_jump       = 1'b1;
                reg_write     = 1'b1;
                ex_result_src = RES_PC4;  // rd <- PC + 4
            end

            // ---------- JALR ----------
            OP_JALR: begin
                alu_src_a     = 1'b0;     // rs1
                alu_src_b     = 2'b01;    // imm
                alu_op        = ALU_ADD;  // target = rs1 + imm
                is_jump       = 1'b1;
                reg_write     = 1'b1;
                ex_result_src = RES_PC4;  // rd <- PC + 4
            end

            // ---------- LUI ----------
            OP_LUI: begin
                reg_write     = 1'b1;
                ex_result_src = RES_IMM;  // rd <- imm directly
            end

            // ---------- AUIPC ----------
            OP_AUIPC: begin
                alu_src_a     = 1'b1;     // PC
                alu_src_b     = 2'b01;    // imm
                alu_op        = ALU_ADD;
                reg_write     = 1'b1;
                ex_result_src = RES_ALU;
            end

            // ---------- SYSTEM: CSR + MRET ----------
            OP_SYSTEM: begin
                case (funct3)
                    3'b001: begin  // CSRRW
                        csr_op        = 2'b01;
                        csr_wdata_src = 1'b0;     // CSR write data <- rs1_data
                        reg_write     = 1'b1;
                        ex_result_src = RES_CSR;
                    end
                    3'b010: begin  // CSRRS
                        alu_src_a     = 1'b0;     // rs1 -- wait, see note below
                        alu_src_b     = 2'b10;    // csr_read
                        alu_op        = ALU_OR;   // new = rs1 | csr_read
                        csr_op        = 2'b10;
                        csr_wdata_src = 1'b1;     // CSR write data <- alu_out
                        reg_write     = 1'b1;
                        ex_result_src = RES_CSR;
                    end
                    3'b011: begin  // CSRRC
                        alu_src_a     = 1'b0;     // rs1 (mask)
                        alu_src_b     = 2'b10;    // csr_read
                        alu_op        = ALU_ANDN; // new = csr_read & ~rs1
                        csr_op        = 2'b11;
                        csr_wdata_src = 1'b1;
                        reg_write     = 1'b1;
                        ex_result_src = RES_CSR;
                    end
                    3'b000: begin  // MRET
                        is_mret       = 1'b1;
                        reg_write     = 1'b0;
                    end
                    default: ;
                endcase
            end

            default: ;  // unknown opcode -> all defaults
        endcase
    end

endmodule
