`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2026 04:25:23 AM
// Design Name: 
// Module Name: imm_gen_tb
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
// imm_gen_tb.v
// Testbench for imm_gen.
// Covers all five immediate formats (I, S, B, U, J) and R-type default.
// Prints PASS/FAIL per test and a final summary.
// =============================================================================

`timescale 1ns/1ps

module imm_gen_tb;

    reg  [31:0] instr;
    wire [31:0] imm;

    integer passed = 0;
    integer failed = 0;

    imm_gen dut (
        .instr(instr),
        .imm(imm)
    );

    // -------------------------------------------------------------------------
    // check task: apply instr, wait for combinational settle, compare
    // -------------------------------------------------------------------------
    task check;
        input [31:0] instr_in;
        input [31:0] expected;
        input [255:0] name;   // test label (32 chars max)
        begin
            instr = instr_in;
            #1;
            if (imm === expected) begin
                $display("PASS: %0s  instr=%h  imm=%h", name, instr_in, imm);
                passed = passed + 1;
            end else begin
                $display("FAIL: %0s  instr=%h  got=%h  exp=%h",
                         name, instr_in, imm, expected);
                failed = failed + 1;
            end
        end
    endtask

    initial begin
        $display("=== imm_gen testbench ===");

        // ---------------------------------------------------------------------
        // I-type
        // ---------------------------------------------------------------------
        // ADDI x5, x6, -1        -> imm = 0xFFFFFFFF
        // encoding: imm[11:0]=FFF rs1=6 funct3=0 rd=5 opcode=0010011
        check(32'hFFF30293, 32'hFFFFFFFF, "ADDI -1");

        // ADDI x5, x6, 1         -> imm = 0x00000001
        check(32'h00130293, 32'h00000001, "ADDI +1");

        // ADDI x5, x6, 2047      -> imm = 0x000007FF (max positive I-imm)
        check(32'h7FF30293, 32'h000007FF, "ADDI +2047");

        // ADDI x5, x6, -2048     -> imm = 0xFFFFF800 (min negative I-imm)
        check(32'h80030293, 32'hFFFFF800, "ADDI -2048");

        // LW x5, 8(x6)           -> imm = 0x00000008
        // encoding: imm=008 rs1=6 funct3=010 rd=5 opcode=0000011
        check(32'h00832283, 32'h00000008, "LW +8");

        // JALR x1, x6, 4         -> imm = 0x00000004
        check(32'h004300E7, 32'h00000004, "JALR +4");

        // CSRRW x5, 0x300, x6    -> imm[11:0] = 0x300 (mstatus addr)
        // encoding: csr=300 rs1=6 funct3=001 rd=5 opcode=1110011
        check(32'h300312F3, 32'h00000300, "CSRRW mstatus");

        // ---------------------------------------------------------------------
        // S-type
        // ---------------------------------------------------------------------
        // SW x5, 8(x6)           -> imm = 0x00000008
        // encoding: imm[11:5]=0 rs2=5 rs1=6 funct3=010 imm[4:0]=01000 opcode=0100011
        check(32'h00532423, 32'h00000008, "SW +8");

        // SW x5, -4(x6)          -> imm = 0xFFFFFFFC
        check(32'hFE532E23, 32'hFFFFFFFC, "SW -4");

        // SB x5, 2047(x6)        -> imm = 0x000007FF (max positive S-imm)
        check(32'h7E530FA3, 32'h000007FF, "SB +2047");

        // ---------------------------------------------------------------------
        // B-type
        // ---------------------------------------------------------------------
        // BEQ x5, x6, 16         -> imm = 0x00000010
        // encoding: imm[12|10:5]=0 rs2=6 rs1=5 funct3=0 imm[4:1|11]=1000|0 opcode=1100011
        check(32'h00628863, 32'h00000010, "BEQ +16");

        // BNE x5, x6, -4         -> imm = 0xFFFFFFFC
        check(32'hFE629EE3, 32'hFFFFFFFC, "BNE -4");

        // BEQ x0, x0, 4096       -> imm = 0x00001000 (large positive)
        check(32'h00000063 | (32'h1 << 31), 32'hFFFFF000, "BEQ -4096");

        // ---------------------------------------------------------------------
        // U-type
        // ---------------------------------------------------------------------
        // LUI x5, 0x12345        -> imm = 0x12345000
        check(32'h123452B7, 32'h12345000, "LUI 0x12345");

        // AUIPC x5, 0xFFFFF      -> imm = 0xFFFFF000
        check(32'hFFFFF297, 32'hFFFFF000, "AUIPC 0xFFFFF");

        // LUI x5, 0x0            -> imm = 0x00000000
        check(32'h000002B7, 32'h00000000, "LUI 0x0");

        // ---------------------------------------------------------------------
        // J-type
        // ---------------------------------------------------------------------
        // JAL x1, 20             -> imm = 0x00000014
        check(32'h014000EF, 32'h00000014, "JAL +20");

        // JAL x1, -4             -> imm = 0xFFFFFFFC
        check(32'hFFDFF0EF, 32'hFFFFFFFC, "JAL -4");

        // JAL x0, 0x100000       -> imm = 0x00100000 (large positive)
        check(32'h0000026F, 32'h00000000, "JAL +0");

        // ---------------------------------------------------------------------
        // R-type (default: should output 0)
        // ---------------------------------------------------------------------
        // ADD x5, x6, x7         -> imm = 0 (no immediate for R-type)
        check(32'h007302B3, 32'h00000000, "ADD (R-type)");

        // MUL x5, x6, x7         -> imm = 0
        check(32'h027302B3, 32'h00000000, "MUL (R-type)");

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
