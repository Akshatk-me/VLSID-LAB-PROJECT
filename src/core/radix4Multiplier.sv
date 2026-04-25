module radix4_multiplier (
    input logic               clk,
    input logic               rst,
    input logic               start,         // Triggered by EX stage when it sees a MUL instr
    input logic signed [31:0] multiplicand,  // Operand A
    input logic signed [31:0] multiplier,    // Operand B

    output logic [63:0] result_64,  // full 64-bit result of the product
    output logic        done        // Signals the pipeline that math is finished
);

    typedef enum logic [1:0] {
        IDLE,
        COMPUTE,
        DONE_STATE
    } state_t;
    state_t             state;

    // We need 16 cycles to process 32 bits (2 bits at a time)
    logic        [ 4:0] count;

    // Radix-4 needs a 65-bit working register:
    // [64:33] = Accumulator, [32:1] = Multiplier shifting out, [0] = Booth overlap bit (-1)
    logic signed [64:0] P;
    logic signed [31:0] A;  // Holds the multiplicand
    logic signed [31:0] neg_A;  // Two's complement of A (-A)

    // Combinational signals for the ALU step
    logic        [ 2:0] booth_window;
    logic signed [31:0] add_val;
    logic signed [64:0] P_next;

    assign booth_window = P[2:0];
    assign neg_A = -A;

    // Continuous assignment for the done flag (Moore machine style)
    assign done = (state == DONE_STATE);

    // --- Booth Decoder Combinational Logic ---
    always_comb begin
        add_val = 32'sd0;  // sd means signed decimal
        unique case (booth_window)
            3'b000, 3'b111: add_val = 32'sd0;
            3'b001, 3'b010: add_val = A;
            3'b011:         add_val = A << 1;  // +2A
            3'b100:         add_val = neg_A << 1;  // -2A
            3'b101, 3'b110: add_val = neg_A;  // -A
            default:        add_val = 32'sd0;
        endcase

        // Add to upper 32 bits of P, then arithmetic shift right by 2
        /* verilator lint_off WIDTHTRUNC */
        P_next = {({P[64], P[64:33]} + {add_val[31], add_val}), P[32:0]};
        /* verilator lint_on WIDTHTRUNC */
        P_next = P_next >>> 2;  // 2-bit Arithmetic Shift Right
    end

    // --- State Machine & Datapath (Sequential) ---
    always_ff @(posedge clk) begin
        if (rst) begin
            state     <= IDLE;
            count     <= 5'd0;
            P         <= 65'sd0;
            A         <= 32'sd0;
            result_64 <= 64'd0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        // Load operands: Upper 32 = 0, Middle 32 = multiplier, LSB = 0
                        P     <= {32'd0, multiplier, 1'b0};
                        A     <= multiplicand;
                        count <= 5'd16;  // 16 shifts for 32-bit Radix-4
                        state <= COMPUTE;
                    end
                end

                COMPUTE: begin
                    P <= P_next;  // Perform the add and shift
                    count <= count - 1'b1;

                    if (count == 5'd1) begin
                        state <= DONE_STATE;
                    end
                end

                DONE_STATE: begin
                    // Tranisition to IDLE and wait for next start
                    result_64 <= P[64:1];
                    state <= IDLE;  // Auto-return to IDLE next cycle
                end
            endcase
        end
    end

endmodule
