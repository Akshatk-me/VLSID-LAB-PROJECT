`timescale 1ns / 1ps

module tb_register_file;

    // Inputs
    reg clk;
    reg we;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [31:0] wd;

    // Outputs
    wire [31:0] rd1;
    wire [31:0] rd2;

    // Instantiate the Unit Under Test (UUT)
    register_file uut (
        .clk(clk), 
        .we(we), 
        .rs1(rs1), 
        .rs2(rs2), 
        .rd(rd), 
        .wd(wd), 
        .rd1(rd1), 
        .rd2(rd2)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        we = 0;
        rs1 = 0;
        rs2 = 0;
        rd = 0;
        wd = 0;

        // Wait 10 ns for global reset to finish
        #10;
        $display("--- Starting Register File Test ---");

        // TEST 1: Write to x0 and verify it remains 0
        we = 1;
        rd = 5'd0;
        wd = 32'hDEADBEEF;
        #10;
        we = 0;
        rs1 = 5'd0;
        #10;
        if (rd1 !== 32'h00000000) $display("FAIL: x0 was overwritten!");
        else $display("PASS: x0 is hardwired to 0.");

        // TEST 2: Write to a standard register (x5) and read it back
        we = 1;
        rd = 5'd5;
        wd = 32'h12345678;
        #10;
        we = 0;
        rs1 = 5'd5;
        #10;
        if (rd1 !== 32'h12345678) $display("FAIL: x5 read/write failed!");
        else $display("PASS: Normal register write and read successful.");

        // TEST 3: Asynchronous dual-read check (Read x5 and x0 simultaneously)
        rs1 = 5'd5;
        rs2 = 5'd0;
        #10;
        if (rd1 === 32'h12345678 && rd2 === 32'h00000000) 
            $display("PASS: Asynchronous dual-read successful.");
        else 
            $display("FAIL: Asynchronous dual-read failed!");

        // TEST 4: Write to x31
        we = 1;
        rd = 5'd31;
        wd = 32'hFFFFFFFF;
        #10;
        we = 0;
        rs2 = 5'd31;
        #10;
        if (rd2 !== 32'hFFFFFFFF) $display("FAIL: x31 read/write failed!");
        else $display("PASS: High register boundary (x31) write and read successful.");

        $display("--- Testbench Complete ---");
        $stop;
    end
      
endmodule
