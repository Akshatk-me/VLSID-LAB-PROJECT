`timescale 1ns / 1ps

module tb_message_scheduler;
    reg clk, rst, en;
    reg [511:0] block_in;
    reg [5:0] round_idx;
    wire [31:0] w_out;

    message_scheduler uut (
        .clk(clk), .rst(rst), .en(en),
        .block_in(block_in), .round_idx(round_idx), .w_out(w_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1; en = 0; round_idx = 0;
        // Dummy 512-bit block (e.g., first 32 bits are 0xDEADBEEF)
        block_in = {32'hDEADBEEF, 480'b0}; 
        #10;
        
        $display("--- Starting Message Scheduler Test ---");
        rst = 0; en = 1; #10;

        // In round 0, the output should be the first 32-bit word of the input block
        if (w_out !== 32'hDEADBEEF) $display("FAIL: Round 0 word incorrect!");
        else $display("PASS: Round 0 word matches input block.");

        $display("--- Testbench Complete ---");
        $stop;
    end
endmodule
