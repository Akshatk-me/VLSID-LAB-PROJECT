module message_scheduler (
    input wire clk,
    input wire rst,
    input wire start,              // Trigger to load the initial block
    input wire en,                 // Enable the scheduler (syncs with compression core)
    input wire [512-1:0] block_in, // 16x32-bit input block
    input wire [5:0] sched_round_idx, // NEW: Expects the lookahead index from compression core
    output wire [31:0] w_out       // The scheduled word for the current round
);

    reg [31:0] W [15:0]; 
    reg [31:0] w_reg;

    // SHA-256 sigma functions for message scheduling
    wire [31:0] s0 = {W[1][6:0], W[1][31:7]} ^ {W[1][17:0], W[1][31:18]} ^ (W[1] >> 3);
    wire [31:0] s1 = {W[14][16:0], W[14][31:17]} ^ {W[14][18:0], W[14][31:19]} ^ (W[14] >> 10);
    wire [31:0] next_w = W[0] + s0 + W[9] + s1;

    // Output is purely registered to ensure timing safety
    assign w_out = w_reg;

    integer i;
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 16; i = i + 1) begin
                W[i] <= 32'b0;
            end
            w_reg <= 32'b0;
        end else if (start) begin
            // Load the initial 16 words ONLY when the start pulse arrives
            for (i = 0; i < 16; i = i + 1) begin
		W[i] <= block_in[i*32 +: 32];
            end
            // Pre-load W[0] (the MSB) so it is ready for round 0
            w_reg <= block_in[0 +: 32]; 
        end else if (en) begin
            
            // 1. Latch the required word for the NEXT round (Read phase)
            if (sched_round_idx < 16) begin
                // FIXED: Direct index mapping instead of reverse (15 - idx)
                w_reg <= W[sched_round_idx]; 
            end else begin
                w_reg <= next_w;
            end
            
            // 2. Shift the window if we are calculating new words (Update phase)
            if (sched_round_idx >= 16) begin
                for (i = 0; i < 15; i = i + 1) begin
                    W[i] <= W[i+1];
                end
                W[15] <= next_w;
            end
        end
    end
endmodule
