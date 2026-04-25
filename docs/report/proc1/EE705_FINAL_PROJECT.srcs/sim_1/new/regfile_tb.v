`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2026 04:37:33 AM
// Design Name: 
// Module Name: regfile_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// =============================================================================
// regfile_tb.v
// Testbench for regfile.
// Covers: reset, synchronous write, combinational read, x0 hardwiring,
//         dual-port independent reads, write isolation between registers.
// Excludes: same-cycle write+read to the same address (handled by forwarding).
// =============================================================================

`timescale 1ns/1ps

module regfile_tb;

    reg         clk;
    reg         rst;
    reg  [4:0]  rs1_addr;
    reg  [4:0]  rs2_addr;
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    reg         wen;
    reg  [4:0]  rd_addr;
    reg  [31:0] rd_data;

    integer passed = 0;
    integer failed = 0;

    regfile dut (
        .clk(clk),
        .rst(rst),
        .rs1_addr(rs1_addr),
        .rs1_data(rs1_data),
        .rs2_addr(rs2_addr),
        .rs2_data(rs2_data),
        .wen(wen),
        .rd_addr(rd_addr),
        .rd_data(rd_data)
    );

    // 10 ns clock
    initial clk = 0;
    always #5 clk = ~clk;

    // -------------------------------------------------------------------------
    // check task: verify a read port value against expected
    // -------------------------------------------------------------------------
    task check;
        input [31:0]  actual;
        input [31:0]  expected;
        input [255:0] name;
        begin
            if (actual === expected) begin
                $display("PASS: %0s  got=%h  exp=%h", name, actual, expected);
                passed = passed + 1;
            end else begin
                $display("FAIL: %0s  got=%h  exp=%h", name, actual, expected);
                failed = failed + 1;
            end
        end
    endtask

    // -------------------------------------------------------------------------
    // write task: perform a synchronous write on the next posedge
    // -------------------------------------------------------------------------
    task do_write;
        input [4:0]  addr;
        input [31:0] data;
        begin
            @(negedge clk);
            wen     = 1'b1;
            rd_addr = addr;
            rd_data = data;
            @(posedge clk);
            @(negedge clk);
            wen     = 1'b0;
        end
    endtask

    initial begin
        $display("=== regfile testbench ===");

        // Init
        rst      = 1'b1;
        wen      = 1'b0;
        rd_addr  = 5'd0;
        rd_data  = 32'b0;
        rs1_addr = 5'd0;
        rs2_addr = 5'd0;

        // ---------------------------------------------------------------------
        // Reset: hold for 2 cycles, then verify a few registers read as 0
        // ---------------------------------------------------------------------
        @(posedge clk);
        @(posedge clk);
        @(negedge clk);
        rst = 1'b0;

        rs1_addr = 5'd1;  #1;
        check(rs1_data, 32'h00000000, "reset x1 = 0");
        rs1_addr = 5'd15; #1;
        check(rs1_data, 32'h00000000, "reset x15 = 0");
        rs1_addr = 5'd31; #1;
        check(rs1_data, 32'h00000000, "reset x31 = 0");

        // ---------------------------------------------------------------------
        // Basic write then read
        // ---------------------------------------------------------------------
        do_write(5'd1, 32'hDEADBEEF);
        rs1_addr = 5'd1; #1;
        check(rs1_data, 32'hDEADBEEF, "write x1, read x1");

        do_write(5'd2, 32'h12345678);
        rs1_addr = 5'd2; #1;
        check(rs1_data, 32'h12345678, "write x2, read x2");

        do_write(5'd31, 32'hCAFEBABE);
        rs1_addr = 5'd31; #1;
        check(rs1_data, 32'hCAFEBABE, "write x31, read x31");

        // ---------------------------------------------------------------------
        // x0 hardwiring: writes must be discarded, reads must return 0
        // ---------------------------------------------------------------------
        do_write(5'd0, 32'hFFFFFFFF);
        rs1_addr = 5'd0; #1;
        check(rs1_data, 32'h00000000, "write x0 discarded");

        rs2_addr = 5'd0; #1;
        check(rs2_data, 32'h00000000, "read x0 port2 = 0");

        // ---------------------------------------------------------------------
        // Dual-port independent reads: both ports read different regs
        // ---------------------------------------------------------------------
        rs1_addr = 5'd1;
        rs2_addr = 5'd2;
        #1;
        check(rs1_data, 32'hDEADBEEF, "dual read port1=x1");
        check(rs2_data, 32'h12345678, "dual read port2=x2");

        // Both ports read the same register
        rs1_addr = 5'd31;
        rs2_addr = 5'd31;
        #1;
        check(rs1_data, 32'hCAFEBABE, "same-reg port1=x31");
        check(rs2_data, 32'hCAFEBABE, "same-reg port2=x31");

        // ---------------------------------------------------------------------
        // Write isolation: writing one register must not disturb others
        // ---------------------------------------------------------------------
        do_write(5'd5, 32'hAAAAAAAA);
        rs1_addr = 5'd1;  #1;
        check(rs1_data, 32'hDEADBEEF, "x1 undisturbed");
        rs1_addr = 5'd2;  #1;
        check(rs1_data, 32'h12345678, "x2 undisturbed");
        rs1_addr = 5'd5;  #1;
        check(rs1_data, 32'hAAAAAAAA, "x5 new value");
        rs1_addr = 5'd31; #1;
        check(rs1_data, 32'hCAFEBABE, "x31 undisturbed");

        // ---------------------------------------------------------------------
        // wen=0 must not write
        // ---------------------------------------------------------------------
        @(negedge clk);
        wen     = 1'b0;
        rd_addr = 5'd1;
        rd_data = 32'h00000000;  // would zero x1 if write went through
        @(posedge clk);
        @(negedge clk);
        rs1_addr = 5'd1; #1;
        check(rs1_data, 32'hDEADBEEF, "wen=0 no write");

        // ---------------------------------------------------------------------
        // Overwrite existing register
        // ---------------------------------------------------------------------
        do_write(5'd1, 32'h11111111);
        rs1_addr = 5'd1; #1;
        check(rs1_data, 32'h11111111, "overwrite x1");

        // ---------------------------------------------------------------------
        // Summary
        // ---------------------------------------------------------------------
        $display("=== Summary: %0d passed, %0d failed ===", passed, failed);
        if (failed == 0)
            $display("ALL TESTS PASSED");
        else
            $display("SOME TESTS FAILED");
        $finish;
    end

endmodule
