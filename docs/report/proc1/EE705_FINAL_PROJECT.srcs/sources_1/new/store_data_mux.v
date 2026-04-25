`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 07:48:19 AM
// Design Name: 
// Module Name: store_data_mux
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
// store_data_mux.v
// EX-stage store data mux. Selects what value gets latched into
// EX/MEM1.store_data for store instructions.
//
// Forwarding sources are the same as ex_alu_b_mux's rs2-path forwarding,
// minus the imm and csr_read cases (which are never store data).
//
// sel encoding (matches the rs2-path codes from ex_alu_b_mux):
//   000 = rs2_data
//   010 = ex_mem1_fwd
//   011 = mem1_mem2_fwd
//   100 = mem2_mem3_fwd
//   101 = mask_unit_fwd  (load data forwarded from MEM3 mask unit)
//   110 = mem3_wb_fwd
//   others reserved -> default to rs2_data
//
// Driven by str_data_mux_sel from the forwarding unit.
// =============================================================================

module store_data_mux (
    input  wire [2:0]  sel,
    input  wire [31:0] rs2_data,
    input  wire [31:0] ex_mem1_fwd,
    input  wire [31:0] mem1_mem2_fwd,
    input  wire [31:0] mem2_mem3_fwd,
    input  wire [31:0] mask_unit_fwd,
    input  wire [31:0] mem3_wb_fwd,
    output reg  [31:0] store_data
);

    always @(*) begin
        case (sel)
            3'b000: store_data = rs2_data;
            3'b010: store_data = ex_mem1_fwd;
            3'b011: store_data = mem1_mem2_fwd;
            3'b100: store_data = mem2_mem3_fwd;
            3'b101: store_data = mask_unit_fwd;
            3'b110: store_data = mem3_wb_fwd;
            default: store_data = rs2_data;
        endcase
    end

endmodule
