module Control_Unit (
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    
    // Execution Stage (EX)
    output reg        alu_src,
    output reg [3:0]  alu_op,
    output reg        is_mul,
    
    // Memory Stage (MEM)
    output reg        mem_read,
    output reg        mem_write,
    output reg        branch,
    output reg        jump,
    
    // Writeback Stage (WB)
    output reg        reg_write,
    output reg        mem_to_reg,
    
    // CSR/System
    output reg        csr_write,
    output reg        csr_read,
    output reg        is_ecall
);

    // =========================
    // ALU Operation Encoding
    // =========================
    localparam [3:0]
        ALU_ADD  = 4'b0000,
        ALU_SUB  = 4'b0001,
        ALU_SLL  = 4'b0010,
        ALU_SLT  = 4'b0011,
        ALU_SLTU = 4'b0100,
        ALU_XOR  = 4'b0101,
        ALU_SRL  = 4'b0110,
        ALU_SRA  = 4'b0111,
        ALU_OR   = 4'b1000,
        ALU_AND  = 4'b1001,
        ALU_PASS = 4'b1010;

    always @(*) begin
        // =========================
        // Default values
        // =========================
        alu_src    = 0;
        alu_op     = ALU_ADD;
        is_mul     = 0;

        mem_read   = 0;
        mem_write  = 0;
        branch     = 0;
        jump       = 0;

        reg_write  = 0;
        mem_to_reg = 0;

        csr_write  = 0;
        csr_read   = 0;
        is_ecall   = 0;

        // =========================
        // Decode
        // =========================
        case (opcode)

            // =====================
            // R-TYPE
            // =====================
            7'b0110011: begin
                reg_write = 1;
                alu_src   = 0;

                // M-extension (MUL)
                if (funct7 == 7'b0000001) begin
                    is_mul = 1;
                end else begin
                    case (funct3)
                        3'b000: alu_op = (funct7[5]) ? ALU_SUB : ALU_ADD;
                        3'b001: alu_op = ALU_SLL;
                        3'b010: alu_op = ALU_SLT;
                        3'b011: alu_op = ALU_SLTU;
                        3'b100: alu_op = ALU_XOR;
                        3'b101: alu_op = (funct7[5]) ? ALU_SRA : ALU_SRL;
                        3'b110: alu_op = ALU_OR;
                        3'b111: alu_op = ALU_AND;
                    endcase
                end
            end

            // =====================
            // I-TYPE (ALU)
            // =====================
            7'b0010011: begin
                reg_write = 1;
                alu_src   = 1;

                case (funct3)
                    3'b000: alu_op = ALU_ADD;   // ADDI
                    3'b010: alu_op = ALU_SLT;
                    3'b011: alu_op = ALU_SLTU;
                    3'b100: alu_op = ALU_XOR;
                    3'b110: alu_op = ALU_OR;
                    3'b111: alu_op = ALU_AND;

                    3'b001: alu_op = ALU_SLL;

                    3'b101: alu_op = (funct7[5]) ? ALU_SRA : ALU_SRL;
                endcase
            end

            // =====================
            // LOAD
            // =====================
            7'b0000011: begin
                reg_write  = 1;
                alu_src    = 1;
                mem_read   = 1;
                mem_to_reg = 1;
                alu_op     = ALU_ADD;
            end

            // =====================
            // STORE
            // =====================
            7'b0100011: begin
                alu_src   = 1;
                mem_write = 1;
                alu_op    = ALU_ADD;
            end

            // =====================
            // BRANCH
            // =====================
            7'b1100011: begin
                branch  = 1;
                alu_src = 0;

                case (funct3)
                    3'b000: alu_op = ALU_SUB;   // BEQ
                    3'b001: alu_op = ALU_SUB;   // BNE
                    3'b100: alu_op = ALU_SLT;   // BLT
                    3'b101: alu_op = ALU_SLT;   // BGE
                    3'b110: alu_op = ALU_SLTU;  // BLTU
                    3'b111: alu_op = ALU_SLTU;  // BGEU
                endcase
            end

            // =====================
            // JAL
            // =====================
            7'b1101111: begin
                jump      = 1;
                reg_write = 1;
                alu_op    = ALU_ADD; // for PC+4 or PC+imm
            end

            // =====================
            // JALR
            // =====================
            7'b1100111: begin
                jump      = 1;
                reg_write = 1;
                alu_src   = 1;
                alu_op    = ALU_ADD;
            end

            // =====================
            // LUI
            // =====================
            7'b0110111: begin
                reg_write = 1;
                alu_src   = 1;
                alu_op    = ALU_PASS;
            end

            // =====================
            // AUIPC
            // =====================
            7'b0010111: begin
                reg_write = 1;
                alu_src   = 1;
                alu_op    = ALU_ADD;
            end

            // =====================
            // SYSTEM (CSR / ECALL)
            // =====================
            7'b1110011: begin
                if (funct3 == 3'b000) begin
                    is_ecall = 1;
                end else begin
                    csr_write = 1;
                    csr_read  = 1;
                    reg_write = 1;
                end
            end

        endcase
    end

endmodule
