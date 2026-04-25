`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2026 04:17:47 PM
// Design Name: 
// Module Name: datapath
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
// datapath.v
// Wraps the 4 pipeline stages (id, ex, mem, wb) and the forwarding unit.
// Exposes a clean interface to the front end, memory subsystem, and control
// plane.
// =============================================================================

module datapath (
    input  wire        clk,
    input  wire        rst,

    // ----- From front end (fetch unit head) -----
    input  wire [31:0] if_pc_in,
    input  wire [31:0] if_pc_plus_4_in,
    input  wire [31:0] if_instr_in,

    // ----- From control plane: per-stage stall/flush -----
    input  wire        if_id_stall,
    input  wire        if_id_flush,
    input  wire        id_ex_stall,
    input  wire        id_ex_flush,
    input  wire        ex_mem1_stall,
    input  wire        ex_mem1_flush,
    input  wire        ex_mem1_branch_addr_update,
    input  wire        mem1_mem2_stall,
    input  wire        mem1_mem2_flush,
    input  wire        mem2_mem3_stall,
    input  wire        mem2_mem3_flush,

    // ----- CSR interface (datapath ? control plane) -----
    output wire [11:0] csr_addr,
    output wire        csr_wen,
    output wire [31:0] csr_wdata,
    input  wire [31:0] csr_rdata,

    // ----- Memory interface (datapath ? memory subsystem) -----
    output wire [31:0] mem_req_addr,
    output wire [31:0] mem_req_wdata,
    output wire [3:0]  mem_req_wen,
    output wire        mem_req_mem_read,
    output wire        mem_req_mem_write,
    input  wire [31:0] mem_resp_data,

    // ----- Pipeline visibility outputs (to control plane / hazard unit) -----
    output wire        if_id_valid_out,
    output wire [31:0] if_id_pc_out,

    output wire        id_ex_valid_out,
    output wire [31:0] id_ex_pc_out,
    output wire        id_ex_is_mret_out,
    output wire [3:0]  id_ex_rs1_dep_out,
    output wire [3:0]  id_ex_rs2_dep_out,


    output wire        ex_mem1_valid_out,
    output wire [31:0] ex_mem1_pc_out,
    output wire        ex_mem1_is_branch_out,
    output wire        ex_mem1_is_jump_out,
    output wire        ex_mem1_is_taken_out,
    output wire        ex_mem1_mem_read_out,
    output wire        ex_mem1_mem_write_out,
    output wire        id_ex_is_mul_out,
    output wire [31:0] ex_mem1_branch_addr_out,

    output wire        mem1_mem2_valid_out,
    output wire [31:0] mem1_mem2_pc_out,

    output wire        mem2_mem3_valid_out,
    output wire [31:0] mem2_mem3_pc_out,
    
    output wire [31:0] wb_rd_data_out,
    output wire [4:0]  wb_rd_addr_out,
    output wire        wb_reg_write_out,
    output wire [31:0] wb_pc_out,

    // WB commit (for minstret)
    output wire        wb_valid_out
);

    // -------------------------------------------------------------------------
    // ID stage outputs
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
    wire alu_op_override_w;
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
    wire        ex_is_taken;

    wire [4:0]  id_ex_rs1_addr;
    wire [4:0]  id_ex_rs2_addr;
    wire        id_ex_alu_src_a;
    wire [1:0]  id_ex_alu_src_b;
    wire        is_mret_out_ex;
    wire        is_mul_out_ex;

    // -------------------------------------------------------------------------
    // MEM stage outputs
    // -------------------------------------------------------------------------
    wire [31:0] wb_in_write_data;
    wire [4:0]  wb_in_rd_addr;
    wire [31:0] wb_in_pc;
    wire        wb_in_reg_write;

    wire [31:0] ex_mem1_fwd;
    wire [31:0] mem1_mem2_fwd;
    wire [31:0] mem2_mem3_fwd;
    wire [31:0] mask_unit_fwd;

    wire [4:0]  ex_mem1_rd_addr_w;
    wire        ex_mem1_reg_write_w;
    wire        ex_mem1_mem_read_w;

    wire [4:0]  mem1_mem2_rd_addr_w;
    wire        mem1_mem2_reg_write_w;
    wire        mem1_mem2_mem_read_w;

    wire [4:0]  mem2_mem3_rd_addr_w;
    wire        mem2_mem3_reg_write_w;
    wire        mem2_mem3_mem_read_w;

    // -------------------------------------------------------------------------
    // WB stage outputs
    // -------------------------------------------------------------------------
    wire [31:0] wb_rd_data;
    wire [4:0]  wb_rd_addr;
    wire [31:0] wb_pc;
    wire        wb_reg_write;
    wire        wb_valid;
    wire [31:0] mem3_wb_fwd;
    wire [4:0]  mem3_wb_rd_addr;
    wire        mem3_wb_reg_write;

    // -------------------------------------------------------------------------
    // ID stage
    // -------------------------------------------------------------------------
    id_stage u_id_stage (
        .clk               (clk),
        .rst               (rst),
        .stall             (if_id_stall),
        .flush             (if_id_flush),

        .pc_in             (if_pc_in),
        .pc_plus_4_in      (if_pc_plus_4_in),
        .instr_in          (if_instr_in),

        .wb_reg_write      (wb_reg_write),
        .wb_rd_addr        (wb_rd_addr),
        .wb_rd_data        (wb_rd_data),

        .mem3wb_fwd_data   (mem3_wb_fwd),
        .id_rs1_fwd_sel    (id_rs1_fwd_sel),
        .id_rs2_fwd_sel    (id_rs2_fwd_sel),

        .pc_out            (id_pc),
        .pc_plus_4_out     (id_pc_plus_4),
        .instr_out         (id_instr),
        .imm_out           (id_imm),
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
        .stall            (id_ex_stall),
        .flush            (id_ex_flush),

        .id_pc            (id_pc),
        .id_pc_plus_4     (id_pc_plus_4),
        .id_imm           (id_imm),
        .id_rs1_data      (id_rs1_data),
        .id_rs2_data      (id_rs2_data),
        .id_rs1_addr      (id_rs1_addr),
        .id_rs2_addr      (id_rs2_addr),
        .id_rd_addr       (id_rd_addr),

        .id_alu_src_a     (id_alu_src_a),
        .id_alu_src_b     (id_alu_src_b),
        .id_alu_op        (id_alu_op),
        .alu_op_override    (alu_op_override_w),
        .id_is_branch     (id_is_branch),
        .id_branch_type   (id_branch_type),
        .id_is_jump       (id_is_jump),
        .id_csr_op        (id_csr_op),
        .id_csr_wdata_src (id_csr_wdata_src),
        .id_is_mret       (id_is_mret),
        .id_mul_op        (id_mul_op),
        .id_ex_result_src (id_ex_result_src),

        .id_mem_read      (id_mem_read),
        .id_mem_write     (id_mem_write),
        .id_wen           (id_wen),
        .id_ld_select     (id_ld_select),

        .id_reg_write     (id_reg_write),

        .ex_mem1_fwd      (ex_mem1_fwd),
        .mem1_mem2_fwd    (mem1_mem2_fwd),
        .mem2_mem3_fwd    (mem2_mem3_fwd),
        .mask_unit_fwd    (mask_unit_fwd),
        .mem3_wb_fwd      (mem3_wb_fwd),
        .ex_mem1_pc_fwd (ex_mem1_pc_out),

        .alu_src_a_sel    (alu_src_a_sel),
        .alu_src_b_sel    (alu_src_b_sel),
        .str_data_mux_sel (str_data_mux_sel),

        .csr_addr_out     (csr_addr),
        .csr_wen_out      (csr_wen),
        .csr_wdata_out    (csr_wdata),
        .csr_rdata_in     (csr_rdata),
        .is_mret_out_ex   (is_mret_out_ex),

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
        .is_taken_out       (ex_is_taken),
        .is_mul_out_ex    (is_mul_out_ex),

        .valid_out        (ex_valid)
    );

    // -------------------------------------------------------------------------
    // MEM stage
    // -------------------------------------------------------------------------
    mem_stage u_mem_stage (
        .clk                        (clk),
        .rst                        (rst),

        .ex_mem1_stall              (ex_mem1_stall),
        .ex_mem1_flush              (ex_mem1_flush),
        .ex_mem1_branch_addr_update (ex_mem1_branch_addr_update),
        .mem1_mem2_stall            (mem1_mem2_stall),
        .mem1_mem2_flush            (mem1_mem2_flush),
        .mem2_mem3_stall            (mem2_mem3_stall),
        .mem2_mem3_flush            (mem2_mem3_flush),

        .ex_pc                      (ex_pc),
        .ex_result                  (ex_result),
        .ex_branch_addr             (ex_branch_addr),
        .ex_store_data              (ex_store_data),
        .ex_rd_addr                 (ex_rd_addr),

        .ex_mem_read                (ex_mem_read),
        .ex_mem_write               (ex_mem_write),
        .ex_wen                     (ex_wen),
        .ex_is_branch               (ex_is_branch),
        .ex_is_jump                 (ex_is_jump),
        .ex_ld_select               (ex_ld_select),
        .ex_reg_write               (ex_reg_write),

        .mem_req_addr               (mem_req_addr),
        .mem_req_wdata              (mem_req_wdata),
        .mem_req_wen                (mem_req_wen),
        .mem_req_mem_read           (mem_req_mem_read),
        .mem_req_mem_write          (mem_req_mem_write),
        .mem_resp_data              (mem_resp_data),

        .wb_in_write_data           (wb_in_write_data),
        .wb_in_rd_addr              (wb_in_rd_addr),
        .wb_in_pc                   (wb_in_pc),
        .wb_in_reg_write            (wb_in_reg_write),

        .ex_mem1_fwd                (ex_mem1_fwd),
        .mem1_mem2_fwd              (mem1_mem2_fwd),
        .mem2_mem3_fwd              (mem2_mem3_fwd),
        .mask_unit_fwd              (mask_unit_fwd),

        .ex_mem1_rd_addr            (ex_mem1_rd_addr_w),
        .ex_mem1_reg_write          (ex_mem1_reg_write_w),
        .ex_mem1_mem_read           (ex_mem1_mem_read_w),

        .mem1_mem2_rd_addr          (mem1_mem2_rd_addr_w),
        .mem1_mem2_reg_write        (mem1_mem2_reg_write_w),
        .mem1_mem2_mem_read         (mem1_mem2_mem_read_w),

        .mem2_mem3_rd_addr          (mem2_mem3_rd_addr_w),
        .mem2_mem3_reg_write        (mem2_mem3_reg_write_w),
        .mem2_mem3_mem_read         (mem2_mem3_mem_read_w),

        .ex_mem1_pc                 (ex_mem1_pc_out),
        .ex_mem1_is_branch          (ex_mem1_is_branch_out),
        .ex_mem1_is_jump            (ex_mem1_is_jump_out),
        .ex_mem1_mem_write_out      (ex_mem1_mem_write_out),
        .ex_mem1_branch_addr        (ex_mem1_branch_addr_out),
        .ex_mem1_valid              (ex_mem1_valid_out),

        .mem1_mem2_pc               (mem1_mem2_pc_out),
        .mem1_mem2_valid            (mem1_mem2_valid_out),
        
        .ex_is_taken (ex_is_taken),
        .ex_mem1_is_taken (ex_mem1_is_taken_out),

        .mem2_mem3_pc               (mem2_mem3_pc_out),
        .mem2_mem3_valid            (mem2_mem3_valid_out)
    );

    // -------------------------------------------------------------------------
    // WB stage
    // -------------------------------------------------------------------------
    wb_stage u_wb_stage (
        .clk               (clk),
        .rst               (rst),
        .stall             (1'b0),
        .flush             (1'b0),

        .wb_in_write_data  (wb_in_write_data),
        .wb_in_rd_addr     (wb_in_rd_addr),
        .wb_in_pc          (wb_in_pc),
        .wb_in_reg_write   (wb_in_reg_write),

        .wb_rd_data        (wb_rd_data),
        .wb_rd_addr        (wb_rd_addr),
        .wb_pc             (wb_pc),
        .wb_reg_write      (wb_reg_write),
        .wb_valid          (wb_valid),

        .mem3_wb_fwd       (mem3_wb_fwd),
        .mem3_wb_rd_addr   (mem3_wb_rd_addr),
        .mem3_wb_reg_write (mem3_wb_reg_write)
    );

    // -------------------------------------------------------------------------
    // Forwarding unit
    // -------------------------------------------------------------------------
    forwarding_unit u_forwarding_unit (
        .if_id_rs1           (id_rs1_addr),
        .if_id_rs2           (id_rs2_addr),
        .id_ex_rs1           (id_ex_rs1_addr),
        .id_ex_rs2           (id_ex_rs2_addr),

        .id_ex_alu_src_a     (id_ex_alu_src_a),
        .id_ex_alu_src_b     (id_ex_alu_src_b),

        .ex_mem1_rd          (ex_mem1_rd_addr_w),
        .ex_mem1_reg_write   (ex_mem1_reg_write_w),
        .ex_mem1_mem_read    (ex_mem1_mem_read_w),

        .mem1_mem2_rd        (mem1_mem2_rd_addr_w),
        .mem1_mem2_reg_write (mem1_mem2_reg_write_w),
        .mem1_mem2_mem_read  (mem1_mem2_mem_read_w),

        .mem2_mem3_rd        (mem2_mem3_rd_addr_w),
        .mem2_mem3_reg_write (mem2_mem3_reg_write_w),
        .mem2_mem3_mem_read  (mem2_mem3_mem_read_w),

        .mem3_wb_rd          (mem3_wb_rd_addr),
        .mem3_wb_reg_write   (mem3_wb_reg_write),

        .id_rs1_fwd_sel      (id_rs1_fwd_sel),
        .id_rs2_fwd_sel      (id_rs2_fwd_sel),
        .alu_src_a_sel       (alu_src_a_sel),
        .alu_src_b_sel       (alu_src_b_sel),
        .str_data_mux_sel    (str_data_mux_sel),

        .if_id_rs1_dep       (if_id_rs1_dep),
        .if_id_rs2_dep       (if_id_rs2_dep),
        .id_ex_rs1_dep       (id_ex_rs1_dep),
        .ex_mem1_is_branch  (ex_mem1_is_branch_out),
        .ex_mem1_is_taken   (ex_mem1_is_taken_out),
        .alu_op_override    (alu_op_override_w),
        .id_ex_rs2_dep       (id_ex_rs2_dep)
    );

    // -------------------------------------------------------------------------
    // Visibility outputs
    // -------------------------------------------------------------------------
    assign if_id_valid_out      = id_valid;
    assign if_id_pc_out         = id_pc;

    assign id_ex_valid_out      = ex_valid;
    assign id_ex_pc_out         = ex_pc;
    assign id_ex_is_mret_out    = is_mret_out_ex;
    assign id_ex_rs1_dep_out    = id_ex_rs1_dep;
    assign id_ex_rs2_dep_out    = id_ex_rs2_dep;

    assign ex_mem1_mem_read_out = ex_mem1_mem_read_w;
    // TODO: needs is_taken propagation through ex_mem1_reg

    assign wb_valid_out         = wb_valid;
    assign wb_rd_data_out   = wb_rd_data;
    assign wb_rd_addr_out   = wb_rd_addr;
    assign wb_reg_write_out = wb_reg_write;
    assign wb_pc_out        = wb_pc;
    assign id_ex_is_mul_out = is_mul_out_ex;

endmodule
