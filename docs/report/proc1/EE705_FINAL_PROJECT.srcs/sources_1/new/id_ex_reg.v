`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2026 07:52:00 AM
// Design Name: 
// Module Name: id_ex_reg
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
// id_ex_reg.v
// ID/EX pipeline register.
//
// Data:    pc, pc_plus_4, imm, rs1_data, rs2_data, rs1_addr, rs2_addr, rd_addr
// EX ctrl: alu_src_a, alu_src_b, alu_op, is_branch, branch_type, is_jump,
//          csr_op, csr_wdata_src, is_mret, mul_op, ex_result_src
// MEM ctrl: mem_read, mem_write, wen, ld_select
// WB ctrl: reg_write
//
// Priority: rst > flush > stall > normal
// Flush behavior: all control signals zeroed (do-nothing bubble), data zeroed
// =============================================================================

// =============================================================================
// id_ex_reg.v
// ID/EX pipeline register.
// Carries: data fields, full EX/MEM/WB control bundle, valid bit.
// Priority: rst > flush > stall > normal
// Flush: all control zeroed (do-nothing bubble), data zeroed, valid = 0
// =============================================================================

module id_ex_reg (
    input  wire        clk,
    input  wire        rst,
    input  wire        stall,
    input  wire        flush,

    // Data inputs
    input  wire [31:0] pc_in,
    input  wire [31:0] pc_plus_4_in,
    input  wire [31:0] imm_in,
    input  wire [31:0] rs1_data_in,
    input  wire [31:0] rs2_data_in,
    input  wire [4:0]  rs1_addr_in,
    input  wire [4:0]  rs2_addr_in,
    input  wire [4:0]  rd_addr_in,

    // EX control inputs
    input  wire        alu_src_a_in,
    input  wire [1:0]  alu_src_b_in,
    input  wire [3:0]  alu_op_in,
    input  wire        is_branch_in,
    input  wire [2:0]  branch_type_in,
    input  wire        is_jump_in,
    input  wire [1:0]  csr_op_in,
    input  wire        csr_wdata_src_in,
    input  wire        is_mret_in,
    input  wire [1:0]  mul_op_in,
    input  wire [2:0]  ex_result_src_in,

    // MEM control inputs
    input  wire        mem_read_in,
    input  wire        mem_write_in,
    input  wire [3:0]  wen_in,
    input  wire [2:0]  ld_select_in,

    // WB control input
    input  wire        reg_write_in,

    // Data outputs
    output reg  [31:0] pc_out,
    output reg  [31:0] pc_plus_4_out,
    output reg  [31:0] imm_out,
    output reg  [31:0] rs1_data_out,
    output reg  [31:0] rs2_data_out,
    output reg  [4:0]  rs1_addr_out,
    output reg  [4:0]  rs2_addr_out,
    output reg  [4:0]  rd_addr_out,

    // EX control outputs
    output reg         alu_src_a_out,
    output reg  [1:0]  alu_src_b_out,
    output reg  [3:0]  alu_op_out,
    output reg         is_branch_out,
    output reg  [2:0]  branch_type_out,
    output reg         is_jump_out,
    output reg  [1:0]  csr_op_out,
    output reg         csr_wdata_src_out,
    output reg         is_mret_out,
    output reg  [1:0]  mul_op_out,
    output reg  [2:0]  ex_result_src_out,

    // MEM control outputs
    output reg         mem_read_out,
    output reg         mem_write_out,
    output reg  [3:0]  wen_out,
    output reg  [2:0]  ld_select_out,

    // WB control output
    output reg         reg_write_out,

    // Valid
    output reg         valid_out
);

    always @(posedge clk) begin
        if (rst || flush) begin
            pc_out            <= 32'b0;
            pc_plus_4_out     <= 32'b0;
            imm_out           <= 32'b0;
            rs1_data_out      <= 32'b0;
            rs2_data_out      <= 32'b0;
            rs1_addr_out      <= 5'b0;
            rs2_addr_out      <= 5'b0;
            rd_addr_out       <= 5'b0;
            alu_src_a_out     <= 1'b0;
            alu_src_b_out     <= 2'b0;
            alu_op_out        <= 4'b0;
            is_branch_out     <= 1'b0;
            branch_type_out   <= 3'b0;
            is_jump_out       <= 1'b0;
            csr_op_out        <= 2'b0;
            csr_wdata_src_out <= 1'b0;
            is_mret_out       <= 1'b0;
            mul_op_out        <= 2'b0;
            ex_result_src_out <= 3'b0;
            mem_read_out      <= 1'b0;
            mem_write_out     <= 1'b0;
            wen_out           <= 4'b0;
            ld_select_out     <= 3'b0;
            reg_write_out     <= 1'b0;
            valid_out         <= 1'b0;
        end else if (stall) begin
            pc_out            <= pc_out;
            pc_plus_4_out     <= pc_plus_4_out;
            imm_out           <= imm_out;
            rs1_data_out      <= rs1_data_out;
            rs2_data_out      <= rs2_data_out;
            rs1_addr_out      <= rs1_addr_out;
            rs2_addr_out      <= rs2_addr_out;
            rd_addr_out       <= rd_addr_out;
            alu_src_a_out     <= alu_src_a_out;
            alu_src_b_out     <= alu_src_b_out;
            alu_op_out        <= alu_op_out;
            is_branch_out     <= is_branch_out;
            branch_type_out   <= branch_type_out;
            is_jump_out       <= is_jump_out;
            csr_op_out        <= csr_op_out;
            csr_wdata_src_out <= csr_wdata_src_out;
            is_mret_out       <= is_mret_out;
            mul_op_out        <= mul_op_out;
            ex_result_src_out <= ex_result_src_out;
            mem_read_out      <= mem_read_out;
            mem_write_out     <= mem_write_out;
            wen_out           <= wen_out;
            ld_select_out     <= ld_select_out;
            reg_write_out     <= reg_write_out;
            valid_out         <= valid_out;
        end else begin
            pc_out            <= pc_in;
            pc_plus_4_out     <= pc_plus_4_in;
            imm_out           <= imm_in;
            rs1_data_out      <= rs1_data_in;
            rs2_data_out      <= rs2_data_in;
            rs1_addr_out      <= rs1_addr_in;
            rs2_addr_out      <= rs2_addr_in;
            rd_addr_out       <= rd_addr_in;
            alu_src_a_out     <= alu_src_a_in;
            alu_src_b_out     <= alu_src_b_in;
            alu_op_out        <= alu_op_in;
            is_branch_out     <= is_branch_in;
            branch_type_out   <= branch_type_in;
            is_jump_out       <= is_jump_in;
            csr_op_out        <= csr_op_in;
            csr_wdata_src_out <= csr_wdata_src_in;
            is_mret_out       <= is_mret_in;
            mul_op_out        <= mul_op_in;
            ex_result_src_out <= ex_result_src_in;
            mem_read_out      <= mem_read_in;
            mem_write_out     <= mem_write_in;
            wen_out           <= wen_in;
            ld_select_out     <= ld_select_in;
            reg_write_out     <= reg_write_in;
            valid_out         <= 1'b1;
        end
    end

endmodule