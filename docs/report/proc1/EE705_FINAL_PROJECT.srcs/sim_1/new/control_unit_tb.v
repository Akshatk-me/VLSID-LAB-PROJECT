`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2026 07:58:41 AM
// Design Name: 
// Module Name: control_unit_tb
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
// control_unit_tb.v
// Testbench for control_unit.
// Drives opcode/funct3/funct7 for representative instructions and checks
// that the generated control signals match expected values.
//
// Control signal encodings (for reference):
//
//   alu_src_a (1):  0=rs1_data           1=PC
//
//   alu_src_b (2):  00=rs2_data          01=imm           10=csr_read
//
//   alu_op (4):     0000 ADD     0001 SUB     0010 AND     0011 OR
//                   0100 XOR     0101 SLL     0110 SRL     0111 SRA
//                   1000 SLT     1001 SLTU    1010 ANDN    (others reserved)
//
//   is_branch (1):  1 = branch instruction
//   branch_type(3): funct3 passthrough (BEQ=000, BNE=001, BLT=100, BGE=101,
//                                       BLTU=110, BGEU=111)
//
//   is_jump (1):    1 = JAL or JALR
//
//   csr_op (2):     00=none  01=CSRRW  10=CSRRS  11=CSRRC
//   csr_wdata_src(1): 0=rs1_data direct to CSR     1=alu_out to CSR
//   is_mret (1):    1 = MRET
//
//   mul_op (2):     00=not a mul   01=signed*signed   10=unsigned*signed
//                   11=unsigned*unsigned
//
//   ex_result_src(3): 000=alu_out  001=imm     010=csr_read  011=pc_plus_4
//                     100=mul_low  101=mul_high
//
//   mem_read (1), mem_write (1)
//   wen (4):  0001=SB   0011=SH   1111=SW   0000=no write
//   ld_select (3): funct3 passthrough (LB=000, LH=001, LW=010,
//                                      LBU=100, LHU=101)
//
//   reg_write (1): 1 = write rd in WB
//
// =============================================================================

`timescale 1ns/1ps

