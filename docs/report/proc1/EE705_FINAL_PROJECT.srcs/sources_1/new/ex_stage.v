// =============================================================================
// ex_stage.v
// EX-stage submodule.
// Contains: id_ex_reg, ex_alu_a_mux, ex_alu_b_mux, store_data_mux,
//           csr_wdata_mux, alu, multiplier, branch_comparator, ex_result_mux
//
// CSR file is now at top level; this stage exposes CSR ports for it.
//
// Branch handling: in EX, branches only perform the compare via the ALU
// (SUB) and produce is_taken via the branch_comparator. Branch address
// computation happens in MEM1 (handled there).
// =============================================================================

module ex_stage (
    input  wire        clk,
    input  wire        rst,
    input  wire        stall,
    input  wire        flush,

    // ----- ID-stage data inputs -----
    input  wire [31:0] id_pc,
    input  wire [31:0] id_pc_plus_4,
    input  wire [31:0] id_imm,
    input  wire [31:0] id_rs1_data,
    input  wire [31:0] id_rs2_data,
    input  wire [4:0]  id_rs1_addr,
    input  wire [4:0]  id_rs2_addr,
    input  wire [4:0]  id_rd_addr,

    // ----- ID-stage EX control inputs -----
    input  wire        id_alu_src_a,
    input  wire [1:0]  id_alu_src_b,
    input  wire [3:0]  id_alu_op,
    input  wire        id_is_branch,
    input  wire [2:0]  id_branch_type,
    input  wire        id_is_jump,
    input  wire [1:0]  id_csr_op,
    input  wire        id_csr_wdata_src,
    input  wire        id_is_mret,
    input  wire [1:0]  id_mul_op,
    input  wire [2:0]  id_ex_result_src,

    // ----- ID-stage MEM control inputs -----
    input  wire        id_mem_read,
    input  wire        id_mem_write,
    input  wire [3:0]  id_wen,
    input  wire [2:0]  id_ld_select,

    // ----- ID-stage WB control input -----
    input  wire        id_reg_write,

    // ----- Forwarding sources from later stages -----
    input  wire [31:0] ex_mem1_fwd,
    input  wire [31:0] mem1_mem2_fwd,
    input  wire [31:0] mem2_mem3_fwd,
    input  wire [31:0] mask_unit_fwd,
    input  wire [31:0] mem3_wb_fwd,
    input  wire [31:0] ex_mem1_pc_fwd,

    // ----- Forwarding mux selects from forwarding unit -----
    input  wire [2:0]  alu_src_a_sel,
    input  wire [2:0]  alu_src_b_sel,
    input  wire [2:0]  str_data_mux_sel,
    input  wire        alu_op_override,

    // ----- CSR interface (to top-level CSR file) -----
    output wire [11:0] csr_addr_out,
    output wire        csr_wen_out,
    output wire [31:0] csr_wdata_out,
    input  wire [31:0] csr_rdata_in,

    // ----- MRET signal exposure (to hazard unit / CSR file) -----
    output wire        is_mret_out_ex,

    // ----- Outputs to EX/MEM1 register input side -----

    // Data
    output wire [31:0] pc_out,
    output wire [31:0] ex_result_out,
    output wire [31:0] branch_addr_out,
    output wire [31:0] store_data_out,
    output wire [4:0]  rd_addr_out,

    // MEM control
    output wire        mem_read_out,
    output wire        mem_write_out,
    output wire [3:0]  wen_out,
    output wire        is_branch_out,
    output wire        is_jump_out,
    output wire [2:0]  ld_select_out,
    output wire        reg_write_out,

    // Forwarding-unit visibility
    output wire [4:0]  id_ex_rs1_addr,
    output wire [4:0]  id_ex_rs2_addr,
    output wire        id_ex_alu_src_a,
    output wire [1:0]  id_ex_alu_src_b,

    // Pipeline state
    output wire        valid_out,
    output wire        is_taken_out,
    output wire        is_mul_out_ex
);

    // -------------------------------------------------------------------------
    // ID/EX pipeline register
    // -------------------------------------------------------------------------
    wire [31:0] idex_pc;
    wire [31:0] idex_pc_plus_4;
    wire [31:0] idex_imm;
    wire [31:0] idex_rs1_data;
    wire [31:0] idex_rs2_data;
    wire [4:0]  idex_rs1_addr;
    wire [4:0]  idex_rs2_addr;
    wire [4:0]  idex_rd_addr;

    wire        idex_alu_src_a;
    wire [1:0]  idex_alu_src_b;
    wire [3:0]  idex_alu_op;
    wire        idex_is_branch;
    wire [2:0]  idex_branch_type;
    wire        idex_is_jump;
    wire [1:0]  idex_csr_op;
    wire        idex_csr_wdata_src;
    wire        idex_is_mret;
    wire [1:0]  idex_mul_op;
    wire [2:0]  idex_ex_result_src;

    wire        idex_mem_read;
    wire        idex_mem_write;
    wire [3:0]  idex_wen;
    wire [2:0]  idex_ld_select;
    wire        idex_reg_write;
    wire        idex_valid;
    wire [3:0] alu_op_effective = alu_op_override ? 4'b0000 : idex_alu_op;

    id_ex_reg u_id_ex_reg (
        .clk               (clk),
        .rst               (rst),
        .stall             (stall),
        .flush             (flush),

        .pc_in             (id_pc),
        .pc_plus_4_in      (id_pc_plus_4),
        .imm_in            (id_imm),
        .rs1_data_in       (id_rs1_data),
        .rs2_data_in       (id_rs2_data),
        .rs1_addr_in       (id_rs1_addr),
        .rs2_addr_in       (id_rs2_addr),
        .rd_addr_in        (id_rd_addr),

        .alu_src_a_in      (id_alu_src_a),
        .alu_src_b_in      (id_alu_src_b),
        .alu_op_in         (id_alu_op),
        .is_branch_in      (id_is_branch),
        .branch_type_in    (id_branch_type),
        .is_jump_in        (id_is_jump),
        .csr_op_in         (id_csr_op),
        .csr_wdata_src_in  (id_csr_wdata_src),
        .is_mret_in        (id_is_mret),
        .mul_op_in         (id_mul_op),
        .ex_result_src_in  (id_ex_result_src),

        .mem_read_in       (id_mem_read),
        .mem_write_in      (id_mem_write),
        .wen_in            (id_wen),
        .ld_select_in      (id_ld_select),

        .reg_write_in      (id_reg_write),

        .pc_out            (idex_pc),
        .pc_plus_4_out     (idex_pc_plus_4),
        .imm_out           (idex_imm),
        .rs1_data_out      (idex_rs1_data),
        .rs2_data_out      (idex_rs2_data),
        .rs1_addr_out      (idex_rs1_addr),
        .rs2_addr_out      (idex_rs2_addr),
        .rd_addr_out       (idex_rd_addr),

        .alu_src_a_out     (idex_alu_src_a),
        .alu_src_b_out     (idex_alu_src_b),
        .alu_op_out        (idex_alu_op),
        .is_branch_out     (idex_is_branch),
        .branch_type_out   (idex_branch_type),
        .is_jump_out       (idex_is_jump),
        .csr_op_out        (idex_csr_op),
        .csr_wdata_src_out (idex_csr_wdata_src),
        .is_mret_out       (idex_is_mret),
        .mul_op_out        (idex_mul_op),
        .ex_result_src_out (idex_ex_result_src),

        .mem_read_out      (idex_mem_read),
        .mem_write_out     (idex_mem_write),
        .wen_out           (idex_wen),
        .ld_select_out     (idex_ld_select),

        .reg_write_out     (idex_reg_write),
        .valid_out         (idex_valid)
    );

    // -------------------------------------------------------------------------
    // EX operand A mux (with forwarding)
    // -------------------------------------------------------------------------
    wire [31:0] alu_a;

    ex_alu_a_mux u_alu_a_mux (
        .sel            (alu_src_a_sel),
        .rs1_data       (idex_rs1_data),
        .pc             (idex_pc),
        .ex_mem1_fwd    (ex_mem1_fwd),
        .mem1_mem2_fwd  (mem1_mem2_fwd),
        .mem2_mem3_fwd  (mem2_mem3_fwd),
        .mask_unit_fwd  (mask_unit_fwd),
        .mem3_wb_fwd    (mem3_wb_fwd),
        .ex_mem1_pc_fwd  (ex_mem1_pc_fwd),
        .alu_a          (alu_a)
    );

    // -------------------------------------------------------------------------
    // EX operand B mux (with forwarding)
    // -------------------------------------------------------------------------
    wire [31:0] alu_b;

    ex_alu_b_mux u_alu_b_mux (
        .sel            (alu_src_b_sel),
        .rs2_data       (idex_rs2_data),
        .imm            (idex_imm),
        .ex_mem1_fwd    (ex_mem1_fwd),
        .mem1_mem2_fwd  (mem1_mem2_fwd),
        .mem2_mem3_fwd  (mem2_mem3_fwd),
        .mask_unit_fwd  (mask_unit_fwd),
        .mem3_wb_fwd    (mem3_wb_fwd),
        .csr_read       (csr_rdata_in),
        .alu_b          (alu_b)
    );

    // -------------------------------------------------------------------------
    // Store data mux (with forwarding)
    // -------------------------------------------------------------------------
    wire [31:0] store_data;

    store_data_mux u_store_data_mux (
        .sel            (str_data_mux_sel),
        .rs2_data       (idex_rs2_data),
        .ex_mem1_fwd    (ex_mem1_fwd),
        .mem1_mem2_fwd  (mem1_mem2_fwd),
        .mem2_mem3_fwd  (mem2_mem3_fwd),
        .mask_unit_fwd  (mask_unit_fwd),
        .mem3_wb_fwd    (mem3_wb_fwd),
        .store_data     (store_data)
    );

    // -------------------------------------------------------------------------
    // ALU
    // -------------------------------------------------------------------------
    wire [31:0] alu_out;
    wire        alu_z;
    wire        alu_n;
    wire        alu_v;
    wire        alu_c;

    alu u_alu (
        .alu_op  (alu_op_effective),
        .a       (alu_a),
        .b       (alu_b),
        .alu_out (alu_out),
        .flag_z  (alu_z),
        .flag_n  (alu_n),
        .flag_v  (alu_v),
        .flag_c  (alu_c)
    );

    // -------------------------------------------------------------------------
    // Multiplier
    // -------------------------------------------------------------------------
    wire [31:0] mul_low;
    wire [31:0] mul_high;

    multiplier u_multiplier (
        .mul_op   (idex_mul_op),
        .a        (alu_a),
        .b        (alu_b),
        .mul_low  (mul_low),
        .mul_high (mul_high)
    );

    // -------------------------------------------------------------------------
    // Branch comparator (output not consumed yet - placeholder for hazard unit)
    // -------------------------------------------------------------------------
    wire is_taken;

    branch_comparator u_branch_comparator (
        .is_branch   (idex_is_branch),
        .branch_type (idex_branch_type),
        .flag_z      (alu_z),
        .flag_n      (alu_n),
        .flag_v      (alu_v),
        .flag_c      (alu_c),
        .is_taken    (is_taken)
    );

    // -------------------------------------------------------------------------
    // CSR write data mux (drives csr_wdata to top-level CSR file)
    // -------------------------------------------------------------------------
    wire [31:0] csr_write_data;

    csr_wdata_mux u_csr_wdata_mux (
        .sel       (idex_csr_wdata_src),
        .rs1_fwd   (alu_a),
        .alu_out   (alu_out),
        .csr_wdata (csr_write_data)
    );

    // -------------------------------------------------------------------------
    // EX result mux
    // -------------------------------------------------------------------------
    wire [31:0] ex_result;

    ex_result_mux u_ex_result_mux (
        .sel       (idex_ex_result_src),
        .alu_out   (alu_out),
        .imm       (idex_imm),
        .csr_read  (csr_rdata_in),
        .pc_plus_4 (idex_pc_plus_4),
        .mul_low   (mul_low),
        .mul_high  (mul_high),
        .ex_result (ex_result)
    );

    // -------------------------------------------------------------------------
    // CSR interface outputs
    // -------------------------------------------------------------------------
    assign csr_addr_out  = idex_imm[11:0];
    assign csr_wen_out   = (idex_csr_op != 2'b00) && idex_valid;
    assign csr_wdata_out = csr_write_data;

    // -------------------------------------------------------------------------
    // MRET signal exposure
    // -------------------------------------------------------------------------
    assign is_mret_out_ex = idex_is_mret;
    // -------------------------------------------------------------------------
    // Output assignments
    // -------------------------------------------------------------------------
    assign pc_out          = idex_pc;
    assign ex_result_out   = ex_result;
    assign branch_addr_out = alu_out;          // placeholder; computed at MEM1
    assign store_data_out  = store_data;
    assign rd_addr_out     = idex_rd_addr;

    assign mem_read_out    = idex_mem_read;
    assign mem_write_out   = idex_mem_write;
    assign wen_out         = idex_wen;
    assign is_branch_out   = idex_is_branch;
    assign is_jump_out     = idex_is_jump;
    assign ld_select_out   = idex_ld_select;
    assign reg_write_out   = idex_reg_write;

    assign id_ex_rs1_addr  = idex_rs1_addr;
    assign id_ex_rs2_addr  = idex_rs2_addr;
    assign id_ex_alu_src_a = idex_alu_src_a;
    assign id_ex_alu_src_b = idex_alu_src_b;

    assign valid_out       = idex_valid;
    assign is_taken_out    = is_taken;
    assign is_mul_out_ex   = (idex_mul_op != 2'b00) && idex_valid;
endmodule