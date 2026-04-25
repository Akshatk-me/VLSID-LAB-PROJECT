`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2026 01:23:23 AM
// Design Name: 
// Module Name: csr_mepc
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
// csr_mepc.v
// mepc CSR (machine exception program counter).
// CSR address 0x341.
//
// Behavior:
//   - Hardware-written on trap entry (captures the PC of the faulting or
//     interrupted instruction).
//   - Software-writable via CSR write port (e.g., during trap handler setup).
//   - Read by CSR instructions AND by hardware for MRET PC redirect.
//   - Synchronous reset clears to 0.
//
// Priority on write conflict:
//   trap_entry > csr_write > hold
// =============================================================================

module csr_mepc (
    input  wire        clk,
    input  wire        rst,

    // Hardware trap capture
    input  wire        trap_entry,    // 1 = trap taken this cycle
    input  wire [31:0] trap_pc,       // PC to save (the faulting instruction's PC)

    // CSR write port (software)
    input  wire        wen,
    input  wire [31:0] wdata,

    // CSR read port (combinational)
    output wire [31:0] rdata
);

    reg [31:0] mepc;

    always @(posedge clk) begin
        if (rst) begin
            mepc <= 32'b0;
        end else if (trap_entry) begin
            mepc <= trap_pc;    // hardware capture wins
        end else if (wen) begin
            mepc <= wdata;      // software write
        end
        // else: hold
    end

    assign rdata = mepc;

endmodule
