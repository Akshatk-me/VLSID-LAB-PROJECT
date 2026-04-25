`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2026 04:34:12 AM
// Design Name: 
// Module Name: regfile
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
// regfile.v
// 32 x 32-bit register file for RV32IM.
// - 2 combinational read ports
// - 1 synchronous write port (posedge clk)
// - x0 hardwired to zero (reads return 0, writes silently discarded)
// - Synchronous active-high reset clears all registers
//
// Note: same-cycle WB->ID reads return the OLD value. The forwarding unit
// is responsible for bypassing WB data back to ID when needed.
// =============================================================================

module regfile (
    input  wire        clk,
    input  wire        rst,

    // Read port 1 (combinational)
    input  wire [4:0]  rs1_addr,
    output wire [31:0] rs1_data,

    // Read port 2 (combinational)
    input  wire [4:0]  rs2_addr,
    output wire [31:0] rs2_data,

    // Write port (synchronous)
    input  wire        wen,
    input  wire [4:0]  rd_addr,
    input  wire [31:0] rd_data
);

    // 32 general-purpose registers.
    // regs[0] is never written (write gated) and never read
    // (read ports force 0 on addr 0), so it's effectively unused storage.
    reg [31:0] regs [0:31];

    integer i;

    // -------------------------------------------------------------------------
    // Combinational reads.
    // x0 always reads as 0 regardless of what's in regs[0].
    // -------------------------------------------------------------------------
    assign rs1_data = (rs1_addr == 5'd0) ? 32'b0 : regs[rs1_addr];
    assign rs2_data = (rs2_addr == 5'd0) ? 32'b0 : regs[rs2_addr];

    // -------------------------------------------------------------------------
    // Synchronous write on posedge.
    // - Reset clears all 32 registers (including regs[0], harmless).
    // - Writes to x0 are silently discarded even if wen is asserted.
    // -------------------------------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end else begin
            if (wen && (rd_addr != 5'd0))
                regs[rd_addr] <= rd_data;
        end
    end

endmodule