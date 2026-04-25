`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2026 01:04:14 AM
// Design Name: 
// Module Name: csr_mstatus
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
// csr_mstatus.v
// mstatus CSR (machine status register) - minimal embedded version.
// CSR address 0x300.
//
// Fields implemented:
//   MIE  (bit 3)    : machine interrupt enable
//   MPIE (bit 7)    : previous MIE (saved on trap, restored on MRET)
//   MPP  (bits 12:11): previous privilege - hardwired to 2'b11 (M-mode only)
// All other bits read as 0 and ignore writes.
//
// Update priority:
//   trap_entry > mret > csr_write > hold
//
// trap_entry: MIE <- 0, MPIE <- MIE (save old MIE)
// mret:       MIE <- MPIE, MPIE <- 1
// csr_write:  MIE  <- wdata[3], MPIE <- wdata[7]
// =============================================================================

module csr_mstatus (
    input  wire        clk,
    input  wire        rst,

    // Hardware trap/mret signals
    input  wire        trap_entry,   // 1 = trap taken this cycle
    input  wire        mret,         // 1 = MRET committing this cycle

    // CSR write port (from CSR instruction in EX)
    input  wire        wen,
    input  wire [31:0] wdata,

    // CSR read port (combinational)
    output wire [31:0] rdata
);

    // Stored state
    reg mie_r;
    reg mpie_r;

    always @(posedge clk) begin
        if (rst) begin
            mie_r  <= 1'b0;
            mpie_r <= 1'b0;
        end else if (trap_entry) begin
            mpie_r <= mie_r;   // save current MIE into MPIE
            mie_r  <= 1'b0;    // disable interrupts on trap entry
        end else if (mret) begin
            mie_r  <= mpie_r;  // restore MIE from MPIE
            mpie_r <= 1'b1;    // MPIE unconditionally set to 1
        end else if (wen) begin
            mie_r  <= wdata[3];
            mpie_r <= wdata[7];
        end
        // else: hold
    end

    // -------------------------------------------------------------------------
    // Read port: construct the 32-bit mstatus from stored bits + hardwired MPP.
    // Layout:
    //   bit 3     = MIE
    //   bit 7     = MPIE
    //   bits 12:11 = MPP = 2'b11 (hardwired, M-mode only)
    //   everything else = 0
    // -------------------------------------------------------------------------
    assign rdata = {
        19'b0,       // bits 31:13
        2'b11,       // bits 12:11: MPP hardwired to machine mode
        3'b0,        // bits 10:8
        mpie_r,      // bit 7: MPIE
        3'b0,        // bits 6:4
        mie_r,       // bit 3: MIE
        3'b0         // bits 2:0
    };

endmodule
