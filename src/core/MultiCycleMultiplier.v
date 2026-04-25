module multicycle_mul (
    input  wire        clk,
    input  wire        rst,

    input  wire        start,
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [1:0]  op_type,   

    output reg  [31:0] result, // CHANGED: Standardized to 32-bit output for RV32
    output reg         done,
    output reg         busy
);

    // ----------------------------------------
    // Operation encoding
    // ----------------------------------------
    localparam MUL    = 2'd0;
    localparam MULH   = 2'd1;
    localparam MULHU  = 2'd2;
    localparam MULHSU = 2'd3;

    // ----------------------------------------
    // Internal registers
    // ----------------------------------------
    reg [63:0] multiplicand;
    reg [31:0] multiplier;
    reg [63:0] product;
    reg [5:0]  count;

    reg        A_sign, B_sign;
    reg [1:0]  op_reg;

    // ----------------------------------------
    // Next-state combinational signals
    // ----------------------------------------
    reg [63:0] next_product;
    reg [63:0] next_multiplicand;
    reg [31:0] next_multiplier;

    always @(*) begin
        next_product      = product;
        next_multiplicand = multiplicand;
        next_multiplier   = multiplier;

        if (busy) begin
            if (multiplier[0])
                next_product = product + multiplicand;

            next_multiplicand = multiplicand << 1;
            next_multiplier   = multiplier >> 1;
        end
    end

    // FIXED: Removed duplicate declarations
    wire A_sign_w = (op_type == MUL || op_type == MULH || op_type == MULHSU) ? A[31] : 1'b0;
    wire B_sign_w = (op_type == MUL || op_type == MULH)                      ? B[31] : 1'b0;

    wire [31:0] A_abs = A_sign_w ? (~A + 1'b1) : A;
    wire [31:0] B_abs = B_sign_w ? (~B + 1'b1) : B;

    // FIXED: Added the missing sign correction logic
    // If the signs are different, two's complement the final product
    wire [63:0] signed_product = (A_sign ^ B_sign) ? (~next_product + 1'b1) : next_product;

    // ----------------------------------------
    // Sequential logic
    // ----------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            multiplicand <= 0;
            multiplier   <= 0;
            product      <= 0;
            count        <= 0;
            result       <= 0;
            done         <= 0;
            busy         <= 0;
            A_sign       <= 0;
            B_sign       <= 0;
            op_reg       <= 0;
        end else begin
            done <= 0;

            //----------------------------------
            // Start condition
            //----------------------------------
            if (start && !busy) begin
                op_reg <= op_type;

                // Decide sign behavior
                case (op_type)
                    MUL, MULH: begin
                        A_sign <= A[31];
                        B_sign <= B[31];
                    end
                    MULHU: begin
                        A_sign <= 0;
                        B_sign <= 0;
                    end
                    MULHSU: begin
                        A_sign <= A[31];
                        B_sign <= 0;
                    end
                endcase

                if (A == 0 || B == 0) begin
                    result <= 0;
                    done   <= 1;
                    busy   <= 0;
                end else begin
                    multiplicand <= {32'b0, A_abs};
                    multiplier   <= B_abs;
                    product      <= 0;
                    count        <= 0;
                    busy         <= 1;
                end
            end

            //----------------------------------
            // Running
            //----------------------------------
            else if (busy) begin
                product      <= next_product;
                multiplicand <= next_multiplicand;
                multiplier   <= next_multiplier;
                count        <= count + 1'b1;

                if (next_multiplier == 0 || count == 31) begin
                    // --------------------------------
                    // Select result based on op (Using corrected sign logic)
                    // --------------------------------
                    case (op_reg)
                        MUL:    result <= signed_product[31:0];
                        MULH:   result <= signed_product[63:32];
                        MULHU:  result <= next_product[63:32]; // Unsigned doesn't need sign correction
                        MULHSU: result <= signed_product[63:32];
                    endcase

                    done <= 1;
                    busy <= 0;
                end
            end
        end
    end

endmodule
