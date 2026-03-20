`timescale 1ns / 1ps

module tb_sha256_constants;
    reg [5:0] round_idx;
    wire [31:0] k_out;
    wire [31:0] h0, h1, h2, h3, h4, h5, h6, h7;

    sha256_constants uut (
        .round_idx(round_idx), .k_out(k_out),
        .h0(h0), .h1(h1), .h2(h2), .h3(h3),
        .h4(h4), .h5(h5), .h6(h6), .h7(h7)
    );

    initial begin
        $display("--- Starting SHA-256 Constants Test ---");
        
        // Test Initial Hash Values
        if (h0 !== 32'h6a09e667) $display("FAIL: H0 incorrect!");
        else $display("PASS: Initial Hash Values match SHA-256 standard.");

        // Test Round 0 Constant
        round_idx = 6'd0; #10;
        if (k_out !== 32'h428a2f98) $display("FAIL: K[0] incorrect!");
        else $display("PASS: K[0] is correct.");

        // Test Round 3 Constant
        round_idx = 6'd3; #10;
        if (k_out !== 32'he9b5dba5) $display("FAIL: K[3] incorrect!");
        else $display("PASS: K[3] is correct.");

        $display("--- Testbench Complete ---");
        $stop;
    end
endmodule
