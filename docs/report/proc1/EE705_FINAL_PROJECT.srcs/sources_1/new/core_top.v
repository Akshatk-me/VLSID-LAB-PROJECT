`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 01:21:19 PM
// Design Name: 
// Module Name: core_top
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
// core_top.v
// Top-level integration of the RV32IM pipelined core.
// Submodules: id_stage, ex_stage, mem_stage, wb_stage, forwarding_unit
//
// Memory (BRAM) is internal to mem_stage.
// IF/ID inputs are testbench-driven.
//
// Stall and flush ports are exposed but tied to 0 by the testbench (no
// hazard unit yet).
// =============================================================================

module core_top (
    input  wire        clk,
    input  wire        rst,
    input  wire        stall,
    input  wire        flush,

    // Testbench-driven IF stage
    input  wire [31:0] pc_in,
    input  wire [31:0] pc_plus_4_in,
    input  wire [31:0] instr_in,

    // Observation outputs
    output wire [31:0] wb_write_data,
    output wire [4:0]  wb_rd_addr,
    output wire        wb_reg_write,
    output wire        wb_valid
);

    // -------------------------------------------------------------------------
    // ID stage outputs (going to EX stage)
    // -------------------------------------------------------------------------
    wire [31:0] id_pc;
    wire [31:0] id_pc_plus_4;
    wire [31:0] id_instr;
    wire [31:0] id_imm;
    wire [31:0] id_rs1_data;
    wire [31:0] id_rs2_data;
    wire [4:0]  id_rs1_addr;
    wire [4:0]  id_rs2_addr;
    wire [4:0]  id_rd_addr;

    wire        id_alu_src_a;
    wire [1:0]  id_alu_src_b;
    wire [3:0]  id_alu_op;
    wire        id_is_branch;
    wire [2:0]  id_branch_type;
    wire        id_is_jump;
    wire [1:0]  id_csr_op;
    wire        id_csr_wdata_src;
    wire        id_is_mret;
    wire [1:0]  id_mul_op;
    wire [2:0]  id_ex_result_src;

    wire        id_mem_read;
    wire        id_mem_write;
    wire [3:0]  id_wen;
    wire [2:0]  id_ld_select;

    wire        id_reg_write;
    wire        id_valid;

    // -------------------------------------------------------------------------
    // EX stage outputs (going to MEM stage)
    // -------------------------------------------------------------------------
    wire [31:0] ex_pc;
    wire [31:0] ex_result;
    wire [31:0] ex_branch_addr;
    wire [31:0] ex_store_data;
    wire [4:0]  ex_rd_addr;

    wire        ex_mem_read;
    wire        ex_mem_write;
    wire [3:0]  ex_wen;
    wire        ex_is_branch;
    wire        ex_is_jump;
    wire [2:0]  ex_ld_select;
    wire        ex_reg_write;
    wire        ex_valid;

    // EX-stage forwarding-unit visibility
    wire [4:0]  id_ex_rs1_addr;
    wire [4:0]  id_ex_rs2_addr;
    wire        id_ex_alu_src_a;
    wire [1:0]  id_ex_alu_src_b;

    // -------------------------------------------------------------------------
    // MEM stage outputs (forwarding sources, producer info, WB-input bus)
    // -------------------------------------------------------------------------
    wire [31:0] wb_in_write_data;
    wire [4:0]  wb_in_rd_addr;
    wire [31:0] wb_in_pc;
    wire        wb_in_reg_write;

    wire [31:0] ex_mem1_fwd;
    wire [31:0] mem1_mem2_fwd;
    wire [31:0] mem2_mem3_fwd;
    wire [31:0] mask_unit_fwd;

    wire [4:0]  ex_mem1_rd_addr;
    wire        ex_mem1_reg_write_w;
    wire        ex_mem1_mem_read;

    wire [4:0]  mem1_mem2_rd_addr;
    wire        mem1_mem2_reg_write;
    wire        mem1_mem2_mem_read;

    wire [4:0]  mem2_mem3_rd_addr;
    wire        mem2_mem3_reg_write;
    wire        mem2_mem3_mem_read;

    // -------------------------------------------------------------------------
    // WB stage outputs (writeback bus, MEM3/WB forwarding)
    // -------------------------------------------------------------------------
    wire [31:0] wb_rd_data;
    wire [4:0]  wb_rd_addr_w;
    wire [31:0] wb_pc;
    wire        wb_reg_write_w;
    wire        wb_valid_w;

    wire [31:0] mem3_wb_fwd;
    wire [4:0]  mem3_wb_rd_addr;
    wire        mem3_wb_reg_write;

    // -------------------------------------------------------------------------
    // Forwarding unit outputs
    // -------------------------------------------------------------------------
    wire        id_rs1_fwd_sel;
    wire        id_rs2_fwd_sel;
    wire [2:0]  alu_src_a_sel;
    wire [2:0]  alu_src_b_sel;
    wire [2:0]  str_data_mux_sel;

    wire        if_id_rs1_dep;
    wire        if_id_rs2_dep;
    wire [3:0]  id_ex_rs1_dep;
    wire [3:0]  id_ex_rs2_dep;

    // -------------------------------------------------------------------------
    // ID stage
    // -------------------------------------------------------------------------
    id_stage u_id_stage (
        .clk               (clk),
        .rst               (rst),
        .stall             (stall),
        .flush             (flush),

        .pc_in             (pc_in),
        .pc_plus_4_in      (pc_plus_4_in),
        .instr_in          (instr_in),

        // Regfile write port (from WB)
        .wb_reg_write      (wb_reg_write_w),
        .wb_rd_addr        (wb_rd_addr_w),
        .wb_rd_data        (wb_rd_data),

        // ID-stage forwarding from MEM3/WB
        .mem3wb_fwd_data   (mem3_wb_fwd),
        .id_rs1_fwd_sel    (id_rs1_fwd_sel),
        .id_rs2_fwd_sel    (id_rs2_fwd_sel),

        // Outputs
        .pc_out            (id_pc),
        .pc_plus_4_out     (id_pc_plus_4),
        .instr_out         (id_instr),
        .imm_out            (id_imm),
        .rs1_data_out      (id_rs1_data),
        .rs2_data_out      (id_rs2_data),
        .rs1_addr_out      (id_rs1_addr),
        .rs2_addr_out      (id_rs2_addr),
        .rd_addr_out       (id_rd_addr),

        .alu_src_a_out     (id_alu_src_a),
        .alu_src_b_out     (id_alu_src_b),
        .alu_op_out        (id_alu_op),
        .is_branch_out     (id_is_branch),
        .branch_type_out   (id_branch_type),
        .is_jump_out       (id_is_jump),
        .csr_op_out        (id_csr_op),
        .csr_wdata_src_out (id_csr_wdata_src),
        .is_mret_out       (id_is_mret),
        .mul_op_out        (id_mul_op),
        .ex_result_src_out (id_ex_result_src),

        .mem_read_out      (id_mem_read),
        .mem_write_out     (id_mem_write),
        .wen_out           (id_wen),
        .ld_select_out     (id_ld_select),

        .reg_write_out     (id_reg_write),
        .valid_out         (id_valid)
    );

    // -------------------------------------------------------------------------
    // EX stage
    // -------------------------------------------------------------------------
    ex_stage u_ex_stage (
        .clk              (clk),
        .rst              (rst),
        .stall            (stall),
        .flush            (flush),

        // ID-stage data
        .id_pc            (id_pc),
        .id_pc_plus_4     (id_pc_plus_4),
        .id_imm           (id_imm),
        .id_rs1_data      (id_rs1_data),
        .id_rs2_data      (id_rs2_data),
        .id_rs1_addr      (id_rs1_addr),
        .id_rs2_addr      (id_rs2_addr),
        .id_rd_addr       (id_rd_addr),

        // ID-stage EX control
        .id_alu_src_a     (id_alu_src_a),
        .id_alu_src_b     (id_alu_src_b),
        .id_alu_op        (id_alu_op),
        .id_is_branch     (id_is_branch),
        .id_branch_type   (id_branch_type),
        .id_is_jump       (id_is_jump),
        .id_csr_op        (id_csr_op),
        .id_csr_wdata_src (id_csr_wdata_src),
        .id_is_mret       (id_is_mret),
        .id_mul_op        (id_mul_op),
        .id_ex_result_src (id_ex_result_src),

        // ID-stage MEM control
        .id_mem_read      (id_mem_read),
        .id_mem_write     (id_mem_write),
        .id_wen           (id_wen),
        .id_ld_select     (id_ld_select),

        // ID-stage WB control
        .id_reg_write     (id_reg_write),

        // Forwarding sources
        .ex_mem1_fwd      (ex_mem1_fwd),
        .mem1_mem2_fwd    (mem1_mem2_fwd),
        .mem2_mem3_fwd    (mem2_mem3_fwd),
        .mask_unit_fwd    (mask_unit_fwd),
        .mem3_wb_fwd      (mem3_wb_fwd),

        // Forwarding mux selects
        .alu_src_a_sel    (alu_src_a_sel),
        .alu_src_b_sel    (alu_src_b_sel),
        .str_data_mux_sel (str_data_mux_sel),

        // Outputs
        .pc_out           (ex_pc),
        .ex_result_out    (ex_result),
        .branch_addr_out  (ex_branch_addr),
        .store_data_out   (ex_store_data),
        .rd_addr_out      (ex_rd_addr),

        .mem_read_out     (ex_mem_read),
        .mem_write_out    (ex_mem_write),
        .wen_out          (ex_wen),
        .is_branch_out    (ex_is_branch),
        .is_jump_out      (ex_is_jump),
        .ld_select_out    (ex_ld_select),
        .reg_write_out    (ex_reg_write),

        .id_ex_rs1_addr   (id_ex_rs1_addr),
        .id_ex_rs2_addr   (id_ex_rs2_addr),
        .id_ex_alu_src_a  (id_ex_alu_src_a),
        .id_ex_alu_src_b  (id_ex_alu_src_b),

        .valid_out        (ex_valid)
    );

    // -------------------------------------------------------------------------
    // MEM stage
    // -------------------------------------------------------------------------
    mem_stage u_mem_stage (
        .clk                 (clk),
        .rst                 (rst),
        .stall               (stall),
        .flush               (flush),

        // EX-stage data
        .ex_pc               (ex_pc),
        .ex_result           (ex_result),
        .ex_branch_addr      (ex_branch_addr),
        .ex_store_data       (ex_store_data),
        .ex_rd_addr          (ex_rd_addr),

        // EX-stage MEM control
        .ex_mem_read         (ex_mem_read),
        .ex_mem_write        (ex_mem_write),
        .ex_wen              (ex_wen),
        .ex_is_branch        (ex_is_branch),
        .ex_is_jump          (ex_is_jump),
        .ex_ld_select        (ex_ld_select),
        .ex_reg_write        (ex_reg_write),

        // To WB submodule
        .wb_in_write_data    (wb_in_write_data),
        .wb_in_rd_addr       (wb_in_rd_addr),
        .wb_in_pc            (wb_in_pc),
        .wb_in_reg_write     (wb_in_reg_write),

        // Forwarding sources
        .ex_mem1_fwd         (ex_mem1_fwd),
        .mem1_mem2_fwd       (mem1_mem2_fwd),
        .mem2_mem3_fwd       (mem2_mem3_fwd),
        .mask_unit_fwd       (mask_unit_fwd),

        // Producer info
        .ex_mem1_rd_addr     (ex_mem1_rd_addr),
        .ex_mem1_reg_write   (ex_mem1_reg_write_w),
        .ex_mem1_mem_read    (ex_mem1_mem_read),

        .mem1_mem2_rd_addr   (mem1_mem2_rd_addr),
        .mem1_mem2_reg_write (mem1_mem2_reg_write),
        .mem1_mem2_mem_read  (mem1_mem2_mem_read),

        .mem2_mem3_rd_addr   (mem2_mem3_rd_addr),
        .mem2_mem3_reg_write (mem2_mem3_reg_write),
        .mem2_mem3_mem_read  (mem2_mem3_mem_read)
    );

    // -------------------------------------------------------------------------
    // WB stage
    // -------------------------------------------------------------------------
    wb_stage u_wb_stage (
        .clk               (clk),
        .rst               (rst),
        .stall             (stall),
        .flush             (flush),

        .wb_in_write_data  (wb_in_write_data),
        .wb_in_rd_addr     (wb_in_rd_addr),
        .wb_in_pc          (wb_in_pc),
        .wb_in_reg_write   (wb_in_reg_write),

        .wb_rd_data        (wb_rd_data),
        .wb_rd_addr        (wb_rd_addr_w),
        .wb_pc             (wb_pc),
        .wb_reg_write      (wb_reg_write_w),
        .wb_valid          (wb_valid_w),

        .mem3_wb_fwd       (mem3_wb_fwd),
        .mem3_wb_rd_addr   (mem3_wb_rd_addr),
        .mem3_wb_reg_write (mem3_wb_reg_write)
    );

    // -------------------------------------------------------------------------
    // Forwarding unit
    // -------------------------------------------------------------------------
    forwarding_unit u_forwarding_unit (
        // Consumer addresses
        .if_id_rs1           (id_rs1_addr),
        .if_id_rs2           (id_rs2_addr),
        .id_ex_rs1           (id_ex_rs1_addr),
        .id_ex_rs2           (id_ex_rs2_addr),

        // Control unit choices
        .id_ex_alu_src_a     (id_ex_alu_src_a),
        .id_ex_alu_src_b     (id_ex_alu_src_b),

        // Producer info
        .ex_mem1_rd          (ex_mem1_rd_addr),
        .ex_mem1_reg_write   (ex_mem1_reg_write_w),
        .ex_mem1_mem_read    (ex_mem1_mem_read),

        .mem1_mem2_rd        (mem1_mem2_rd_addr),
        .mem1_mem2_reg_write (mem1_mem2_reg_write),
        .mem1_mem2_mem_read  (mem1_mem2_mem_read),

        .mem2_mem3_rd        (mem2_mem3_rd_addr),
        .mem2_mem3_reg_write (mem2_mem3_reg_write),
        .mem2_mem3_mem_read  (mem2_mem3_mem_read),

        .mem3_wb_rd          (mem3_wb_rd_addr),
        .mem3_wb_reg_write   (mem3_wb_reg_write),

        // Mux selects
        .id_rs1_fwd_sel      (id_rs1_fwd_sel),
        .id_rs2_fwd_sel      (id_rs2_fwd_sel),
        .alu_src_a_sel       (alu_src_a_sel),
        .alu_src_b_sel       (alu_src_b_sel),
        .str_data_mux_sel    (str_data_mux_sel),

        // Dependency map
        .if_id_rs1_dep       (if_id_rs1_dep),
        .if_id_rs2_dep       (if_id_rs2_dep),
        .id_ex_rs1_dep       (id_ex_rs1_dep),
        .id_ex_rs2_dep       (id_ex_rs2_dep)
    );

    // -------------------------------------------------------------------------
    // Top-level observation outputs
    // -------------------------------------------------------------------------
    assign wb_write_data = wb_rd_data;
    assign wb_rd_addr    = wb_rd_addr_w;
    assign wb_reg_write  = wb_reg_write_w;
    assign wb_valid      = wb_valid_w;

endmodule