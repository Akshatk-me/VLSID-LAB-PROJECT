`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2026 12:43:42 AM
// Design Name: 
// Module Name: mem2_mem3_reg
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
// mem2_mem3_reg.v
// MEM2/MEM3 pipeline register.
// Second of two waiting stages for the 2-cycle memory latency.
// Identical format to MEM1/MEM2.
// Priority: rst > flush > stall > normal
// =============================================================================

module mem2_mem3_reg (
    input  wire        clk,
    input  wire        rst,
    input  wire        stall,
    input  wire        flush,

    input  wire [31:0] pc_in,
    input  wire [31:0] ex_result_in,
    input  wire [4:0]  rd_addr_in,
    input  wire        mem_read_in,
    input  wire [2:0]  ld_select_in,
    input  wire        reg_write_in,

    output reg  [31:0] pc_out,
    output reg  [31:0] ex_result_out,
    output reg  [4:0]  rd_addr_out,
    output reg         mem_read_out,
    output reg  [2:0]  ld_select_out,
    output reg         reg_write_out,
    output reg         valid_out
);

    always @(posedge clk) begin
        if (rst || flush) begin
            pc_out        <= 32'b0;
            ex_result_out <= 32'b0;
            rd_addr_out   <= 5'b0;
            mem_read_out  <= 1'b0;
            ld_select_out <= 3'b0;
            reg_write_out <= 1'b0;
            valid_out     <= 1'b0;
        end else if (stall) begin
            pc_out        <= pc_out;
            ex_result_out <= ex_result_out;
            rd_addr_out   <= rd_addr_out;
            mem_read_out  <= mem_read_out;
            ld_select_out <= ld_select_out;
            reg_write_out <= reg_write_out;
            valid_out     <= valid_out;
        end else begin
            pc_out        <= pc_in;
            ex_result_out <= ex_result_in;
            rd_addr_out   <= rd_addr_in;
            mem_read_out  <= mem_read_in;
            ld_select_out <= ld_select_in;
            reg_write_out <= reg_write_in;
            valid_out     <= 1'b1;
        end
    end

endmodule
