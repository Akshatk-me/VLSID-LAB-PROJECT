`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 11:22:54 PM
// Design Name: 
// Module Name: csr_mcycle
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
// csr_mcycle.v
// mcycle CSR (machine cycle counter).
// CSR address 0xB00.
//
// Behavior:
//   - Increments by 1 every clock cycle (free-running).
//   - Software writes via the CSR write port take priority over auto-increment.
//   - Synchronous reset clears to 0.
//
// 32-bit only. mcycleh (upper 32 bits) is not implemented.
// =============================================================================

module csr_mcycle (
    input  wire        clk,
    input  wire        rst,

    // CSR write port (from CSR instruction in EX)
    input  wire        wen,
    input  wire [31:0] wdata,

    // CSR read port (combinational)
    output wire [31:0] rdata
);

    reg [31:0] mcycle;

    always @(posedge clk) begin
        if (rst) begin
            mcycle <= 32'b0;
        end else if (wen) begin
            mcycle <= wdata;          // software write wins
        end else begin
            mcycle <= mcycle + 32'd1; // auto-increment
        end
    end

    assign rdata = mcycle;

endmodule