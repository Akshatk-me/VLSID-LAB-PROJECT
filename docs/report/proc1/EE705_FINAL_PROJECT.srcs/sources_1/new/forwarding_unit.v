// =============================================================================
// forwarding_unit.v
// Combinational forwarding unit for the 7-stage RV32IM pipeline.
//
// Branch override: when a taken branch is at EX/MEM1, the EX-stage ALU is
// hijacked to compute the branch target (pc + imm). The forwarding unit
// overrides alu_src_a_sel, alu_src_b_sel, and forces alu_op = ADD.
// The EX-stage instruction's normal ALU result is discarded (it gets flushed
// by the hazard unit during branch resolution).
//
// Mux select encodings:
//   alu_src_a_sel:
//     000 = rs1_data        001 = pc
//     010 = ex_mem1_fwd     011 = mem1_mem2_fwd
//     100 = mem2_mem3_fwd   101 = mask_unit_fwd
//     110 = mem3_wb_fwd     111 = ex_mem1_pc_fwd  (branch override)
//
//   alu_src_b_sel:
//     000 = rs2_data        001 = imm
//     010 = ex_mem1_fwd     011 = mem1_mem2_fwd
//     100 = mem2_mem3_fwd   101 = mask_unit_fwd
//     110 = mem3_wb_fwd     111 = csr_read
// =============================================================================

