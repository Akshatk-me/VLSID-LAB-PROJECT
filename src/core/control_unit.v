module control_unit (
    input  wire [6:0] opcode,
    input  wire [6:0] funct7, // NEW: Needed to detect M-Extension
    
    // Datapath Routing Signals
    output reg        RegWrite,
    output reg        MemRead,
    output reg        MemWrite,
    output reg        ALUSrc,
    output reg [1:0]  ResultSrc,
    output reg        Branch,
    output reg        Jump,
    
    // ALU & Multiplier Control
    output reg [1:0]  ALUOp,
    output reg        MulEn,      // NEW: Triggers the Multiplier
    
    // System Signals
    output reg        CSRRead,
    output reg        CSRWrite
);

    always @(*) begin
        // Default assignments...
        RegWrite  = 1'b0;
        MemRead   = 1'b0;
        MemWrite  = 1'b0;
        ALUSrc    = 1'b0;
        ResultSrc = 2'b00;
        Branch    = 1'b0;
        Jump      = 1'b0;
        ALUOp     = 2'b00;
        MulEn     = 1'b0; // Default multiplier to off
        CSRRead   = 1'b0;
        CSRWrite  = 1'b0;

        case (opcode)
            // R-Type (ADD, SUB, AND, MUL, etc.)
            7'b0110011: begin
                RegWrite = 1'b1;
                // Check funct7 to see if this is a Multiplier instruction
                if (funct7 == 7'b0000001) begin
                    MulEn = 1'b1;   // Activate 32-cycle Multiplier
                    ALUOp = 2'b00;  // Standard ALU does nothing
                end else begin
                    MulEn = 1'b0;
                    ALUOp = 2'b10;  // Standard ALU handles it
                end
            end
            
            // ... (Rest of the previous opcode cases remain exactly the same) ...
        endcase
    end
endmodule
