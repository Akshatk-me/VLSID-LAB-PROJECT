`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 10:23:49 AM
// Design Name: 
// Module Name: csr_wdata_mux
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
// csr_wdata_mux.v
// CSR write-data mux. Selects what value gets written to the CSR file
// for CSR instructions.
//
// sel encoding (matches csr_wdata_src from the control unit):
//   0 = rs1_fwd  (CSRRW: CSR <- rs1 directly)
//   1 = alu_out  (CSRRS/CSRRC: CSR <- alu computed value)
//
// rs1_fwd is the forwarded rs1 value, taken from the output of ex_alu_a_mux
// (which already incorporates all forwarding paths when control selected rs1).
// =============================================================================

module csr_wdata_mux (
    input  wire        sel,
    input  wire [31:0] rs1_fwd,
    input  wire [31:0] alu_out,
    output reg  [31:0] csr_wdata
);

    always @(*) begin
        case (sel)
            1'b0: csr_wdata = rs1_fwd;
            1'b1: csr_wdata = alu_out;
            default: csr_wdata = rs1_fwd;
        endcase
    end

endmodule