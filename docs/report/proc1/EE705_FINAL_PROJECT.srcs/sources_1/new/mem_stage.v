// =============================================================================
// mem_stage.v
// MEM-stage submodule.
// Contains: ex_mem1_reg, mem1_mem2_reg, mem2_mem3_reg, load_mask_unit, mem3_wb_mux
//
// BRAM is at top level (accessed via memory arbiter). This stage exposes
// memory request signals (addr, wdata, wen, read/write strobes) and takes
// the response data as an input.
//
// Branch handling: branch_addr_update input is exposed for the hazard unit
// to override the EX/MEM1 branch_addr field while the rest of the register
// is stalled (BRANCH_CYCLE1).
// =============================================================================

module mem_stage (
    input  wire        clk,
    input  wire        rst,

    // Hazard unit per-register stall/flush
    input  wire        ex_mem1_stall,
    input  wire        ex_mem1_flush,
    input  wire        ex_mem1_branch_addr_update,
    input  wire        mem1_mem2_stall,
    input  wire        mem1_mem2_flush,
    input  wire        mem2_mem3_stall,
    input  wire        mem2_mem3_flush,

    // ----- EX-stage data inputs -----
    input  wire [31:0] ex_pc,
    input  wire [31:0] ex_result,
    input  wire [31:0] ex_branch_addr,
    input  wire [31:0] ex_store_data,
    input  wire [4:0]  ex_rd_addr,

    // ----- EX-stage MEM control inputs -----
    input  wire        ex_mem_read,
    input  wire        ex_mem_write,
    input  wire [3:0]  ex_wen,
    input  wire        ex_is_branch,
    input  wire        ex_is_jump,
    input  wire [2:0]  ex_ld_select,
    input  wire        ex_reg_write,
    input  wire        ex_is_taken,

    // ----- Memory interface (to arbiter / BRAM via top level) -----
    output wire [31:0] mem_req_addr,
    output wire [31:0] mem_req_wdata,
    output wire [3:0]  mem_req_wen,
    output wire        mem_req_mem_read,
    output wire        mem_req_mem_write,
    input  wire [31:0] mem_resp_data,

    // ----- Outputs to WB submodule -----
    output wire [31:0] wb_in_write_data,
    output wire [4:0]  wb_in_rd_addr,
    output wire [31:0] wb_in_pc,
    output wire        wb_in_reg_write,

    // ----- Forwarding sources to EX-stage muxes -----
    output wire [31:0] ex_mem1_fwd,
    output wire [31:0] mem1_mem2_fwd,
    output wire [31:0] mem2_mem3_fwd,
    output wire [31:0] mask_unit_fwd,

    // ----- Producer info for forwarding unit -----
    output wire [4:0]  ex_mem1_rd_addr,
    output wire        ex_mem1_reg_write,
    output wire        ex_mem1_mem_read,

    output wire [4:0]  mem1_mem2_rd_addr,
    output wire        mem1_mem2_reg_write,
    output wire        mem1_mem2_mem_read,

    output wire [4:0]  mem2_mem3_rd_addr,
    output wire        mem2_mem3_reg_write,
    output wire        mem2_mem3_mem_read,

    // ----- Visibility to hazard unit -----
    output wire [31:0] ex_mem1_pc,
    output wire        ex_mem1_is_branch,
    output wire        ex_mem1_is_jump,
    output wire        ex_mem1_mem_write_out,
    output wire [31:0] ex_mem1_branch_addr,
    output wire        ex_mem1_valid,

    output wire [31:0] mem1_mem2_pc,
    output wire        mem1_mem2_valid,

    output wire [31:0] mem2_mem3_pc,
    output wire        mem2_mem3_valid,
    output wire        ex_mem1_is_taken
);

    // -------------------------------------------------------------------------
    // EX/MEM1 register
    // -------------------------------------------------------------------------
    wire [31:0] em1_pc;
    wire [31:0] em1_ex_result;
    wire [31:0] em1_branch_addr;
    wire [31:0] em1_store_data;
    wire [4:0]  em1_rd_addr;
    wire        em1_mem_read;
    wire        em1_mem_write;
    wire [3:0]  em1_wen;
    wire        em1_is_branch;
    wire        em1_is_jump;
    wire [2:0]  em1_ld_select;
    wire        em1_reg_write;
    wire        em1_valid;
    wire        em1_is_taken;

    ex_mem1_reg u_ex_mem1_reg (
        .clk                (clk),
        .rst                (rst),
        .stall              (ex_mem1_stall),
        .flush              (ex_mem1_flush),
        .branch_addr_update (ex_mem1_branch_addr_update),

        .pc_in           (ex_pc),
        .ex_result_in    (ex_result),
        .branch_addr_in  (ex_branch_addr),
        .store_data_in   (ex_store_data),
        .rd_addr_in      (ex_rd_addr),
        .mem_read_in     (ex_mem_read),
        .mem_write_in    (ex_mem_write),
        .wen_in          (ex_wen),
        .is_branch_in    (ex_is_branch),
        .is_jump_in      (ex_is_jump),
        .ld_select_in    (ex_ld_select),
        .reg_write_in    (ex_reg_write),

        .pc_out          (em1_pc),
        .ex_result_out   (em1_ex_result),
        .branch_addr_out (em1_branch_addr),
        .store_data_out  (em1_store_data),
        .rd_addr_out     (em1_rd_addr),
        .mem_read_out    (em1_mem_read),
        .mem_write_out   (em1_mem_write),
        .wen_out         (em1_wen),
        .is_branch_out   (em1_is_branch),
        .is_jump_out     (em1_is_jump),
        .ld_select_out   (em1_ld_select),
        .reg_write_out   (em1_reg_write),
        .is_taken_in    (ex_is_taken),
        .is_taken_out   (em1_is_taken),
        .valid_out       (em1_valid)
    );

    // -------------------------------------------------------------------------
    // Memory request to arbiter (drive from EX/MEM1)
    // -------------------------------------------------------------------------
    assign mem_req_addr      = em1_ex_result;
    assign mem_req_wdata     = em1_store_data;
    assign mem_req_wen       = em1_mem_write ? em1_wen : 4'b0000;
    assign mem_req_mem_read  = em1_mem_read;
    assign mem_req_mem_write = em1_mem_write;

    // -------------------------------------------------------------------------
    // MEM1/MEM2 register
    // -------------------------------------------------------------------------
    wire [31:0] m12_pc;
    wire [31:0] m12_ex_result;
    wire [4:0]  m12_rd_addr;
    wire        m12_mem_read;
    wire [2:0]  m12_ld_select;
    wire        m12_reg_write;
    wire        m12_valid;

    mem1_mem2_reg u_mem1_mem2_reg (
        .clk           (clk),
        .rst           (rst),
        .stall         (mem1_mem2_stall),
        .flush         (mem1_mem2_flush),

        .pc_in         (em1_pc),
        .ex_result_in  (em1_ex_result),
        .rd_addr_in    (em1_rd_addr),
        .mem_read_in   (em1_mem_read),
        .ld_select_in  (em1_ld_select),
        .reg_write_in  (em1_reg_write),

        .pc_out        (m12_pc),
        .ex_result_out (m12_ex_result),
        .rd_addr_out   (m12_rd_addr),
        .mem_read_out  (m12_mem_read),
        .ld_select_out (m12_ld_select),
        .reg_write_out (m12_reg_write),
        .valid_out     (m12_valid)
    );

    // -------------------------------------------------------------------------
    // MEM2/MEM3 register
    // -------------------------------------------------------------------------
    wire [31:0] m23_pc;
    wire [31:0] m23_ex_result;
    wire [4:0]  m23_rd_addr;
    wire        m23_mem_read;
    wire [2:0]  m23_ld_select;
    wire        m23_reg_write;
    wire        m23_valid;

    mem2_mem3_reg u_mem2_mem3_reg (
        .clk           (clk),
        .rst           (rst),
        .stall         (mem2_mem3_stall),
        .flush         (mem2_mem3_flush),

        .pc_in         (m12_pc),
        .ex_result_in  (m12_ex_result),
        .rd_addr_in    (m12_rd_addr),
        .mem_read_in   (m12_mem_read),
        .ld_select_in  (m12_ld_select),
        .reg_write_in  (m12_reg_write),

        .pc_out        (m23_pc),
        .ex_result_out (m23_ex_result),
        .rd_addr_out   (m23_rd_addr),
        .mem_read_out  (m23_mem_read),
        .ld_select_out (m23_ld_select),
        .reg_write_out (m23_reg_write),
        .valid_out     (m23_valid)
    );

    // -------------------------------------------------------------------------
    // Load mask unit (uses memory response data from arbiter)
    // -------------------------------------------------------------------------
    wire [31:0] load_data;

    load_mask_unit u_load_mask_unit (
        .raw_data  (mem_resp_data),
        .addr_low  (m23_ex_result[1:0]),
        .ld_select (m23_ld_select),
        .load_data (load_data)
    );

    // -------------------------------------------------------------------------
    // MEM3 writeback mux
    // -------------------------------------------------------------------------
    wire [31:0] mem3_write_data;

    mem3_wb_mux u_mem3_wb_mux (
        .sel        (m23_mem_read),
        .ex_result  (m23_ex_result),
        .load_data  (load_data),
        .write_data (mem3_write_data)
    );

    // -------------------------------------------------------------------------
    // Output assignments
    // -------------------------------------------------------------------------

    // To WB submodule
    assign wb_in_write_data = mem3_write_data;
    assign wb_in_rd_addr    = m23_rd_addr;
    assign wb_in_pc         = m23_pc;
    assign wb_in_reg_write  = m23_reg_write;

    // Forwarding sources
    assign ex_mem1_fwd   = em1_ex_result;
    assign mem1_mem2_fwd = m12_ex_result;
    assign mem2_mem3_fwd = m23_ex_result;
    assign mask_unit_fwd = load_data;

    // Producer info for forwarding unit
    assign ex_mem1_rd_addr     = em1_rd_addr;
    assign ex_mem1_reg_write   = em1_reg_write;
    assign ex_mem1_mem_read    = em1_mem_read;

    assign mem1_mem2_rd_addr   = m12_rd_addr;
    assign mem1_mem2_reg_write = m12_reg_write;
    assign mem1_mem2_mem_read  = m12_mem_read;

    assign mem2_mem3_rd_addr   = m23_rd_addr;
    assign mem2_mem3_reg_write = m23_reg_write;
    assign mem2_mem3_mem_read  = m23_mem_read;

    // Hazard unit visibility
    assign ex_mem1_pc           = em1_pc;
    assign ex_mem1_is_branch    = em1_is_branch;
    assign ex_mem1_is_jump      = em1_is_jump;
    assign ex_mem1_mem_write_out = em1_mem_write;
    assign ex_mem1_branch_addr  = em1_branch_addr;
    assign ex_mem1_valid        = em1_valid;

    assign mem1_mem2_pc         = m12_pc;
    assign mem1_mem2_valid      = m12_valid;

    assign mem2_mem3_pc         = m23_pc;
    assign mem2_mem3_valid      = m23_valid;
    assign ex_mem1_is_taken     = em1_is_taken;

endmodule