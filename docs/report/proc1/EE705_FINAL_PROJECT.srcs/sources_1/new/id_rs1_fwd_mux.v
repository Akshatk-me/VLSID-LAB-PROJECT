`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 04:08:25 AM
// Design Name: 
// Module Name: id_rs1_fwd_mux
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
// id_rs1_fwd_mux.v
// ID-stage forwarding mux for rs1.
// Selects between the register file's combinational rs1 output and a
// forwarded value from MEM3/WB. Driven by the forwarding unit.
//
// sel encoding:
//   0 = regfile_rs1
//   1 = mem3wb_fwd
// =============================================================================

module id_rs1_fwd_mux (
    input  wire        sel,
    input  wire [31:0] regfile_rs1,
    input  wire [31:0] mem3wb_fwd,
    output reg  [31:0] rs1_data
);

    always @(*) begin
        case (sel)
            1'b0: rs1_data = regfile_rs1;
            1'b1: rs1_data = mem3wb_fwd;
            default: rs1_data = regfile_rs1;
        endcase
    end

endmodule