`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 11:51:42 PM
// Design Name: 
// Module Name: csr_minstret
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
// csr_minstret.v
// minstret CSR (machine instructions retired counter).
// CSR address 0xB02.
//
// Behavior:
//   - Increments by 1 every cycle that a valid instruction commits at WB
//     (commit_valid input asserted).
//   - Software writes via the CSR write port take priority over auto-increment.
//   - Synchronous reset clears to 0.
//
// 32-bit only. minstreth is not implemented.
// =============================================================================

module csr_minstret (
    input  wire        clk,
    input  wire        rst,

    // Commit indicator from MEM3/WB stage (asserted when a real instruction
    // retires this cycle, not a bubble)
    input  wire        commit_valid,

    // CSR write port (from CSR instruction in EX)
    input  wire        wen,
    input  wire [31:0] wdata,

    // CSR read port (combinational)
    output wire [31:0] rdata
);

    reg [31:0] minstret;

    always @(posedge clk) begin
        if (rst) begin
            minstret <= 32'b0;
        end else if (wen) begin
            minstret <= wdata;                  // software write wins
        end else if (commit_valid) begin
            minstret <= minstret + 32'd1;       // count retired instruction
        end
        // else: hold value (no commit, no software write)
    end

    assign rdata = minstret;

endmodule