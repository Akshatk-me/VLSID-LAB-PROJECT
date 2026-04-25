module fast_mul (
    input  wire        clk,
    input  wire        rst,

    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [1:0]  op_type,

    output reg  [31:0] result
);

    // ----------------------------------------
    // Operation encoding
    // ----------------------------------------
    localparam MUL    = 2'd0;
    localparam MULH   = 2'd1;
    localparam MULHU  = 2'd2;
    localparam MULHSU = 2'd3;

    // ----------------------------------------
    // 1. Determine Signedness
    // ----------------------------------------
    // A is signed for MULH and MULHSU. (For MUL, it doesn't matter since we only take the bottom 32 bits)
    wire is_a_signed = (op_type == MULH) || (op_type == MULHSU);
    
    // B is signed ONLY for MULH.
    wire is_b_signed = (op_type == MULH);

    // ----------------------------------------
    // 2. Extend to 33 bits
    // ----------------------------------------
    // If signed, duplicate A[31]. If unsigned, pad with 1'b0.
    wire signed [32:0] ext_A = {is_a_signed & A[31], A};
    wire signed [32:0] ext_B = {is_b_signed & B[31], B};

    // ----------------------------------------
    // 3. The DSP Multiplication
    // ----------------------------------------
    // Synthesizer will automatically map this 66-bit result to hardware DSP slices
    wire signed [65:0] full_product = ext_A * ext_B;

    // ----------------------------------------
    // 4. Output Register (1-Cycle Latency)
    // ----------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 32'b0;
        end else begin
            case (op_type)
                MUL:     result <= full_product[31:0];  // Lower 32 bits
                default: result <= full_product[63:32]; // Upper 32 bits (MULH, MULHU, MULHSU)
            endcase
        end
    end

endmodule
