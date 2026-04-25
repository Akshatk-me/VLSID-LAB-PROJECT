`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2026 12:43:42 AM
// Design Name: 
// Module Name: mem3_wb_reg
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
// mem3_wb_reg.v
// MEM3/WB pipeline register.
// MEM3 has resolved the final writeback value (ex_result or aligned load data).
// Carries: write_data, rd_addr, pc, reg_write, valid
// Priority: rst > flush > stall > normal
// =============================================================================

module mem3_wb_reg (
    input  wire        clk,
    input  wire        rst,
    input  wire        stall,
    input  wire        flush,

    input  wire [31:0] write_data_in,
    input  wire [4:0]  rd_addr_in,
    input  wire [31:0] pc_in,
    input  wire        reg_write_in,

    output reg  [31:0] write_data_out,
    output reg  [4:0]  rd_addr_out,
    output reg  [31:0] pc_out,
    output reg         reg_write_out,
    output reg         valid_out
);

    always @(posedge clk) begin
        if (rst || flush) begin
            write_data_out <= 32'b0;
            rd_addr_out    <= 5'b0;
            pc_out         <= 32'b0;
            reg_write_out  <= 1'b0;
            valid_out      <= 1'b0;
        end else if (stall) begin
            write_data_out <= write_data_out;
            rd_addr_out    <= rd_addr_out;
            pc_out         <= pc_out;
            reg_write_out  <= reg_write_out;
            valid_out      <= valid_out;
        end else begin
            write_data_out <= write_data_in;
            rd_addr_out    <= rd_addr_in;
            pc_out         <= pc_in;
            reg_write_out  <= reg_write_in;
            valid_out      <= 1'b1;
        end
    end

endmodule