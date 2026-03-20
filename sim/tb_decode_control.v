`timescale 1ns / 1ps

module tb_decode_control;

    reg [31:0] instr;
    
    // Decoder outputs
    wire [6:0] opcode;
    wire [4:0] rd, rs1, rs2;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [31:0] imm_ext;
    
    // Control Unit outputs
    wire RegWrite, MemRead, MemWrite, ALUSrc, Branch, Jump, MulEn;
    wire [1:0] ResultSrc, ALUOp;

    // Instantiate Decoder
    instruction_decoder decoder_inst (
        .instr(instr), .opcode(opcode), .rd(rd), .funct3(funct3), 
        .rs1(rs1), .rs2(rs2), .funct7(funct7), .imm_ext(imm_ext)
    );

    // Instantiate Control Unit
    control_unit control_inst (
        .opcode(opcode), .funct7(funct7),
        .RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite),
        .ALUSrc(ALUSrc), .ResultSrc(ResultSrc), .Branch(Branch),
        .Jump(Jump), .ALUOp(ALUOp), .MulEn(MulEn)
    );

    initial begin
        $display("--- Starting Decode & Control Unit Test ---");

        // TEST 1: ADD x5, x1, x2 (Standard R-Type)
        // Opcode: 0110011, rd: 00101(5), funct3: 000, rs1: 00001(1), rs2: 00010(2), funct7: 0000000
        instr = 32'b0000000_00010_00001_000_00101_0110011; #10;
        if (RegWrite == 1 && ALUSrc == 0 && MulEn == 0 && ALUOp == 2'b10)
            $display("PASS: ADD instruction decoded correctly.");
        else $display("FAIL: ADD instruction control signals wrong.");

        // TEST 2: MUL x6, x3, x4 (M-Extension)
        // Opcode: 0110011, rd: 00110(6), funct3: 000, rs1: 00011(3), rs2: 00100(4), funct7: 0000001
        instr = 32'b0000001_00100_00011_000_00110_0110011; #10;
        if (RegWrite == 1 && MulEn == 1 && ALUOp == 2'b00)
            $display("PASS: MUL instruction triggered Multiplier Enable.");
        else $display("FAIL: MUL instruction failed to trigger Multiplier.");

        // TEST 3: LW x7, 16(x8) (I-Type Load)
        // Opcode: 0000011, rd: 00111(7), funct3: 010, rs1: 01000(8), imm: 16 (0x010)
        instr = 32'b000000010000_01000_010_00111_0000011; #10;
        if (RegWrite == 1 && MemRead == 1 && ALUSrc == 1 && imm_ext == 32'd16)
            $display("PASS: LW instruction decoded. ImmGen extracted exactly 16.");
        else $display("FAIL: LW instruction failed.");

        $display("--- Testbench Complete ---");
        $stop;
    end
endmodule
