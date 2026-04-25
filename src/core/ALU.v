`include "rv32i_defines.vh"
module ALU (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [ 4:0] alu_sel,
    output reg  [31:0] result,
    output wire        zero
);

    wire [31:0] sum;
    wire [31:0] b_eff;
    wire        is_sub;


    // SUB = ADD with inverted B + 1
    assign is_sub = (alu_sel == ALU_SUB);
    assign b_eff = is_sub ? ~b : b;

    assign sum = a + b_eff + is_sub;

    always @(*) begin
        case (alu_sel)

            ALU_ADD, ALU_SUB: result = sum;

            ALU_SLT: result = ($signed(a) < $signed(b)) ? 1 : 0;

            ALU_SLTU: result = (a < b) ? 1 : 0;

            ALU_AND: result = a & b;

            ALU_OR: result = a | b;

            ALU_XOR: result = a ^ b;

            ALU_SLL: result = a << b[4:0];

            ALU_SRL: result = a >> b[4:0];

            ALU_SRA: result = $signed(a) >>> b[4:0];

            ALU_COPY_B: result = b;

            default: result = 32'b0;
        endcase
    end

    assign zero = (result == 0);

endmodule
