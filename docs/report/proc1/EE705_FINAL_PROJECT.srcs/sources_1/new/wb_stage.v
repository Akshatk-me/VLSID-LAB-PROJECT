`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 01:19:57 PM
// Design Name: 
// Module Name: wb_stage
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
// wb_stage.v
// Writeback-stage submodule.
// Contains: mem3_wb_reg
//
// Inputs:
//   - clk, rst, stall, flush
//   - wb_in_*  from mem_stage (MEM3 stage outputs)
//
// Outputs:
//   - Writeback bus (to regfile + ID-stage forwarding):
//       wb_rd_data, wb_rd_addr, wb_reg_write, wb_valid, wb_pc
//   - Forwarding source for EX-stage muxes: mem3_wb_fwd
//   - Producer info for forwarding unit: mem3_wb_rd_addr, mem3_wb_reg_write
// =============================================================================

module wb_stage (
    input  wire        clk,
    input  wire        rst,
    input  wire        stall,
    input  wire        flush,

    // From mem_stage
    input  wire [31:0] wb_in_write_data,
    input  wire [4:0]  wb_in_rd_addr,
    input  wire [31:0] wb_in_pc,
    input  wire        wb_in_reg_write,

    // ----- Writeback bus -----
    output wire [31:0] wb_rd_data,
    output wire [4:0]  wb_rd_addr,
    output wire [31:0] wb_pc,
    output wire        wb_reg_write,
    output wire        wb_valid,

    // ----- Forwarding source -----
    output wire [31:0] mem3_wb_fwd,

    // ----- Producer info for forwarding unit -----
    output wire [4:0]  mem3_wb_rd_addr,
    output wire        mem3_wb_reg_write
);

    wire [31:0] m3wb_write_data;
    wire [4:0]  m3wb_rd_addr;
    wire [31:0] m3wb_pc;
    wire        m3wb_reg_write;
    wire        m3wb_valid;

    mem3_wb_reg u_mem3_wb_reg (
        .clk            (clk),
        .rst            (rst),
        .stall          (stall),
        .flush          (flush),

        .write_data_in  (wb_in_write_data),
        .rd_addr_in     (wb_in_rd_addr),
        .pc_in          (wb_in_pc),
        .reg_write_in   (wb_in_reg_write),

        .write_data_out (m3wb_write_data),
        .rd_addr_out    (m3wb_rd_addr),
        .pc_out         (m3wb_pc),
        .reg_write_out  (m3wb_reg_write),
        .valid_out      (m3wb_valid)
    );

    // Writeback bus
    assign wb_rd_data    = m3wb_write_data;
    assign wb_rd_addr    = m3wb_rd_addr;
    assign wb_pc         = m3wb_pc;
    assign wb_reg_write  = m3wb_reg_write;
    assign wb_valid      = m3wb_valid;

    // Forwarding source
    assign mem3_wb_fwd   = m3wb_write_data;

    // Producer info
    assign mem3_wb_rd_addr   = m3wb_rd_addr;
    assign mem3_wb_reg_write = m3wb_reg_write;

endmodule
