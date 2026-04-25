module sha256_compression (
    input  wire         clk,
    input  wire         rst,
    input  wire         start,     // Trigger from the MMIO Wrapper
    
    // Inputs from Constants & Scheduler Modules
    input  wire [31:0]  k_in,      // Round constant K[i]
    input  wire [31:0]  w_in,      // Scheduled word W[i]
    input  wire [31:0]  H0_in, H1_in, H2_in, H3_in, H4_in, H5_in, H6_in, H7_in,
    
    // Outputs back to Wrapper and sub-modules
    output wire         en,        // Triggers the scheduler to step forward
    output wire         busy,      // Tells the MMIO the engine is running
    output reg  [5:0]   round_idx, // The CURRENT round being calculated (0 to 63)
    output wire [5:0]   sched_round_idx, // NEW: Lookahead index explicitly for the scheduler
    output reg          done,      // 1-cycle pulse when hash is ready
    output reg  [255:0] hash_out   // The final 256-bit computed hash
);

    // FSM States
    localparam IDLE    = 2'b00; 
    localparam CALC_P1 = 2'b01; // Compute T1 & T2
    localparam CALC_P2 = 2'b10; // Update variables & trigger scheduler
    localparam DONE    = 2'b11; // Final accumulation

    reg [1:0] state; 

    // The 8 working variables
    reg [31:0] a, b, c, d, e, f, g, h; 
    
    // Intermediate registers to break the combinational path
    reg [31:0] T1_reg, T2_reg;

    // Output assignments
    assign busy = (state != IDLE);
    assign en   = (state == CALC_P2); 
    
    // Explicitly tell the scheduler to fetch data for the NEXT round
    assign sched_round_idx = round_idx + 1; 

    // --- SHA-256 Combinational Logic Functions ---
    function [31:0] ROTR; 
        input [31:0] x; 
        input [4:0] n; 
        ROTR = (x >> n) | (x << (32 - n)); 
    endfunction 

    wire [31:0] Ch  = (e & f) ^ (~e & g); 
    wire [31:0] Maj = (a & b) ^ (a & c) ^ (b & c); 
    wire [31:0] Sigma0_a = ROTR(a, 2) ^ ROTR(a, 13) ^ ROTR(a, 22); 
    wire [31:0] Sigma1_e = ROTR(e, 6) ^ ROTR(e, 11) ^ ROTR(e, 25);
    
    wire [31:0] T1 = h + Sigma1_e + Ch + k_in + w_in; 
    wire [31:0] T2 = Sigma0_a + Maj; 

    always @(posedge clk) begin
        if (rst) begin
            state     <= IDLE; 
            round_idx <= 6'd0; 
            done      <= 1'b0; 
            hash_out  <= 256'b0; 
        end else begin 
            case (state)
                IDLE: begin
                    done <= 1'b0; 
                    // Start is only evaluated when engine is idle
                    if (start) begin 
                        a <= H0_in; b <= H1_in; c <= H2_in; d <= H3_in; 
                        e <= H4_in; f <= H5_in; g <= H6_in; h <= H7_in; 
                        round_idx <= 6'd0; 
                        state <= CALC_P1;
                    end
                end

                CALC_P1: begin
                    T1_reg <= T1;
                    T2_reg <= T2;
                    // Increment removed from here for clean semantics
                    state <= CALC_P2;
                end

                CALC_P2: begin
                    // "Shift and Mix" operation
                    h <= g; 
                    g <= f; 
                    f <= e; 
                    e <= d + T1_reg; 
                    d <= c; 
                    c <= b; 
                    b <= a; 
                    a <= T1_reg + T2_reg; 

                    // Check termination against the current round index
                    if (round_idx == 6'd63) begin 
                        state <= DONE; 
                    end else begin 
                        round_idx <= round_idx + 1; // Increment happens cleanly here
                        state <= CALC_P1;
                    end
                end

                DONE: begin
                    // Final Hash Accumulation
                    hash_out <= { H0_in + a, H1_in + b, H2_in + c, H3_in + d, 
                                  H4_in + e, H5_in + f, H6_in + g, H7_in + h }; 
                    done  <= 1'b1; 
                    state <= IDLE; 
                end
            endcase
        end
    end
endmodule
