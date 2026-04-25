`include "rv32i_defines.vh"
module alu_control (
    input  wire [1:0] alu_op,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    output reg  [4:0] alu_sel
);
    always @(*) begin
        case (alu_op)

            // LOAD / STORE → ADD
            ALUOP_LOAD_STORE: begin
                alu_sel = ALU_ADD;
            end

            // BRANCH → SUB
            ALUOP_BRANCH: begin
                alu_sel = ALU_SUB;
            end

            // R-type / I-type
            ALUOP_RTYPE: begin
                case (funct3)

                    3'b000: begin
                        if (funct7 == 7'b0100000)
                            alu_sel = ALU_SUB;
                        else
                            alu_sel = ALU_ADD;
                    end

                    3'b001: alu_sel = ALU_SLL;
                    3'b010: alu_sel = ALU_SLT;
                    3'b011: alu_sel = ALU_SLTU;
                    3'b100: alu_sel = ALU_XOR;

                    3'b101: begin
                        if (funct7 == 7'b0100000)
                            alu_sel = ALU_SRA;
                        else
                            alu_sel = ALU_SRL;
                    end

                    3'b110: alu_sel = ALU_OR;
                    3'b111: alu_sel = ALU_AND;

                    default: alu_sel = ALU_ADD;
                endcase
            end

            default: alu_sel = ALU_ADD;
        endcase
    end

endmodule
