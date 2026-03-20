module instruction_decoder (
    input  wire [31:0] instr,      // 32-bit instruction from IF/ID pipeline register
    
    // Decoded fields
    output wire [6:0]  opcode,
    output wire [4:0]  rd,
    output wire [2:0]  funct3,
    output wire [4:0]  rs1,
    output wire [4:0]  rs2,
    output wire [6:0]  funct7,
    
    // Sign-extended Immediate
    output reg  [31:0] imm_ext
);

    // 1. Direct Slicing (Always the same bits in RISC-V!)
    assign opcode = instr[6:0];
    assign rd     = instr[11:7];
    assign funct3 = instr[14:12];
    assign rs1    = instr[19:15];
    assign rs2    = instr[24:20];
    assign funct7 = instr[31:25];

    // 2. Immediate Generator (ImmGen)
    // Extracts and sign-extends the immediate based on the Opcode
    always @(*) begin
        case (opcode)
            // I-Type (Loads, ALU Immediate, JALR)
            7'b0000011, 7'b0010011, 7'b1100111: 
                imm_ext = {{20{instr[31]}}, instr[31:20]};
                
            // S-Type (Stores)
            7'b0100011: 
                imm_ext = {{20{instr[31]}}, instr[31:25], instr[11:7]};
                
            // B-Type (Branches)
            7'b1100011: 
                imm_ext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
                
            // U-Type (LUI, AUIPC)
            7'b0110111, 7'b0010111: 
                imm_ext = {instr[31:12], 12'b0};
                
            // J-Type (JAL)
            7'b1101111: 
                imm_ext = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
                
            // R-Type or others (No immediate used)
            default: 
                imm_ext = 32'b0;
        endcase
    end

endmodule
