// =============================================================================
// id_stage.v
// ID-stage submodule.
// Contains: if_id_reg, regfile, imm_gen, control_unit,
//           id_rs1_fwd_mux, id_rs2_fwd_mux
//
// Inputs:
//   - clk, rst, stall, flush
//   - pc_in, pc_plus_4_in, instr_in        (from testbench / IF stage)
//   - wb_rd_addr, wb_rd_data, wb_reg_write (from MEM3/WB, regfile write port)
//   - mem3wb_fwd_data                      (forwarding source for ID muxes)
//   - id_rs1_fwd_sel, id_rs2_fwd_sel       (from forwarding unit)
//
// Outputs:
//   - Data fields for the ID/EX register
//   - All control signals from the control unit
//   - if_id_valid for downstream visibility
// =============================================================================

module id_stage (
    input  wire        clk,
    input  wire        rst,
    input  wire        stall,
    input  wire        flush,

    // From IF / testbench
    input  wire [31:0] pc_in,
    input  wire [31:0] pc_plus_4_in,
    input  wire [31:0] instr_in,

    // Register file write port (from WB)
    input  wire        wb_reg_write,
    input  wire [4:0]  wb_rd_addr,
    input  wire [31:0] wb_rd_data,

    // ID-stage forwarding source and selects (from forwarding unit / MEM3/WB)
    input  wire [31:0] mem3wb_fwd_data,
    input  wire        id_rs1_fwd_sel,
    input  wire        id_rs2_fwd_sel,

    // ----- Outputs to ID/EX register input side -----

    // Data
    output wire [31:0] pc_out,
    output wire [31:0] pc_plus_4_out,
    output wire [31:0] instr_out,
    output wire [31:0] imm_out,
    output wire [31:0] rs1_data_out,
    output wire [31:0] rs2_data_out,
    output wire [4:0]  rs1_addr_out,
    output wire [4:0]  rs2_addr_out,
    output wire [4:0]  rd_addr_out,

    // EX control
    output wire        alu_src_a_out,
    output wire [1:0]  alu_src_b_out,
    output wire [3:0]  alu_op_out,
    output wire        is_branch_out,
    output wire [2:0]  branch_type_out,
    output wire        is_jump_out,
    output wire [1:0]  csr_op_out,
    output wire        csr_wdata_src_out,
    output wire        is_mret_out,
    output wire [1:0]  mul_op_out,
    output wire [2:0]  ex_result_src_out,

    // MEM control
    output wire        mem_read_out,
    output wire        mem_write_out,
    output wire [3:0]  wen_out,
    output wire [2:0]  ld_select_out,

    // WB control
    output wire        reg_write_out,

    // Pipeline state
    output wire        valid_out
);

    // -------------------------------------------------------------------------
    // IF/ID pipeline register
    // -------------------------------------------------------------------------
    wire [31:0] if_id_pc;
    wire [31:0] if_id_pc_plus_4;
    wire [31:0] if_id_instr;
    wire        if_id_valid;

    if_id_reg u_if_id_reg (
        .clk           (clk),
        .rst           (rst),
        .stall         (stall),
        .flush         (flush),

        .pc_in         (pc_in),
        .pc_plus_4_in  (pc_plus_4_in),
        .instr_in      (instr_in),

        .pc_out        (if_id_pc),
        .pc_plus_4_out (if_id_pc_plus_4),
        .instr_out     (if_id_instr),
        .valid_out     (if_id_valid)
    );

    // -------------------------------------------------------------------------
    // Decoded instruction field slices
    // -------------------------------------------------------------------------
    wire [6:0] opcode = if_id_instr[6:0];
    wire [2:0] funct3 = if_id_instr[14:12];
    wire [6:0] funct7 = if_id_instr[31:25];
    wire [4:0] rs1    = if_id_instr[19:15];
    wire [4:0] rs2    = if_id_instr[24:20];
    wire [4:0] rd     = if_id_instr[11:7];

    // -------------------------------------------------------------------------
    // Register file
    // -------------------------------------------------------------------------
    wire [31:0] regfile_rs1_data;
    wire [31:0] regfile_rs2_data;

    regfile u_regfile (
        .clk      (clk),
        .rst      (rst),

        .rs1_addr (rs1),
        .rs1_data (regfile_rs1_data),
        .rs2_addr (rs2),
        .rs2_data (regfile_rs2_data),

        .wen      (wb_reg_write),
        .rd_addr  (wb_rd_addr),
        .rd_data  (wb_rd_data)
    );

    // -------------------------------------------------------------------------
    // ID-stage forwarding muxes
    // Select between regfile output and MEM3/WB forwarded value.
    // -------------------------------------------------------------------------
    wire [31:0] id_rs1_data;
    wire [31:0] id_rs2_data;

    id_rs1_fwd_mux u_id_rs1_fwd_mux (
        .sel         (id_rs1_fwd_sel),
        .regfile_rs1 (regfile_rs1_data),
        .mem3wb_fwd  (mem3wb_fwd_data),
        .rs1_data    (id_rs1_data)
    );

    id_rs2_fwd_mux u_id_rs2_fwd_mux (
        .sel         (id_rs2_fwd_sel),
        .regfile_rs2 (regfile_rs2_data),
        .mem3wb_fwd  (mem3wb_fwd_data),
        .rs2_data    (id_rs2_data)
    );

    // -------------------------------------------------------------------------
    // Immediate generator
    // -------------------------------------------------------------------------
    wire [31:0] imm;

    imm_gen u_imm_gen (
        .instr (if_id_instr),
        .imm   (imm)
    );

    // -------------------------------------------------------------------------
    // Control unit
    // -------------------------------------------------------------------------
    wire        ctrl_alu_src_a;
    wire [1:0]  ctrl_alu_src_b;
    wire [3:0]  ctrl_alu_op;
    wire        ctrl_is_branch;
    wire [2:0]  ctrl_branch_type;
    wire        ctrl_is_jump;
    wire [1:0]  ctrl_csr_op;
    wire        ctrl_csr_wdata_src;
    wire        ctrl_is_mret;
    wire [1:0]  ctrl_mul_op;
    wire [2:0]  ctrl_ex_result_src;
    wire        ctrl_mem_read;
    wire        ctrl_mem_write;
    wire [3:0]  ctrl_wen;
    wire [2:0]  ctrl_ld_select;
    wire        ctrl_reg_write;

    control_unit u_control_unit (
        .opcode        (opcode),
        .funct3        (funct3),
        .funct7        (funct7),

        .alu_src_a     (ctrl_alu_src_a),
        .alu_src_b     (ctrl_alu_src_b),
        .alu_op        (ctrl_alu_op),
        .is_branch     (ctrl_is_branch),
        .branch_type   (ctrl_branch_type),
        .is_jump       (ctrl_is_jump),
        .csr_op        (ctrl_csr_op),
        .csr_wdata_src (ctrl_csr_wdata_src),
        .is_mret       (ctrl_is_mret),
        .mul_op        (ctrl_mul_op),
        .ex_result_src (ctrl_ex_result_src),

        .mem_read      (ctrl_mem_read),
        .mem_write     (ctrl_mem_write),
        .wen           (ctrl_wen),
        .ld_select     (ctrl_ld_select),

        .reg_write     (ctrl_reg_write)
    );

    // -------------------------------------------------------------------------
    // Output assignments
    // -------------------------------------------------------------------------

    // Data
    assign pc_out            = if_id_pc;
    assign pc_plus_4_out     = if_id_pc_plus_4;
    assign instr_out         = if_id_instr;
    assign imm_out           = imm;
    assign rs1_data_out      = id_rs1_data;
    assign rs2_data_out      = id_rs2_data;
    assign rs1_addr_out      = rs1;
    assign rs2_addr_out      = rs2;
    assign rd_addr_out       = rd;

    // EX control
    assign alu_src_a_out     = ctrl_alu_src_a;
    assign alu_src_b_out     = ctrl_alu_src_b;
    assign alu_op_out        = ctrl_alu_op;
    assign is_branch_out     = ctrl_is_branch;
    assign branch_type_out   = ctrl_branch_type;
    assign is_jump_out       = ctrl_is_jump;
    assign csr_op_out        = ctrl_csr_op;
    assign csr_wdata_src_out = ctrl_csr_wdata_src;
    assign is_mret_out       = ctrl_is_mret;
    assign mul_op_out        = ctrl_mul_op;
    assign ex_result_src_out = ctrl_ex_result_src;

    // MEM control
    assign mem_read_out      = ctrl_mem_read;
    assign mem_write_out     = ctrl_mem_write;
    assign wen_out           = ctrl_wen;
    assign ld_select_out     = ctrl_ld_select;

    // WB control
    assign reg_write_out     = ctrl_reg_write;

    // Pipeline state
    assign valid_out         = if_id_valid;

endmodule