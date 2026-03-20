`timescale 1ns / 1ps

module tb_sha256_compression;

    reg clk, rst, start;
    reg [31:0] k_in, w_in;
    reg [31:0] h0, h1, h2, h3, h4, h5, h6, h7;
    
    wire [5:0] round_idx;
    wire done;
    wire [255:0] hash_out;

    sha256_compression uut (
        .clk(clk), .rst(rst), .start(start),
        .k_in(k_in), .w_in(w_in),
        .H0_in(h0), .H1_in(h1), .H2_in(h2), .H3_in(h3),
        .H4_in(h4), .H5_in(h5), .H6_in(h6), .H7_in(h7),
        .round_idx(round_idx), .done(done), .hash_out(hash_out)
    );

    always #5 clk = ~clk; // 10ns clock period

    initial begin
        $display("--- Starting SHA-256 Compression Core FSM Test ---");
        clk = 0; rst = 1; start = 0;
        k_in = 32'h11111111; w_in = 32'h22222222; // Dummy data
        h0=0; h1=0; h2=0; h3=0; h4=0; h5=0; h6=0; h7=0;
        
        #20 rst = 0;
        
        // Trigger the FSM
        start = 1; #10; start = 0;
        
        // Wait for the calculation to finish (should take ~64 cycles)
        wait(done == 1'b1);
        
        $display("PASS: FSM reached DONE state.");
        if (round_idx == 6'd63) $display("PASS: FSM counted exactly 64 rounds.");
        else $display("FAIL: FSM stopped at wrong round index: %d", round_idx);
        
        #20;
        if (done == 1'b0) $display("PASS: FSM properly returned to IDLE.");
        else $display("FAIL: FSM did not clear the done flag.");
        
        $display("--- Testbench Complete ---");
        $stop;
    end
endmodule
