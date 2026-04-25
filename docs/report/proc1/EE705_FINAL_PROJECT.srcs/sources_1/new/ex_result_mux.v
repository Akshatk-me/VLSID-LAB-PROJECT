`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 07:48:19 AM
// Design Name: 
// Module Name: ex_result_mux
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
// ex_result_mux.v
// EX stage result mux. Selects what value flows into EX/MEM1.ex_result
// based on the ex_result_src control signal from the control unit.
//
// Encoding:
//   000 = alu_out      (R-type, I-type ALU, SLT/SLTU, AUIPC, loads/stores addr)
//   001 = imm          (LUI)
//   010 = csr_read     (CSRRW/S/C: rd <- old CSR value)
//   011 = pc_plus_4    (JAL/JALR link value)
//   100 = mul_low      (MUL)
//   101 = mul_high     (MULH/MULHU/MULHSU)
//   others reserved -> default to alu_out
// =============================================================================

module ex_result_mux (
    input  wire [2:0]  sel,
    input  wire [31:0] alu_out,
    input  wire [31:0] imm,
    input  wire [31:0] csr_read,
    input  wire [31:0] pc_plus_4,
    input  wire [31:0] mul_low,
    input  wire [31:0] mul_high,
    output reg  [31:0] ex_result
);

    always @(*) begin
        case (sel)
            3'b000: ex_result = alu_out;
            3'b001: ex_result = imm;
            3'b010: ex_result = csr_read;
            3'b011: ex_result = pc_plus_4;
            3'b100: ex_result = mul_low;
            3'b101: ex_result = mul_high;
            default: ex_result = alu_out;
        endcase
    end

endmodule