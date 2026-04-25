module ActualControl (
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

always @(*) begin
    // 1. DEFAULT SIGNALS (Do not delete these!)
    // Set all your control signals to 0 here...

    // 2. HIERARCHICAL DECODE
    case (opcode)
        
        // ----------------------------------------------------
        // LUI (Load Upper Immediate)
        // ----------------------------------------------------
        7'b0110111: begin 
            // Populate LUI signals here
        end
        
        // ----------------------------------------------------
        // AUIPC (Add Upper Immediate to PC)
        // ----------------------------------------------------
        7'b0010111: begin 
            // Populate AUIPC signals here
        end

        // ----------------------------------------------------
        // JAL (Jump and Link)
        // ----------------------------------------------------
        7'b1101111: begin 
            // Populate JAL signals here
        end

        // ----------------------------------------------------
        // JALR (Jump and Link Register)
        // ----------------------------------------------------
        7'b1100111: begin 
            // Populate JALR signals here
        end

        // ----------------------------------------------------
        // BRANCHES
        // ----------------------------------------------------
        7'b1100011: begin
            // Put main branch datapath signals here (e.g., branch = 1)
            case (funct3)
                3'b000: ; // BEQ specific signals
                3'b001: ; // BNE specific signals
                3'b100: ; // BLT specific signals
                3'b101: ; // BGE specific signals
                3'b110: ; // BLTU specific signals
                3'b111: ; // BGEU specific signals
            endcase
        end

        // ----------------------------------------------------
        // LOADS
        // ----------------------------------------------------
        7'b0000011: begin
            // Put main load datapath signals here (e.g., mem_read = 1)
            case (funct3)
                3'b000: ; // LB  (Load Byte, sign-extended)
                3'b001: ; // LH  (Load Halfword, sign-extended)
                3'b010: ; // LW  (Load Word)
                3'b100: ; // LBU (Load Byte, unsigned zero-extended)
                3'b101: ; // LHU (Load Halfword, unsigned zero-extended)
            endcase
        end

        // ----------------------------------------------------
        // STORES
        // ----------------------------------------------------
        7'b0100011: begin
            // Put main store datapath signals here (e.g., mem_write = 1)
            case (funct3)
                3'b000: ; // SB (Store Byte)
                3'b001: ; // SH (Store Halfword)
                3'b010: ; // SW (Store Word)
            endcase
        end

        // ----------------------------------------------------
        // I-TYPE ALU (Arithmetic/Logic with Immediate)
        // ----------------------------------------------------
        7'b0010011: begin
            // Put main I-Type datapath signals here (e.g., alu_src = 1)
            case (funct3)
                3'b000: ; // ADDI
                3'b010: ; // SLTI
                3'b011: ; // SLTIU
                3'b100: ; // XORI
                3'b110: ; // ORI
                3'b111: ; // ANDI
                
                // Shifts require looking at funct7 too!
                3'b001: ; // SLLI (funct7 == 0000000)
                3'b101: begin
                    if (funct7 == 7'b0100000) ; // SRAI
                    else                      ; // SRLI
                end
            endcase
        end

        // ----------------------------------------------------
        // R-TYPE ALU (Arithmetic/Logic with Registers) + MULTIPLIER
        // ----------------------------------------------------
        7'b0110011: begin
            // Put main R-Type datapath signals here (e.g., alu_src = 0)
            
            if (funct7 == 7'b0000001) begin
                // THIS IS YOUR MULTIPLIER (M-Extension)
                // Put multiplier trigger signals here (e.g., is_mul = 1)
            end else begin
                // Standard ALU operations
                case (funct3)
                    3'b000: begin
                        if (funct7 == 7'b0100000) ; // SUB
                        else                      ; // ADD
                    end
                    3'b001: ; // SLL
                    3'b010: ; // SLT
                    3'b011: ; // SLTU
                    3'b100: ; // XOR
                    3'b101: begin
                        if (funct7 == 7'b0100000) ; // SRA
                        else                      ; // SRL
                    end
                    3'b110: ; // OR
                    3'b111: ; // AND
                endcase
            end
        end

        // ----------------------------------------------------
        // SYSTEM (ECALL, MRET, CSRs)
        // ----------------------------------------------------
        7'b1110011: begin
            case (funct3)
                3'b000: begin
                    if (funct7 == 7'b0011000) ; // MRET
                    else                      ; // ECALL
                end
                3'b001: ; // CSRRW
                3'b010: ; // CSRRS
                3'b011: ; // CSRRC
            endcase
        end

    endcase
end
