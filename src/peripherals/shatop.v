`timescale 1ns / 1ps

module sha256_top_engine (
    input  wire         clk,
    input  wire         rst,
    input  wire         start,
    input  wire         init,     // 1 to load initial constants (H0-H7), 0 to chain blocks
    input  wire [511:0] block_in,
    output wire         busy,
    output wire         done,
    output wire [255:0] hash_out
);

    // -------------------------------------------------------------------------
    // Internal interconnect wires
    // -------------------------------------------------------------------------
    wire [31:0] k_wire;
    wire [31:0] w_wire;
    wire [31:0] h0_w, h1_w, h2_w, h3_w, h4_w, h5_w, h6_w, h7_w;
    
    wire        sched_en;
    wire [5:0]  comp_round_idx;
    wire [5:0]  sched_round_idx;

    // Registers to hold the running hash state across multiple 512-bit blocks
    reg [31:0] current_h0, current_h1, current_h2, current_h3;
    reg [31:0] current_h4, current_h5, current_h6, current_h7;

    // -------------------------------------------------------------------------
    // Sub-module Instantiations
    // -------------------------------------------------------------------------
    
    // 1. Constants ROM
    sha256_constants u_constants (
        .round_idx (comp_round_idx),
        .k_out     (k_wire),
        .h0(h0_w), .h1(h1_w), .h2(h2_w), .h3(h3_w),
        .h4(h4_w), .h5(h5_w), .h6(h6_w), .h7(h7_w)
    );

    // 2. Message Scheduler
    message_scheduler u_scheduler (
        .clk             (clk),
        .rst             (rst),
        .start           (start),
        .en              (sched_en),
        .block_in        (block_in),
        .sched_round_idx (sched_round_idx),
        .w_out           (w_wire)
    );

    // 3. Main Compression Core
    sha256_compression u_compression (
        .clk             (clk),
        .rst             (rst),
        .start           (start),
        .k_in            (k_wire),
        .w_in            (w_wire),
        
        // If 'init' is high, use fresh constants. Otherwise, use the running hash.
        .H0_in           (init ? h0_w : current_h0),
        .H1_in           (init ? h1_w : current_h1),
        .H2_in           (init ? h2_w : current_h2),
        .H3_in           (init ? h3_w : current_h3),
        .H4_in           (init ? h4_w : current_h4),
        .H5_in           (init ? h5_w : current_h5),
        .H6_in           (init ? h6_w : current_h6),
        .H7_in           (init ? h7_w : current_h7),
        
        .en              (sched_en),
        .busy            (busy),
        .round_idx       (comp_round_idx),
        .sched_round_idx (sched_round_idx),
        .done            (done),
        .hash_out        (hash_out)
    );

    // -------------------------------------------------------------------------
    // Update the running hash state when a block completes
    // -------------------------------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            current_h0 <= 32'b0; current_h1 <= 32'b0; 
            current_h2 <= 32'b0; current_h3 <= 32'b0;
            current_h4 <= 32'b0; current_h5 <= 32'b0; 
            current_h6 <= 32'b0; current_h7 <= 32'b0;
        end else if (done) begin
            current_h0 <= hash_out[255:224];
            current_h1 <= hash_out[223:192];
            current_h2 <= hash_out[191:160];
            current_h3 <= hash_out[159:128];
            current_h4 <= hash_out[127:96];
            current_h5 <= hash_out[95:64];
            current_h6 <= hash_out[63:32];
            current_h7 <= hash_out[31:0];
        end
    end

endmodule