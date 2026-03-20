module message_scheduler (
    input wire clk,
    input wire rst,
    input wire en,               // Enable the scheduler (syncs with the 64-cycle compression core)
    input wire [512-1:0] block_in, // 16x32-bit input block
    input wire [5:0] round_idx,  // 0 to 63 from the compression core state machine
    output wire [31:0] w_out     // The scheduled word for the current round
);

    reg [31:0] W [15:0]; // Sliding window of the last 16 words

    // SHA-256 sigma functions for message scheduling
    wire [31:0] s0 = {W[1][6:0], W[1][31:7]} ^ {W[1][17:0], W[1][31:18]} ^ (W[1] >> 3);
    wire [31:0] s1 = {W[14][16:0], W[14][31:17]} ^ {W[14][18:0], W[14][31:19]} ^ (W[14] >> 10);
    wire [31:0] next_w = W[0] + s0 + W[9] + s1;

    assign w_out = (round_idx < 16) ? W[15 - round_idx] : next_w;

    integer i;
    always @(posedge clk) begin
        if (rst) begin
            // Load the initial 16 words from the padded block
            for (i = 0; i < 16; i = i + 1) begin
                W[i] <= block_in[((15-i)*32) +: 32];
            end
        end else if (en) begin
            if (round_idx >= 16) begin
                // Shift the window and load the dynamically computed next word
                for (i = 0; i < 15; i = i + 1) begin
                    W[i] <= W[i+1];
                end
                W[15] <= next_w;
            end
        end
    end
endmodule
