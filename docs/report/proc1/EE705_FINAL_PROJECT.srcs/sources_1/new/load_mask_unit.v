`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 07:48:19 AM
// Design Name: 
// Module Name: load_mask_unit
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
// load_mask_unit.v
// Aligns and sign/zero-extends raw memory read data for load instructions.
// Used in MEM3 stage.
//
// Inputs:
//   raw_data    : full 32-bit word read from memory
//   addr_low    : low 2 bits of the byte address (for byte/halfword selection)
//   ld_select   : load type (funct3 passthrough)
//                   000 LB   001 LH   010 LW
//                   100 LBU  101 LHU
//
// Output:
//   load_data   : aligned + extended 32-bit value to write back to rd
//
// Note: assumes naturally-aligned accesses per the project spec.
//   - LW   : addr_low must be 00
//   - LH   : addr_low must be 00 or 10
//   - LB   : any addr_low
// =============================================================================

module load_mask_unit (
    input  wire [31:0] raw_data,
    input  wire [1:0]  addr_low,
    input  wire [2:0]  ld_select,
    output reg  [31:0] load_data
);

    reg [7:0]  byte_sel;
    reg [15:0] half_sel;

    always @(*) begin
        // Default: pass through (used for LW)
        load_data = raw_data;
        byte_sel  = 8'b0;
        half_sel  = 16'b0;

        // Byte selection from the 32-bit word
        case (addr_low)
            2'b00: byte_sel = raw_data[7:0];
            2'b01: byte_sel = raw_data[15:8];
            2'b10: byte_sel = raw_data[23:16];
            2'b11: byte_sel = raw_data[31:24];
        endcase

        // Halfword selection (only addr_low[1] matters; addr_low[0] should be 0)
        case (addr_low[1])
            1'b0: half_sel = raw_data[15:0];
            1'b1: half_sel = raw_data[31:16];
        endcase

        // Final selection + extension based on ld_select
        case (ld_select)
            3'b000: load_data = {{24{byte_sel[7]}}, byte_sel};   // LB  (sign-ext)
            3'b001: load_data = {{16{half_sel[15]}}, half_sel};  // LH  (sign-ext)
            3'b010: load_data = raw_data;                        // LW
            3'b100: load_data = {24'b0, byte_sel};               // LBU (zero-ext)
            3'b101: load_data = {16'b0, half_sel};               // LHU (zero-ext)
            default: load_data = raw_data;
        endcase
    end

endmodule