module control_unit_tb;

    reg  [6:0] opcode;
    reg  [2:0] funct3;
    reg  [6:0] funct7;

    wire        alu_src_a;
    wire [1:0]  alu_src_b;
    wire [3:0]  alu_op;
    wire        is_branch;
    wire [2:0]  branch_type;
    wire        is_jump;
    wire [1:0]  csr_op;
    wire        csr_wdata_src;
    wire        is_mret;
    wire [1:0]  mul_op;
    wire [2:0]  ex_result_src;
    wire        mem_read;
    wire        mem_write;
    wire [3:0]  wen;
    wire [2:0]  ld_select;
    wire        reg_write;

    integer passed = 0;
    integer failed = 0;

    control_unit dut (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .alu_src_a(alu_src_a),
        .alu_src_b(alu_src_b),
        .alu_op(alu_op),
        .is_branch(is_branch),
        .branch_type(branch_type),
        .is_jump(is_jump),
        .csr_op(csr_op),
        .csr_wdata_src(csr_wdata_src),
        .is_mret(is_mret),
        .mul_op(mul_op),
        .ex_result_src(ex_result_src),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .wen(wen),
        .ld_select(ld_select),
        .reg_write(reg_write)
    );

    // -------------------------------------------------------------------------
    // check_all task: drives instruction fields and verifies all 16 outputs
    // -------------------------------------------------------------------------
    task check_all;
        input [255:0] name;
        input [6:0]   op;
        input [2:0]   f3;
        input [6:0]   f7;
        // expected outputs
        input         e_alu_src_a;
        input [1:0]   e_alu_src_b;
        input [3:0]   e_alu_op;
        input         e_is_branch;
        input [2:0]   e_branch_type;
        input         e_is_jump;
        input [1:0]   e_csr_op;
        input         e_csr_wdata_src;
        input         e_is_mret;
        input [1:0]   e_mul_op;
        input [2:0]   e_ex_result_src;
        input         e_mem_read;
        input         e_mem_write;
        input [3:0]   e_wen;
        input [2:0]   e_ld_select;
        input         e_reg_write;
        begin
            opcode = op;
            funct3 = f3;
            funct7 = f7;
            #1;
            if (alu_src_a     === e_alu_src_a     &&
                alu_src_b     === e_alu_src_b     &&
                alu_op        === e_alu_op        &&
                is_branch     === e_is_branch     &&
                branch_type   === e_branch_type   &&
                is_jump       === e_is_jump       &&
                csr_op        === e_csr_op        &&
                csr_wdata_src === e_csr_wdata_src &&
                is_mret       === e_is_mret       &&
                mul_op        === e_mul_op        &&
                ex_result_src === e_ex_result_src &&
                mem_read      === e_mem_read      &&
                mem_write     === e_mem_write    &&
                wen           === e_wen           &&
                ld_select     === e_ld_select     &&
                reg_write     === e_reg_write) begin
                $display("PASS: %0s", name);
                passed = passed + 1;
            end else begin
                $display("FAIL: %0s", name);
                $display("  alu_src_a    : got=%b exp=%b", alu_src_a,     e_alu_src_a);
                $display("  alu_src_b    : got=%b exp=%b", alu_src_b,     e_alu_src_b);
                $display("  alu_op       : got=%b exp=%b", alu_op,        e_alu_op);
                $display("  is_branch    : got=%b exp=%b", is_branch,     e_is_branch);
                $display("  branch_type  : got=%b exp=%b", branch_type,   e_branch_type);
                $display("  is_jump      : got=%b exp=%b", is_jump,       e_is_jump);
                $display("  csr_op       : got=%b exp=%b", csr_op,        e_csr_op);
                $display("  csr_wdata_src: got=%b exp=%b", csr_wdata_src, e_csr_wdata_src);
                $display("  is_mret      : got=%b exp=%b", is_mret,       e_is_mret);
                $display("  mul_op       : got=%b exp=%b", mul_op,        e_mul_op);
                $display("  ex_result_src: got=%b exp=%b", ex_result_src, e_ex_result_src);
                $display("  mem_read     : got=%b exp=%b", mem_read,      e_mem_read);
                $display("  mem_write    : got=%b exp=%b", mem_write,     e_mem_write);
                $display("  wen          : got=%b exp=%b", wen,           e_wen);
                $display("  ld_select    : got=%b exp=%b", ld_select,     e_ld_select);
                $display("  reg_write    : got=%b exp=%b", reg_write,     e_reg_write);
                failed = failed + 1;
            end
        end
    endtask

    initial begin
        $display("=== control_unit testbench ===");

        // ---------------------------------------------------------------------
        // R-type ALU
        // op=0110011  reg_write=1  alu_src_a=0(rs1)  alu_src_b=00(rs2)
        // ex_result_src=000(alu)
        // ---------------------------------------------------------------------
        // ADD: f3=000 f7=0000000
        check_all("ADD",
            7'b0110011, 3'b000, 7'b0000000,
            1'b0, 2'b00, 4'b0000, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // SUB: f3=000 f7=0100000
        check_all("SUB",
            7'b0110011, 3'b000, 7'b0100000,
            1'b0, 2'b00, 4'b0001, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // AND: f3=111 f7=0000000
        check_all("AND",
            7'b0110011, 3'b111, 7'b0000000,
            1'b0, 2'b00, 4'b0010, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // OR: f3=110
        check_all("OR",
            7'b0110011, 3'b110, 7'b0000000,
            1'b0, 2'b00, 4'b0011, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // XOR: f3=100
        check_all("XOR",
            7'b0110011, 3'b100, 7'b0000000,
            1'b0, 2'b00, 4'b0100, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // SLL: f3=001
        check_all("SLL",
            7'b0110011, 3'b001, 7'b0000000,
            1'b0, 2'b00, 4'b0101, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // SRL: f3=101 f7=0000000
        check_all("SRL",
            7'b0110011, 3'b101, 7'b0000000,
            1'b0, 2'b00, 4'b0110, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // SRA: f3=101 f7=0100000
        check_all("SRA",
            7'b0110011, 3'b101, 7'b0100000,
            1'b0, 2'b00, 4'b0111, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // SLT: f3=010
        check_all("SLT",
            7'b0110011, 3'b010, 7'b0000000,
            1'b0, 2'b00, 4'b1000, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // SLTU: f3=011
        check_all("SLTU",
            7'b0110011, 3'b011, 7'b0000000,
            1'b0, 2'b00, 4'b1001, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // ---------------------------------------------------------------------
        // M-extension multiplies (op=0110011, f7=0000001)
        // alu_op irrelevant (still 0000=ADD by default), mul_op selects variant
        // ex_result_src selects mul_low or mul_high
        // ---------------------------------------------------------------------
        // MUL: f3=000 -> mul_op=01 (SxS), result=mul_low
        check_all("MUL",
            7'b0110011, 3'b000, 7'b0000001,
            1'b0, 2'b00, 4'b0000, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b01, 3'b100,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // MULH: f3=001 -> mul_op=01 (SxS), result=mul_high
        check_all("MULH",
            7'b0110011, 3'b001, 7'b0000001,
            1'b0, 2'b00, 4'b0000, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b01, 3'b101,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // MULHSU: f3=010 -> mul_op=10 (UxS), result=mul_high
        check_all("MULHSU",
            7'b0110011, 3'b010, 7'b0000001,
            1'b0, 2'b00, 4'b0000, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b10, 3'b101,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // MULHU: f3=011 -> mul_op=11 (UxU), result=mul_high
        check_all("MULHU",
            7'b0110011, 3'b011, 7'b0000001,
            1'b0, 2'b00, 4'b0000, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b11, 3'b101,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // ---------------------------------------------------------------------
        // I-type ALU (op=0010011)
        // alu_src_a=0(rs1) alu_src_b=01(imm) reg_write=1 ex_result_src=000(alu)
        // ---------------------------------------------------------------------
        // ADDI
        check_all("ADDI",
            7'b0010011, 3'b000, 7'b0000000,
            1'b0, 2'b01, 4'b0000, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // SLTI
        check_all("SLTI",
            7'b0010011, 3'b010, 7'b0000000,
            1'b0, 2'b01, 4'b1000, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // SLTIU
        check_all("SLTIU",
            7'b0010011, 3'b011, 7'b0000000,
            1'b0, 2'b01, 4'b1001, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // XORI
        check_all("XORI",
            7'b0010011, 3'b100, 7'b0000000,
            1'b0, 2'b01, 4'b0100, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // ORI
        check_all("ORI",
            7'b0010011, 3'b110, 7'b0000000,
            1'b0, 2'b01, 4'b0011, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // ANDI
        check_all("ANDI",
            7'b0010011, 3'b111, 7'b0000000,
            1'b0, 2'b01, 4'b0010, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // SLLI: f3=001 f7=0000000
        check_all("SLLI",
            7'b0010011, 3'b001, 7'b0000000,
            1'b0, 2'b01, 4'b0101, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // SRLI: f3=101 f7=0000000
        check_all("SRLI",
            7'b0010011, 3'b101, 7'b0000000,
            1'b0, 2'b01, 4'b0110, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // SRAI: f3=101 f7=0100000
        check_all("SRAI",
            7'b0010011, 3'b101, 7'b0100000,
            1'b0, 2'b01, 4'b0111, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // ---------------------------------------------------------------------
        // Loads (op=0000011)
        // alu_src_a=0 alu_src_b=01(imm) alu_op=ADD mem_read=1 reg_write=1
        // ld_select = funct3
        // ---------------------------------------------------------------------
        // LB
        check_all("LB",
            7'b0000011, 3'b000, 7'b0000000,
            1'b0, 2'b01, 4'b0000, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b1, 1'b0, 4'b0000, 3'b000, 1'b1);

        // LH
        check_all("LH",
            7'b0000011, 3'b001, 7'b0000000,
            1'b0, 2'b01, 4'b0000, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b1, 1'b0, 4'b0000, 3'b001, 1'b1);

        // LW
        check_all("LW",
            7'b0000011, 3'b010, 7'b0000000,
            1'b0, 2'b01, 4'b0000, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b1, 1'b0, 4'b0000, 3'b010, 1'b1);

        // LBU
        check_all("LBU",
            7'b0000011, 3'b100, 7'b0000000,
            1'b0, 2'b01, 4'b0000, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b1, 1'b0, 4'b0000, 3'b100, 1'b1);

        // LHU
        check_all("LHU",
            7'b0000011, 3'b101, 7'b0000000,
            1'b0, 2'b01, 4'b0000, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b1, 1'b0, 4'b0000, 3'b101, 1'b1);

        // ---------------------------------------------------------------------
        // Stores (op=0100011)
        // alu_src_a=0 alu_src_b=01(imm) alu_op=ADD mem_write=1 reg_write=0
        // wen depends on funct3
        // ---------------------------------------------------------------------
        // SB
        check_all("SB",
            7'b0100011, 3'b000, 7'b0000000,
            1'b0, 2'b01, 4'b0000, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b1, 4'b0001, 3'b000, 1'b0);

        // SH
        check_all("SH",
            7'b0100011, 3'b001, 7'b0000000,
            1'b0, 2'b01, 4'b0000, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b1, 4'b0011, 3'b000, 1'b0);

        // SW
        check_all("SW",
            7'b0100011, 3'b010, 7'b0000000,
            1'b0, 2'b01, 4'b0000, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b1, 4'b1111, 3'b000, 1'b0);

        // ---------------------------------------------------------------------
        // Branches (op=1100011)
        // alu_src_a=0 alu_src_b=00(rs2) alu_op=SUB is_branch=1 reg_write=0
        // branch_type = funct3
        // ---------------------------------------------------------------------
        // BEQ
        check_all("BEQ",
            7'b1100011, 3'b000, 7'b0000000,
            1'b0, 2'b00, 4'b0001, 1'b1, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b0);

        // BNE
        check_all("BNE",
            7'b1100011, 3'b001, 7'b0000000,
            1'b0, 2'b00, 4'b0001, 1'b1, 3'b001, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b0);

        // BLT
        check_all("BLT",
            7'b1100011, 3'b100, 7'b0000000,
            1'b0, 2'b00, 4'b0001, 1'b1, 3'b100, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b0);

        // BGE
        check_all("BGE",
            7'b1100011, 3'b101, 7'b0000000,
            1'b0, 2'b00, 4'b0001, 1'b1, 3'b101, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b0);

        // BLTU
        check_all("BLTU",
            7'b1100011, 3'b110, 7'b0000000,
            1'b0, 2'b00, 4'b0001, 1'b1, 3'b110, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b0);

        // BGEU
        check_all("BGEU",
            7'b1100011, 3'b111, 7'b0000000,
            1'b0, 2'b00, 4'b0001, 1'b1, 3'b111, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b0);

        // ---------------------------------------------------------------------
        // JAL (op=1101111)
        // alu_src_a=1(PC) alu_src_b=01(imm) alu_op=ADD is_jump=1 reg_write=1
        // ex_result_src=011(pc_plus_4)
        // ---------------------------------------------------------------------
        check_all("JAL",
            7'b1101111, 3'b000, 7'b0000000,
            1'b1, 2'b01, 4'b0000, 1'b0, 3'b000, 1'b1,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b011,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // ---------------------------------------------------------------------
        // JALR (op=1100111)
        // alu_src_a=0(rs1) alu_src_b=01(imm) alu_op=ADD is_jump=1 reg_write=1
        // ex_result_src=011(pc_plus_4)
        // ---------------------------------------------------------------------
        check_all("JALR",
            7'b1100111, 3'b000, 7'b0000000,
            1'b0, 2'b01, 4'b0000, 1'b0, 3'b000, 1'b1,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b011,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // ---------------------------------------------------------------------
        // LUI (op=0110111): rd <- imm directly
        // ex_result_src=001(imm) reg_write=1
        // ---------------------------------------------------------------------
        check_all("LUI",
            7'b0110111, 3'b000, 7'b0000000,
            1'b0, 2'b00, 4'b0000, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b001,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // ---------------------------------------------------------------------
        // AUIPC (op=0010111): rd <- PC + imm
        // alu_src_a=1(PC) alu_src_b=01(imm) alu_op=ADD ex_result_src=000(alu)
        // ---------------------------------------------------------------------
        check_all("AUIPC",
            7'b0010111, 3'b000, 7'b0000000,
            1'b1, 2'b01, 4'b0000, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // ---------------------------------------------------------------------
        // SYSTEM: CSR instructions and MRET (op=1110011)
        // ---------------------------------------------------------------------
        // CSRRW (f3=001): csr_op=01, csr_wdata_src=0(rs1 direct), rd<-csr_read
        check_all("CSRRW",
            7'b1110011, 3'b001, 7'b0000000,
            1'b0, 2'b00, 4'b0000, 1'b0, 3'b000, 1'b0,
            2'b01, 1'b0, 1'b0, 2'b00, 3'b010,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // CSRRS (f3=010): csr_op=10, alu_op=OR, csr_wdata_src=1(alu_out)
        // alu_src_a=0(rs1) alu_src_b=10(csr_read)
        check_all("CSRRS",
            7'b1110011, 3'b010, 7'b0000000,
            1'b0, 2'b10, 4'b0011, 1'b0, 3'b000, 1'b0,
            2'b10, 1'b1, 1'b0, 2'b00, 3'b010,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // CSRRC (f3=011): csr_op=11, alu_op=ANDN, csr_wdata_src=1(alu_out)
        check_all("CSRRC",
            7'b1110011, 3'b011, 7'b0000000,
            1'b0, 2'b10, 4'b1010, 1'b0, 3'b000, 1'b0,
            2'b11, 1'b1, 1'b0, 2'b00, 3'b010,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b1);

        // MRET (f3=000): is_mret=1, no register write, no memory access
        check_all("MRET",
            7'b1110011, 3'b000, 7'b0000000,
            1'b0, 2'b00, 4'b0000, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b1, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b0);

        // ---------------------------------------------------------------------
        // Unknown opcode -> all defaults (do nothing)
        // ---------------------------------------------------------------------
        check_all("UNKNOWN",
            7'b1111111, 3'b000, 7'b0000000,
            1'b0, 2'b00, 4'b0000, 1'b0, 3'b000, 1'b0,
            2'b00, 1'b0, 1'b0, 2'b00, 3'b000,
            1'b0, 1'b0, 4'b0000, 3'b000, 1'b0);

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
