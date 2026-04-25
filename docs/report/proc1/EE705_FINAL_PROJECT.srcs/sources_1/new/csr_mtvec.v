`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2026 01:22:57 AM
// Design Name: 
// Module Name: csr_mtvec
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
// csr_mtvec.v
// mtvec CSR (machine trap-vector base address).
// CSR address 0x305.
//
// Behavior:
//   - Software writes via CSR write port.
//   - Read by CSR instructions AND by the trap logic for PC redirect on trap.
//   - Synchronous reset clears to 0.
//
// Note: low 2 bits of mtvec encode mode (00=direct, 01=vectored) per the
// RISC-V spec. For this minimal implementation, software can write whatever
// it wants; the trap logic will interpret the low bits however it chooses.
// We don't mask or special-case here.
// =============================================================================

module csr_mtvec (
    input  wire        clk,
    input  wire        rst,

    // CSR write port
    input  wire        wen,
    input  wire [31:0] wdata,

    // CSR read port (combinational, used by both CSR instructions and trap PC logic)
    output wire [31:0] rdata
);

    reg [31:0] mtvec;

    always @(posedge clk) begin
        if (rst) begin
            mtvec <= 32'b0;
        end else if (wen) begin
            mtvec <= wdata;
        end
    end

    assign rdata = mtvec;

endmodule