module forwarding_unit (
    // ----- Consumer addresses -----
    input  wire [4:0] if_id_rs1,
    input  wire [4:0] if_id_rs2,
    input  wire [4:0] id_ex_rs1,
    input  wire [4:0] id_ex_rs2,

    // ----- Control unit choices for EX operand muxes -----
    input  wire       id_ex_alu_src_a,
    input  wire [1:0] id_ex_alu_src_b,

    // ----- Producer info: EX/MEM1 -----
    input  wire [4:0] ex_mem1_rd,
    input  wire       ex_mem1_reg_write,
    input  wire       ex_mem1_mem_read,
    input  wire       ex_mem1_is_branch,
    input  wire       ex_mem1_is_taken,

    // ----- Producer info: MEM1/MEM2 -----
    input  wire [4:0] mem1_mem2_rd,
    input  wire       mem1_mem2_reg_write,
    input  wire       mem1_mem2_mem_read,

    // ----- Producer info: MEM2/MEM3 -----
    input  wire [4:0] mem2_mem3_rd,
    input  wire       mem2_mem3_reg_write,
    input  wire       mem2_mem3_mem_read,

    // ----- Producer info: MEM3/WB -----
    input  wire [4:0] mem3_wb_rd,
    input  wire       mem3_wb_reg_write,

    // ----- Mux selects (outputs to datapath) -----
    output reg        id_rs1_fwd_sel,
    output reg        id_rs2_fwd_sel,
    output reg  [2:0] alu_src_a_sel,
    output reg  [2:0] alu_src_b_sel,
    output reg  [2:0] str_data_mux_sel,

    // ----- Branch override outputs -----
    output wire       alu_op_override,

    // ----- Dependency map (outputs to hazard unit) -----
    output reg        if_id_rs1_dep,
    output reg        if_id_rs2_dep,
    output reg  [3:0] id_ex_rs1_dep,
    output reg  [3:0] id_ex_rs2_dep
);

    // -------------------------------------------------------------------------
    // Branch override detection
    // When a taken branch is at EX/MEM1, hijack the EX-stage ALU to compute
    // the branch target (pc + imm).
    // -------------------------------------------------------------------------
    wire branch_override = ex_mem1_is_branch && ex_mem1_is_taken;
    assign alu_op_override = branch_override;

    // -------------------------------------------------------------------------
    // Per-stage match signals
    // -------------------------------------------------------------------------
    wire id_rs1_match_wb = (mem3_wb_rd == if_id_rs1) &&
                            mem3_wb_reg_write && (mem3_wb_rd != 5'd0);
    wire id_rs2_match_wb = (mem3_wb_rd == if_id_rs2) &&
                            mem3_wb_reg_write && (mem3_wb_rd != 5'd0);

    wire id_rs1_shadowed =
        ((ex_mem1_rd   == if_id_rs1) && ex_mem1_reg_write   && (ex_mem1_rd   != 5'd0)) ||
        ((mem1_mem2_rd == if_id_rs1) && mem1_mem2_reg_write && (mem1_mem2_rd != 5'd0)) ||
        ((mem2_mem3_rd == if_id_rs1) && mem2_mem3_reg_write && (mem2_mem3_rd != 5'd0));
    wire id_rs2_shadowed =
        ((ex_mem1_rd   == if_id_rs2) && ex_mem1_reg_write   && (ex_mem1_rd   != 5'd0)) ||
        ((mem1_mem2_rd == if_id_rs2) && mem1_mem2_reg_write && (mem1_mem2_rd != 5'd0)) ||
        ((mem2_mem3_rd == if_id_rs2) && mem2_mem3_reg_write && (mem2_mem3_rd != 5'd0));

    wire ex_rs1_match_em1 = (ex_mem1_rd   == id_ex_rs1) &&
                             ex_mem1_reg_write   && (ex_mem1_rd   != 5'd0);
    wire ex_rs1_match_m12 = (mem1_mem2_rd == id_ex_rs1) &&
                             mem1_mem2_reg_write && (mem1_mem2_rd != 5'd0);
    wire ex_rs1_match_m23 = (mem2_mem3_rd == id_ex_rs1) &&
                             mem2_mem3_reg_write && (mem2_mem3_rd != 5'd0);
    wire ex_rs1_match_m3w = (mem3_wb_rd   == id_ex_rs1) &&
                             mem3_wb_reg_write   && (mem3_wb_rd   != 5'd0);

    wire ex_rs2_match_em1 = (ex_mem1_rd   == id_ex_rs2) &&
                             ex_mem1_reg_write   && (ex_mem1_rd   != 5'd0);
    wire ex_rs2_match_m12 = (mem1_mem2_rd == id_ex_rs2) &&
                             mem1_mem2_reg_write && (mem1_mem2_rd != 5'd0);
    wire ex_rs2_match_m23 = (mem2_mem3_rd == id_ex_rs2) &&
                             mem2_mem3_reg_write && (mem2_mem3_rd != 5'd0);
    wire ex_rs2_match_m3w = (mem3_wb_rd   == id_ex_rs2) &&
                             mem3_wb_reg_write   && (mem3_wb_rd   != 5'd0);

    // -------------------------------------------------------------------------
    // ID-stage mux selects
    // -------------------------------------------------------------------------
    always @(*) begin
        id_rs1_fwd_sel = (id_rs1_match_wb && !id_rs1_shadowed) ? 1'b1 : 1'b0;
        id_rs2_fwd_sel = (id_rs2_match_wb && !id_rs2_shadowed) ? 1'b1 : 1'b0;
    end

    always @(*) begin
        if_id_rs1_dep = id_rs1_match_wb;
        if_id_rs2_dep = id_rs2_match_wb;
    end

    // -------------------------------------------------------------------------
    // EX-stage rs1 / rs2 source codes (normal forwarding)
    // -------------------------------------------------------------------------
    reg [2:0] rs1_src_code;
    always @(*) begin
        if (ex_rs1_match_em1) begin
            rs1_src_code = 3'b010;
        end else if (ex_rs1_match_m12) begin
            rs1_src_code = 3'b011;
        end else if (ex_rs1_match_m23) begin
            rs1_src_code = mem2_mem3_mem_read ? 3'b101 : 3'b100;
        end else if (ex_rs1_match_m3w) begin
            rs1_src_code = 3'b110;
        end else begin
            rs1_src_code = 3'b000;
        end
    end

    reg [2:0] rs2_src_code;
    always @(*) begin
        if (ex_rs2_match_em1) begin
            rs2_src_code = 3'b010;
        end else if (ex_rs2_match_m12) begin
            rs2_src_code = 3'b011;
        end else if (ex_rs2_match_m23) begin
            rs2_src_code = mem2_mem3_mem_read ? 3'b101 : 3'b100;
        end else if (ex_rs2_match_m3w) begin
            rs2_src_code = 3'b110;
        end else begin
            rs2_src_code = 3'b000;
        end
    end

    // -------------------------------------------------------------------------
    // Final alu_src_a_sel  (with branch override)
    // -------------------------------------------------------------------------
    always @(*) begin
        if (branch_override) begin
            alu_src_a_sel = 3'b111;  // ex_mem1_pc_fwd
        end else if (id_ex_alu_src_a == 1'b1) begin
            alu_src_a_sel = 3'b001;  // PC
        end else begin
            alu_src_a_sel = rs1_src_code;
        end
    end

    // -------------------------------------------------------------------------
    // Final alu_src_b_sel  (with branch override)
    // -------------------------------------------------------------------------
    always @(*) begin
        if (branch_override) begin
            alu_src_b_sel = 3'b010;  // ex_mem1_fwd (= imm via ex_result field)
        end else begin
            case (id_ex_alu_src_b)
                2'b00:   alu_src_b_sel = rs2_src_code;
                2'b01:   alu_src_b_sel = 3'b001;
                2'b10:   alu_src_b_sel = 3'b111;
                default: alu_src_b_sel = rs2_src_code;
            endcase
        end
    end

    // -------------------------------------------------------------------------
    // Store data mux select
    // -------------------------------------------------------------------------
    always @(*) begin
        str_data_mux_sel = rs2_src_code;
    end

    // -------------------------------------------------------------------------
    // EX-stage dependency map
    // -------------------------------------------------------------------------
    always @(*) begin
        if (ex_rs1_match_em1) begin
            id_ex_rs1_dep = {1'b1, 2'b00, ex_mem1_mem_read};
        end else if (ex_rs1_match_m12) begin
            id_ex_rs1_dep = {1'b1, 2'b01, mem1_mem2_mem_read};
        end else if (ex_rs1_match_m23) begin
            id_ex_rs1_dep = {1'b1, 2'b10, mem2_mem3_mem_read};
        end else if (ex_rs1_match_m3w) begin
            id_ex_rs1_dep = {1'b1, 2'b11, 1'b0};
        end else begin
            id_ex_rs1_dep = 4'b0000;
        end
    end

    always @(*) begin
        if (ex_rs2_match_em1) begin
            id_ex_rs2_dep = {1'b1, 2'b00, ex_mem1_mem_read};
        end else if (ex_rs2_match_m12) begin
            id_ex_rs2_dep = {1'b1, 2'b01, mem1_mem2_mem_read};
        end else if (ex_rs2_match_m23) begin
            id_ex_rs2_dep = {1'b1, 2'b10, mem2_mem3_mem_read};
        end else if (ex_rs2_match_m3w) begin
            id_ex_rs2_dep = {1'b1, 2'b11, 1'b0};
        end else begin
            id_ex_rs2_dep = 4'b0000;
        end
    end

endmodule