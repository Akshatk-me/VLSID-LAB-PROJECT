// =============================================================================
// core_top_tb.v
// Comprehensive functional testbench for the RV32IM pipelined core.
// No hazard unit yet - load-use distances 1 and 2 will fail and are excluded.
//
// Phases:
//   A: Loads (LW) into x1..x8 from BRAM
//   B: Verify loaded values
//   C: Independent ALU + multiply tests (every op, with edge cases)
//   D: Forwarding tests at distances 1..6, both rs1 and rs2 paths
//   E: Sequential dependency chains
//   F: Multiple-stage simultaneous dependencies (forwarding priority)
//   G: x0 hardwiring tests (write to x0 must not stick)
//   H: Boundary value tests (signed/unsigned ALU edge cases)
//   I: Multiply edge cases (signed boundaries, overflow into upper word)
//   J: Summary
//
// Hierarchical regfile peek: dut.u_id_stage.u_regfile.regs[N]
// =============================================================================

`timescale 1ns/1ps

module core_top_tb;

    reg         clk;
    reg         rst;
    reg         stall;
    reg         flush;

    reg  [31:0] pc_in;
    reg  [31:0] pc_plus_4_in;
    reg  [31:0] instr_in;

    wire [31:0] wb_write_data;
    wire [4:0]  wb_rd_addr;
    wire        wb_reg_write;
    wire        wb_valid;

    integer passed = 0;
    integer failed = 0;

    core_top dut (
        .clk           (clk),
        .rst           (rst),
        .stall         (stall),
        .flush         (flush),
        .pc_in         (pc_in),
        .pc_plus_4_in  (pc_plus_4_in),
        .instr_in      (instr_in),
        .wb_write_data (wb_write_data),
        .wb_rd_addr    (wb_rd_addr),
        .wb_reg_write  (wb_reg_write),
        .wb_valid      (wb_valid)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    reg [31:0] cur_pc;

    // -------------------------------------------------------------------------
    // Encoding helpers
    // -------------------------------------------------------------------------
    function [31:0] enc_r;
        input [6:0] funct7; input [4:0] rs2; input [4:0] rs1;
        input [2:0] funct3; input [4:0] rd;  input [6:0] opcode;
        begin enc_r = {funct7, rs2, rs1, funct3, rd, opcode}; end
    endfunction

    function [31:0] enc_i;
        input [11:0] imm; input [4:0] rs1; input [2:0] funct3;
        input [4:0]  rd;  input [6:0] opcode;
        begin enc_i = {imm, rs1, funct3, rd, opcode}; end
    endfunction

    function [31:0] enc_u;
        input [19:0] imm; input [4:0] rd; input [6:0] opcode;
        begin enc_u = {imm, rd, opcode}; end
    endfunction

    // Instruction builders
    function [31:0] mk_lw;    input [11:0] o; input [4:0] s; input [4:0] d;
        begin mk_lw    = enc_i(o, s, 3'b010, d, 7'b0000011); end endfunction
    function [31:0] mk_addi;  input [11:0] i; input [4:0] s; input [4:0] d;
        begin mk_addi  = enc_i(i, s, 3'b000, d, 7'b0010011); end endfunction
    function [31:0] mk_slti;  input [11:0] i; input [4:0] s; input [4:0] d;
        begin mk_slti  = enc_i(i, s, 3'b010, d, 7'b0010011); end endfunction
    function [31:0] mk_sltiu; input [11:0] i; input [4:0] s; input [4:0] d;
        begin mk_sltiu = enc_i(i, s, 3'b011, d, 7'b0010011); end endfunction
    function [31:0] mk_xori;  input [11:0] i; input [4:0] s; input [4:0] d;
        begin mk_xori  = enc_i(i, s, 3'b100, d, 7'b0010011); end endfunction
    function [31:0] mk_ori;   input [11:0] i; input [4:0] s; input [4:0] d;
        begin mk_ori   = enc_i(i, s, 3'b110, d, 7'b0010011); end endfunction
    function [31:0] mk_andi;  input [11:0] i; input [4:0] s; input [4:0] d;
        begin mk_andi  = enc_i(i, s, 3'b111, d, 7'b0010011); end endfunction
    function [31:0] mk_slli;  input [4:0]  sh; input [4:0] s; input [4:0] d;
        begin mk_slli  = enc_i({7'b0, sh}, s, 3'b001, d, 7'b0010011); end endfunction
    function [31:0] mk_srli;  input [4:0]  sh; input [4:0] s; input [4:0] d;
        begin mk_srli  = enc_i({7'b0, sh}, s, 3'b101, d, 7'b0010011); end endfunction
    function [31:0] mk_srai;  input [4:0]  sh; input [4:0] s; input [4:0] d;
        begin mk_srai  = enc_i({7'b0100000, sh}, s, 3'b101, d, 7'b0010011); end endfunction

    function [31:0] mk_add;   input [4:0] s2; input [4:0] s1; input [4:0] d;
        begin mk_add  = enc_r(7'b0000000, s2, s1, 3'b000, d, 7'b0110011); end endfunction
    function [31:0] mk_sub;   input [4:0] s2; input [4:0] s1; input [4:0] d;
        begin mk_sub  = enc_r(7'b0100000, s2, s1, 3'b000, d, 7'b0110011); end endfunction
    function [31:0] mk_and;   input [4:0] s2; input [4:0] s1; input [4:0] d;
        begin mk_and  = enc_r(7'b0000000, s2, s1, 3'b111, d, 7'b0110011); end endfunction
    function [31:0] mk_or;    input [4:0] s2; input [4:0] s1; input [4:0] d;
        begin mk_or   = enc_r(7'b0000000, s2, s1, 3'b110, d, 7'b0110011); end endfunction
    function [31:0] mk_xor;   input [4:0] s2; input [4:0] s1; input [4:0] d;
        begin mk_xor  = enc_r(7'b0000000, s2, s1, 3'b100, d, 7'b0110011); end endfunction
    function [31:0] mk_sll;   input [4:0] s2; input [4:0] s1; input [4:0] d;
        begin mk_sll  = enc_r(7'b0000000, s2, s1, 3'b001, d, 7'b0110011); end endfunction
    function [31:0] mk_srl;   input [4:0] s2; input [4:0] s1; input [4:0] d;
        begin mk_srl  = enc_r(7'b0000000, s2, s1, 3'b101, d, 7'b0110011); end endfunction
    function [31:0] mk_sra;   input [4:0] s2; input [4:0] s1; input [4:0] d;
        begin mk_sra  = enc_r(7'b0100000, s2, s1, 3'b101, d, 7'b0110011); end endfunction
    function [31:0] mk_slt;   input [4:0] s2; input [4:0] s1; input [4:0] d;
        begin mk_slt  = enc_r(7'b0000000, s2, s1, 3'b010, d, 7'b0110011); end endfunction
    function [31:0] mk_sltu;  input [4:0] s2; input [4:0] s1; input [4:0] d;
        begin mk_sltu = enc_r(7'b0000000, s2, s1, 3'b011, d, 7'b0110011); end endfunction

    function [31:0] mk_mul;   input [4:0] s2; input [4:0] s1; input [4:0] d;
        begin mk_mul    = enc_r(7'b0000001, s2, s1, 3'b000, d, 7'b0110011); end endfunction
    function [31:0] mk_mulh;  input [4:0] s2; input [4:0] s1; input [4:0] d;
        begin mk_mulh   = enc_r(7'b0000001, s2, s1, 3'b001, d, 7'b0110011); end endfunction
    function [31:0] mk_mulhsu;input [4:0] s2; input [4:0] s1; input [4:0] d;
        begin mk_mulhsu = enc_r(7'b0000001, s2, s1, 3'b010, d, 7'b0110011); end endfunction
    function [31:0] mk_mulhu; input [4:0] s2; input [4:0] s1; input [4:0] d;
        begin mk_mulhu  = enc_r(7'b0000001, s2, s1, 3'b011, d, 7'b0110011); end endfunction

    function [31:0] mk_lui;   input [19:0] i; input [4:0] d;
        begin mk_lui = enc_u(i, d, 7'b0110111); end endfunction
    function [31:0] mk_auipc; input [19:0] i; input [4:0] d;
        begin mk_auipc = enc_u(i, d, 7'b0010111); end endfunction

    localparam [31:0] NOP = 32'h00000013;

    // -------------------------------------------------------------------------
    // Tasks
    // -------------------------------------------------------------------------
    task inject;
        input [31:0] instr;
        begin
            @(negedge clk);
            pc_in        = cur_pc;
            pc_plus_4_in = cur_pc + 32'd4;
            instr_in     = instr;
            @(posedge clk);
            cur_pc = cur_pc + 32'd4;
        end
    endtask

    task inject_nop; begin inject(NOP); end endtask

    task drain;
        input integer n;
        integer i;
        begin
            for (i = 0; i < n; i = i + 1) inject_nop();
        end
    endtask

    task check_reg;
        input [4:0]   r;
        input [31:0]  expected;
        input [255:0] name;
        begin
            if (dut.u_id_stage.u_regfile.regs[r] === expected) begin
                $display("PASS: %0s  x%0d=%h", name, r, dut.u_id_stage.u_regfile.regs[r]);
                passed = passed + 1;
            end else begin
                $display("FAIL: %0s  x%0d got=%h exp=%h",
                         name, r, dut.u_id_stage.u_regfile.regs[r], expected);
                failed = failed + 1;
            end
        end
    endtask

    // -------------------------------------------------------------------------
    // Main
    // -------------------------------------------------------------------------
    initial begin
        $display("=== core_top comprehensive testbench ===");

        rst          = 1'b1;
        stall        = 1'b0;
        flush        = 1'b0;
        pc_in        = 32'b0;
        pc_plus_4_in = 32'b0;
        instr_in     = NOP;
        cur_pc       = 32'h00001000;

        repeat (5) @(posedge clk);
        @(negedge clk);
        rst = 1'b0;
        repeat (2) @(posedge clk);

        // =====================================================================
        // PHASE A: loads
        // BRAM:
        //   0:DEADBEEF 1:12345678 2:CAFEBABE 3:0BADF00D
        //   4:A5A5A5A5 5:5A5A5A5A 6:FFFFFFFF 7:00000001
        //   8:00000002 9:00000003 10:00000004 11:00000005
        //   12:00000010 13:00000020 14:00000040 15:00000080
        // =====================================================================
        $display("--- Phase A: loads ---");
        inject(mk_lw(12'd0, 5'd0, 5'd1));
        inject(mk_lw(12'd1, 5'd0, 5'd2));
        inject(mk_lw(12'd2, 5'd0, 5'd3));
        inject(mk_lw(12'd3, 5'd0, 5'd4));
        inject(mk_lw(12'd4, 5'd0, 5'd5));
        inject(mk_lw(12'd5, 5'd0, 5'd6));
        inject(mk_lw(12'd6, 5'd0, 5'd7));
        inject(mk_lw(12'd7, 5'd0, 5'd8));
        drain(10);

        // =====================================================================
        // PHASE B: verify loads
        // =====================================================================
        $display("--- Phase B: verify loads ---");
        check_reg(5'd1, 32'hDEADBEEF, "load x1");
        check_reg(5'd2, 32'h12345678, "load x2");
        check_reg(5'd3, 32'hCAFEBABE, "load x3");
        check_reg(5'd4, 32'h0BADF00D, "load x4");
        check_reg(5'd5, 32'hA5A5A5A5, "load x5");
        check_reg(5'd6, 32'h5A5A5A5A, "load x6");
        check_reg(5'd7, 32'hFFFFFFFF, "load x7");
        check_reg(5'd8, 32'h00000001, "load x8");

        // Load more values for arithmetic tests
        inject(mk_lw(12'd8,  5'd0, 5'd9));    // x9  = 2
        inject(mk_lw(12'd9,  5'd0, 5'd10));   // x10 = 3
        inject(mk_lw(12'd10, 5'd0, 5'd11));   // x11 = 4
        inject(mk_lw(12'd11, 5'd0, 5'd12));   // x12 = 5
        inject(mk_lw(12'd12, 5'd0, 5'd13));   // x13 = 16
        inject(mk_lw(12'd13, 5'd0, 5'd14));   // x14 = 32
        inject(mk_lw(12'd14, 5'd0, 5'd15));   // x15 = 64
        inject(mk_lw(12'd15, 5'd0, 5'd16));   // x16 = 128
        drain(10);

        check_reg(5'd9,  32'd2,   "load x9");
        check_reg(5'd10, 32'd3,   "load x10");
        check_reg(5'd11, 32'd4,   "load x11");
        check_reg(5'd12, 32'd5,   "load x12");
        check_reg(5'd13, 32'd16,  "load x13");
        check_reg(5'd14, 32'd32,  "load x14");
        check_reg(5'd15, 32'd64,  "load x15");
        check_reg(5'd16, 32'd128, "load x16");

        // =====================================================================
        // PHASE C: independent ALU + multiply
        // =====================================================================
        $display("--- Phase C: independent ALU + multiply ---");

        // R-type ALU ops
        inject(mk_add (5'd2, 5'd1, 5'd17));  drain(8);  // DEADBEEF + 12345678
        inject(mk_sub (5'd1, 5'd2, 5'd18));  drain(8);  // 12345678 - DEADBEEF
        inject(mk_and (5'd5, 5'd1, 5'd19));  drain(8);  // DEADBEEF & A5A5A5A5
        inject(mk_or  (5'd2, 5'd1, 5'd20));  drain(8);  // DEADBEEF | 12345678
        inject(mk_xor (5'd2, 5'd1, 5'd21));  drain(8);  // DEADBEEF ^ 12345678
        inject(mk_sll (5'd9, 5'd8, 5'd22));  drain(8);  // 1 << 2 = 4
        inject(mk_srl (5'd9, 5'd7, 5'd23));  drain(8);  // FFFFFFFF >> 2 = 3FFFFFFF
        inject(mk_sra (5'd9, 5'd7, 5'd24));  drain(8);  // FFFFFFFF >>> 2 = FFFFFFFF
        inject(mk_slt (5'd2, 5'd1, 5'd25));  drain(8);  // (DEADBEEF <s 12345678) = 1
        inject(mk_sltu(5'd2, 5'd1, 5'd26));  drain(8);  // (DEADBEEF <u 12345678) = 0

        check_reg(5'd17, 32'hDEADBEEF + 32'h12345678, "ADD");
        check_reg(5'd18, 32'h12345678 - 32'hDEADBEEF, "SUB");
        check_reg(5'd19, 32'hDEADBEEF & 32'hA5A5A5A5, "AND");
        check_reg(5'd20, 32'hDEADBEEF | 32'h12345678, "OR");
        check_reg(5'd21, 32'hDEADBEEF ^ 32'h12345678, "XOR");
        check_reg(5'd22, 32'd4,           "SLL 1<<2");
        check_reg(5'd23, 32'h3FFFFFFF,    "SRL FFFFFFFF>>2");
        check_reg(5'd24, 32'hFFFFFFFF,    "SRA FFFFFFFF>>>2");
        check_reg(5'd25, 32'd1,           "SLT");
        check_reg(5'd26, 32'd0,           "SLTU");

        // I-type ALU ops
        inject(mk_addi (12'h0FF,    5'd8,  5'd17));  drain(8);  // 1 + 0xFF = 0x100
        inject(mk_addi (12'hFFF,    5'd8,  5'd18));  drain(8);  // 1 + (-1) = 0
        inject(mk_slti (12'd100,    5'd9,  5'd19));  drain(8);  // (2 < 100) = 1
        inject(mk_slti (12'h800,    5'd9,  5'd20));  drain(8);  // (2 < -2048) = 0
        inject(mk_sltiu(12'd100,    5'd9,  5'd21));  drain(8);  // (2 <u 100) = 1
        inject(mk_sltiu(12'h800,    5'd9,  5'd22));  drain(8);  // (2 <u 0xFFFFF800) = 1
        inject(mk_xori (12'hFFF,    5'd8,  5'd23));  drain(8);  // 1 ^ -1 = -2
        inject(mk_ori  (12'h0F0,    5'd0,  5'd24));  drain(8);  // 0 | 0xF0 = 0xF0
        inject(mk_andi (12'h0F0,    5'd1,  5'd25));  drain(8);  // DEADBEEF & 0xF0 = 0xE0
        inject(mk_slli (5'd4,       5'd8,  5'd26));  drain(8);  // 1 << 4 = 16
        inject(mk_srli (5'd4,       5'd7,  5'd27));  drain(8);  // FFFFFFFF >> 4 = 0FFFFFFF
        inject(mk_srai (5'd4,       5'd7,  5'd28));  drain(8);  // FFFFFFFF >>> 4 = FFFFFFFF

        check_reg(5'd17, 32'h00000100, "ADDI +0xFF");
        check_reg(5'd18, 32'h00000000, "ADDI -1");
        check_reg(5'd19, 32'd1,        "SLTI 2<100");
        check_reg(5'd20, 32'd0,        "SLTI 2<-2048");
        check_reg(5'd21, 32'd1,        "SLTIU 2<100");
        check_reg(5'd22, 32'd1,        "SLTIU 2<0xFFFFF800");
        check_reg(5'd23, 32'hFFFFFFFE, "XORI 1^-1");
        check_reg(5'd24, 32'h000000F0, "ORI");
        check_reg(5'd25, 32'h000000E0, "ANDI");
        check_reg(5'd26, 32'd16,       "SLLI 1<<4");
        check_reg(5'd27, 32'h0FFFFFFF, "SRLI");
        check_reg(5'd28, 32'hFFFFFFFF, "SRAI");

        // U-type
        inject(mk_lui  (20'h12345, 5'd29));  drain(8);  // 0x12345000
        inject(mk_lui  (20'hFFFFF, 5'd30));  drain(8);  // 0xFFFFF000
        inject(mk_lui  (20'h00000, 5'd31));  drain(8);  // 0
        check_reg(5'd29, 32'h12345000, "LUI 0x12345");
        check_reg(5'd30, 32'hFFFFF000, "LUI 0xFFFFF");
        check_reg(5'd31, 32'h00000000, "LUI 0");

        // Multiplies
        inject(mk_mul  (5'd9, 5'd9, 5'd17));  drain(8);  // 2 * 2 = 4
        inject(mk_mul  (5'd13, 5'd14, 5'd18));  drain(8);  // 16 * 32 = 512
        inject(mk_mul  (5'd8, 5'd6, 5'd19));  drain(8);  // 1 * 5A5A5A5A = 5A5A5A5A
        inject(mk_mul  (5'd2, 5'd1, 5'd20));  drain(8);  // DEADBEEF * 12345678 (low)
        inject(mk_mulh (5'd2, 5'd1, 5'd21));  drain(8);  // (high signed)
        inject(mk_mulhu(5'd2, 5'd1, 5'd22));  drain(8);  // (high unsigned)
        inject(mk_mulhsu(5'd2, 5'd1, 5'd23)); drain(8);  // (rs1 unsigned, rs2 signed)

        check_reg(5'd17, 32'd4,   "MUL 2*2");
        check_reg(5'd18, 32'd512, "MUL 16*32");
        check_reg(5'd19, 32'h5A5A5A5A, "MUL 1*5A5A5A5A");
        // 64-bit signed product of DEADBEEF (-559038737) * 12345678 (305419896)
        check_reg(5'd20, ($signed({{32{1'b1}}, 32'hDEADBEEF}) *
                          $signed({{32{1'b0}}, 32'h12345678})) & 32'hFFFFFFFF, "MUL low");
        check_reg(5'd21, ($signed({{32{1'b1}}, 32'hDEADBEEF}) *
                          $signed({{32{1'b0}}, 32'h12345678})) >>> 32, "MULH");
        check_reg(5'd22, ({32'b0, 32'hDEADBEEF} * {32'b0, 32'h12345678}) >> 32, "MULHU");
        // MULHSU: rs1 unsigned (DEADBEEF), rs2 signed (12345678 = positive)
        check_reg(5'd23, ($signed({1'b0, 32'hDEADBEEF}) *
                          $signed({{32{1'b0}}, 32'h12345678})) >>> 32, "MULHSU");

        // =====================================================================
        // PHASE D: forwarding tests at distances 1..6
        // Use small clean values: x9=2, x10=3, x11=4, x12=5
        // =====================================================================
        $display("--- Phase D: forwarding distances ---");

        // ----- Distance 1 (back-to-back), rs1 forwarding from EX/MEM1 -----
        inject(mk_addi(12'd10, 5'd0, 5'd17));  // x17 = 10
        inject(mk_add(5'd9, 5'd17, 5'd18));    // x18 = x17 + x9 = 12 (rs1 fwd from EX/MEM1)
        drain(10);
        check_reg(5'd17, 32'd10, "d1 producer");
        check_reg(5'd18, 32'd12, "d1 rs1 fwd");

        // ----- Distance 1, rs2 forwarding from EX/MEM1 -----
        inject(mk_addi(12'd20, 5'd0, 5'd19));  // x19 = 20
        inject(mk_add(5'd19, 5'd9, 5'd20));    // x20 = x9 + x19 = 22 (rs2 fwd)
        drain(10);
        check_reg(5'd19, 32'd20, "d1 producer rs2");
        check_reg(5'd20, 32'd22, "d1 rs2 fwd");

        // ----- Distance 2 (1 NOP), rs1 forwarding from MEM1/MEM2 -----
        inject(mk_addi(12'd30, 5'd0, 5'd21));  // x21 = 30
        inject_nop();
        inject(mk_add(5'd9, 5'd21, 5'd22));    // x22 = x21 + 2 = 32
        drain(10);
        check_reg(5'd21, 32'd30, "d2 producer");
        check_reg(5'd22, 32'd32, "d2 rs1 fwd");

        // ----- Distance 2, rs2 forwarding -----
        inject(mk_addi(12'd40, 5'd0, 5'd23));  // x23 = 40
        inject_nop();
        inject(mk_add(5'd23, 5'd9, 5'd24));    // x24 = 2 + 40 = 42
        drain(10);
        check_reg(5'd23, 32'd40, "d2 producer rs2");
        check_reg(5'd24, 32'd42, "d2 rs2 fwd");

        // ----- Distance 3 (2 NOPs), rs1 from MEM2/MEM3 -----
        inject(mk_addi(12'd50, 5'd0, 5'd25));  // x25 = 50
        inject_nop(); inject_nop();
        inject(mk_add(5'd9, 5'd25, 5'd26));    // x26 = 50 + 2 = 52
        drain(10);
        check_reg(5'd25, 32'd50, "d3 producer");
        check_reg(5'd26, 32'd52, "d3 rs1 fwd");

        // ----- Distance 3, rs2 -----
        inject(mk_addi(12'd60, 5'd0, 5'd27));  // x27 = 60
        inject_nop(); inject_nop();
        inject(mk_add(5'd27, 5'd9, 5'd28));    // x28 = 2 + 60 = 62
        drain(10);
        check_reg(5'd27, 32'd60, "d3 producer rs2");
        check_reg(5'd28, 32'd62, "d3 rs2 fwd");

        // ----- Distance 4 (3 NOPs), rs1 from MEM3/WB -----
        inject(mk_addi(12'd70, 5'd0, 5'd29));  // x29 = 70
        inject_nop(); inject_nop(); inject_nop();
        inject(mk_add(5'd9, 5'd29, 5'd30));    // x30 = 70 + 2 = 72
        drain(10);
        check_reg(5'd29, 32'd70, "d4 producer");
        check_reg(5'd30, 32'd72, "d4 rs1 fwd");

        // ----- Distance 5 (4 NOPs), rs1 from MEM3/WB into ID -----
        inject(mk_addi(12'd80, 5'd0, 5'd31));  // x31 = 80
        inject_nop(); inject_nop(); inject_nop(); inject_nop();
        inject(mk_add(5'd9, 5'd31, 5'd17));    // x17 = 80 + 2 = 82 (overwrite)
        drain(10);
        check_reg(5'd31, 32'd80, "d5 producer");
        check_reg(5'd17, 32'd82, "d5 ID-stage WB->ID fwd");

        // ----- Distance 6 (5 NOPs), regfile read after WB completed (no fwd needed) -----
        inject(mk_addi(12'd90, 5'd0, 5'd18));  // x18 = 90 (overwrite)
        inject_nop(); inject_nop(); inject_nop(); inject_nop(); inject_nop();
        inject(mk_add(5'd9, 5'd18, 5'd19));    // x19 = 90 + 2 = 92 (overwrite)
        drain(10);
        check_reg(5'd18, 32'd90, "d6 producer");
        check_reg(5'd19, 32'd92, "d6 plain regfile");

        // =====================================================================
        // PHASE E: dependency chains
        // =====================================================================
        $display("--- Phase E: dependency chains ---");

        // 5-instruction chain, every step distance 1
        inject(mk_addi(12'd1, 5'd0, 5'd20));  // x20 = 1
        inject(mk_add(5'd9, 5'd20, 5'd21));   // x21 = 1 + 2 = 3
        inject(mk_add(5'd9, 5'd21, 5'd22));   // x22 = 3 + 2 = 5
        inject(mk_add(5'd9, 5'd22, 5'd23));   // x23 = 5 + 2 = 7
        inject(mk_add(5'd9, 5'd23, 5'd24));   // x24 = 7 + 2 = 9
        drain(10);
        check_reg(5'd20, 32'd1, "chain x20");
        check_reg(5'd21, 32'd3, "chain x21");
        check_reg(5'd22, 32'd5, "chain x22");
        check_reg(5'd23, 32'd7, "chain x23");
        check_reg(5'd24, 32'd9, "chain x24");

        // Mixed chain with both rs1 and rs2 forwarding alternating
        inject(mk_addi(12'd5, 5'd0, 5'd25));  // x25 = 5
        inject(mk_add(5'd25, 5'd9, 5'd26));   // x26 = 2 + 5 = 7 (rs2 fwd)
        inject(mk_add(5'd9, 5'd26, 5'd27));   // x27 = 7 + 2 = 9 (rs1 fwd)
        inject(mk_add(5'd27, 5'd26, 5'd28));  // x28 = 7 + 9 = 16 (both fwd)
        drain(10);
        check_reg(5'd25, 32'd5,  "mixed x25");
        check_reg(5'd26, 32'd7,  "mixed x26");
        check_reg(5'd27, 32'd9,  "mixed x27");
        check_reg(5'd28, 32'd16, "mixed x28");

        // =====================================================================
        // PHASE F: simultaneous dependencies (forwarding priority test)
        // Two producers ahead, both writing the same dest. Youngest must win.
        // =====================================================================
        $display("--- Phase F: forwarding priority ---");

        // Two writes to x29: youngest is at distance 1, oldest at distance 2.
        // The consumer should read the youngest value.
        inject(mk_addi(12'd100, 5'd0, 5'd29)); // x29 = 100 (older, distance 2)
        inject(mk_addi(12'd200, 5'd0, 5'd29)); // x29 = 200 (younger, distance 1)
        inject(mk_add(5'd9, 5'd29, 5'd30));    // x30 = 200 + 2 = 202
        drain(10);
        check_reg(5'd29, 32'd200, "priority producer (final value)");
        check_reg(5'd30, 32'd202, "priority youngest wins");

        // Three writes to x31, oldest at d3, then d2, then d1; consumer reads youngest
        inject(mk_addi(12'd1, 5'd0, 5'd31));   // x31 = 1 (d3)
        inject(mk_addi(12'd2, 5'd0, 5'd31));   // x31 = 2 (d2)
        inject(mk_addi(12'd3, 5'd0, 5'd31));   // x31 = 3 (d1)
        inject(mk_add(5'd9, 5'd31, 5'd17));    // x17 = 3 + 2 = 5
        drain(10);
        check_reg(5'd31, 32'd3, "triple producer");
        check_reg(5'd17, 32'd5, "triple youngest wins");

        // =====================================================================
        // PHASE G: x0 hardwiring
        // =====================================================================
        $display("--- Phase G: x0 hardwiring ---");

        // Try to write x0 in many ways
        inject(mk_addi(12'd123, 5'd0, 5'd0));  // x0 = 123 (must be discarded)
        drain(8);
        check_reg(5'd0, 32'd0, "x0 ADDI discarded");

        inject(mk_lui(20'hABCDE, 5'd0));       // x0 = 0xABCDE000 (must be discarded)
        drain(8);
        check_reg(5'd0, 32'd0, "x0 LUI discarded");

        inject(mk_add(5'd1, 5'd2, 5'd0));      // x0 = x1 + x2 (must be discarded)
        drain(8);
        check_reg(5'd0, 32'd0, "x0 ADD discarded");

        // Read from x0 in arithmetic
        inject(mk_addi(12'd55, 5'd0, 5'd18));  // x18 = 0 + 55 = 55
        drain(8);
        check_reg(5'd18, 32'd55, "x0 read as 0");

        // =====================================================================
        // PHASE H: ALU boundary values
        // =====================================================================
        $display("--- Phase H: ALU boundary values ---");

        // Load some boundary values via ADDI/LUI combinations
        // Build INT_MAX = 0x7FFFFFFF: LUI 0x80000 + ADDI -1
        inject(mk_lui(20'h80000, 5'd19));     drain(8);  // x19 = 0x80000000
        inject(mk_addi(12'hFFF, 5'd19, 5'd20)); drain(8); // x20 = 0x7FFFFFFF (INT_MAX)
        check_reg(5'd19, 32'h80000000, "INT_MIN");
        check_reg(5'd20, 32'h7FFFFFFF, "INT_MAX");

        // INT_MIN + 1
        inject(mk_addi(12'd1, 5'd19, 5'd21)); drain(8);
        check_reg(5'd21, 32'h80000001, "INT_MIN + 1");

        // INT_MAX + 1 (overflow)
        inject(mk_addi(12'd1, 5'd20, 5'd22)); drain(8);
        check_reg(5'd22, 32'h80000000, "INT_MAX + 1 (overflow)");

        // SLT INT_MIN < INT_MAX (signed) = 1
        inject(mk_slt(5'd20, 5'd19, 5'd23)); drain(8);
        check_reg(5'd23, 32'd1, "SLT INT_MIN<INT_MAX");

        // SLTU INT_MIN < INT_MAX (unsigned) = 0 (0x80000000 > 0x7FFFFFFF)
        inject(mk_sltu(5'd20, 5'd19, 5'd24)); drain(8);
        check_reg(5'd24, 32'd0, "SLTU INT_MIN<INT_MAX");

        // SRA on INT_MIN: arithmetic right shift preserves sign
        inject(mk_srai(5'd31, 5'd19, 5'd25)); drain(8);
        check_reg(5'd25, 32'hFFFFFFFF, "SRAI INT_MIN >>> 31");

        // SRL on INT_MIN: logical right shift inserts zero
        inject(mk_srli(5'd31, 5'd19, 5'd26)); drain(8);
        check_reg(5'd26, 32'h00000001, "SRLI INT_MIN >> 31");

        // SLL by 31
        inject(mk_slli(5'd31, 5'd8, 5'd27)); drain(8);  // 1 << 31
        check_reg(5'd27, 32'h80000000, "SLLI 1<<31");

        // SUB with overflow
        inject(mk_sub(5'd20, 5'd19, 5'd28)); drain(8);  // INT_MIN - INT_MAX
        check_reg(5'd28, 32'h00000001, "SUB INT_MIN-INT_MAX");

        // =====================================================================
        // PHASE I: multiply edge cases
        // =====================================================================
        $display("--- Phase I: multiply edge cases ---");

        // INT_MIN * -1 = INT_MIN (overflow, low) and 0 (high signed)
        inject(mk_addi(12'hFFF, 5'd0, 5'd29)); drain(8);  // x29 = -1
        inject(mk_mul(5'd29, 5'd19, 5'd30)); drain(8);    // INT_MIN * -1 low
        check_reg(5'd30, 32'h80000000, "MUL INT_MIN*-1 low");

        inject(mk_mulh(5'd29, 5'd19, 5'd31)); drain(8);   // INT_MIN * -1 high signed
        check_reg(5'd31, 32'h00000000, "MULH INT_MIN*-1 high");

        // -1 * -1 = 1
        inject(mk_mul(5'd29, 5'd29, 5'd17)); drain(8);
        check_reg(5'd17, 32'd1, "MUL -1*-1");

        // MULHU -1 * -1 = high(0xFFFFFFFE00000001) = 0xFFFFFFFE
        inject(mk_mulhu(5'd29, 5'd29, 5'd18)); drain(8);
        check_reg(5'd18, 32'hFFFFFFFE, "MULHU -1*-1");

        // MULH -1 * -1 = high signed = 0
        inject(mk_mulh(5'd29, 5'd29, 5'd20)); drain(8);
        check_reg(5'd20, 32'd0, "MULH -1*-1");

        // MUL 0 * anything = 0
        inject(mk_mul(5'd1, 5'd0, 5'd21)); drain(8);
        check_reg(5'd21, 32'd0, "MUL 0*x1");

        // =====================================================================
        // PHASE J: summary
        // =====================================================================
        $display("");
        $display("=== Summary: %0d passed, %0d failed ===", passed, failed);
        if (failed == 0)
            $display("ALL TESTS PASSED");
        else
            $display("SOME TESTS FAILED");
        $finish;
    end

    initial begin
        #200000;
        $display("TIMEOUT");
        $finish;
    end

endmodule