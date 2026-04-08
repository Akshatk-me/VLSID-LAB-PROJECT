module ALU_Control (
    input  logic [1:0] alu_op,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    output logic [4:0] alu_sel
);

    always_comb begin
        case (alu_op)

            // LOAD/STORE → ADD
            ALUOP_LOAD_STORE:
                alu_sel = ALU_ADD;

            // BRANCH → SUB (comparison)
            ALUOP_BRANCH:
                alu_sel = ALU_SUB;

            // R-type
            ALUOP_RTYPE: begin
                case (funct3)

                    3'b000:
                        alu_sel = (funct7[5]) ? ALU_SUB : ALU_ADD;

                    3'b001:
                        alu_sel = ALU_SLL;

                    3'b010:
                        alu_sel = ALU_SLT;

                    3'b011:
                        alu_sel = ALU_SLTU;

                    3'b100:
                        alu_sel = ALU_XOR;

                    3'b101:
                        alu_sel = (funct7[5]) ? ALU_SRA : ALU_SRL;

                    3'b110:
                        alu_sel = ALU_OR;

                    3'b111:
                        alu_sel = ALU_AND;

                endcase
            end

            // I-type (same as R-type except shifts)
            ALUOP_ITYPE: begin
                case (funct3)

                    3'b000: alu_sel = ALU_ADD;   // ADDI
                    3'b010: alu_sel = ALU_SLT;
                    3'b011: alu_sel = ALU_SLTU;
                    3'b100: alu_sel = ALU_XOR;
                    3'b110: alu_sel = ALU_OR;
                    3'b111: alu_sel = ALU_AND;

                    3'b001: alu_sel = ALU_SLL;

                    3'b101:
                        alu_sel = (funct7[5]) ? ALU_SRA : ALU_SRL;

                endcase
            end

            default:
                alu_sel = ALU_ADD;

        endcase
    end

endmodule
