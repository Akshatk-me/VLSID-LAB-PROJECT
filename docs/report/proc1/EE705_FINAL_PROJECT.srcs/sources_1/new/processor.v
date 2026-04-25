// =============================================================================
// processor.v
// Top-level RV32IM processor.
// Instantiates: fetch_unit, memory_subsystem, datapath, control_plane
// =============================================================================

module processor (
    input  wire        clk,
    input  wire        rst,

    // External peripheral events (testbench-driven)
    input  wire        uart_rx_event,
    input  wire [7:0]  uart_rx_event_data,
    input  wire [3:0]  gpio_pin_event,
    input  wire [3:0]  gpio_pin_state,

    // Observation outputs (minimal for now)
    // Writeback observation outputs
    output wire [31:0] wb_rd_data,
    output wire [4:0]  wb_rd_addr,
    output wire        wb_reg_write,
    output wire [31:0] wb_pc,
    output wire        wb_valid
);

    // -------------------------------------------------------------------------
    // Front end <-> memory subsystem
    // -------------------------------------------------------------------------
    wire [31:0] fetch_addr;
    wire [31:0] fetch_data;

    // -------------------------------------------------------------------------
    // Front end <-> datapath
    // -------------------------------------------------------------------------
    wire [31:0] head_pc;
    wire [31:0] head_pc_plus_4;
    wire [31:0] head_instr;

    // -------------------------------------------------------------------------
    // Front end <-> control plane
    // -------------------------------------------------------------------------
    wire        fetch_stall;
    wire        fetch_flush;
    wire [1:0]  pc_sel;
    wire [31:0] mtvec_value;
    wire [31:0] mepc_value;
    wire [31:0] branch_addr_value;

    // -------------------------------------------------------------------------
    // Datapath <-> memory subsystem
    // -------------------------------------------------------------------------
    wire [31:0] mem_req_addr;
    wire [31:0] mem_req_wdata;
    wire [3:0]  mem_req_wen;
    wire        mem_req_mem_read;
    wire        mem_req_mem_write;
    wire [31:0] mem_resp_data;

    // -------------------------------------------------------------------------
    // Datapath <-> control plane: CSR interface
    // -------------------------------------------------------------------------
    wire [11:0] csr_addr;
    wire        csr_wen;
    wire [31:0] csr_wdata;
    wire [31:0] csr_rdata;

    // -------------------------------------------------------------------------
    // Datapath -> control plane: pipeline visibility
    // -------------------------------------------------------------------------
    wire        if_id_valid_w;
    wire [31:0] if_id_pc_w;
    wire        id_ex_valid_w;
    wire [31:0] id_ex_pc_w;
    wire        id_ex_is_mret_w;
    wire [3:0]  id_ex_rs1_dep_w;
    wire [3:0]  id_ex_rs2_dep_w;
    wire        ex_mem1_valid_w;
    wire [31:0] ex_mem1_pc_w;
    wire        ex_mem1_is_branch_w;
    wire        ex_mem1_is_jump_w;
    wire        ex_mem1_is_taken_w;
    wire        ex_mem1_mem_read_w;
    wire        ex_mem1_mem_write_w;
    wire [31:0] ex_mem1_branch_addr_w;
    wire        mem1_mem2_valid_w;
    wire [31:0] mem1_mem2_pc_w;
    wire        mem2_mem3_valid_w;
    wire [31:0] mem2_mem3_pc_w;
    wire        wb_valid_w;
    wire [31:0] wb_rd_data_w;
    wire [4:0]  wb_rd_addr_w;
    wire        wb_reg_write_w;
    wire [31:0] wb_pc_w;
    
    // -------------------------------------------------------------------------
    // Control plane -> datapath: per-stage stall/flush
    // -------------------------------------------------------------------------
    wire if_id_stall_w;
    wire if_id_flush_w;
    wire id_ex_stall_w;
    wire id_ex_flush_w;
    wire ex_mem1_stall_w;
    wire ex_mem1_flush_w;
    wire ex_mem1_branch_addr_update_w;
    wire mem1_mem2_stall_w;
    wire mem1_mem2_flush_w;
    wire mem2_mem3_stall_w;
    wire mem2_mem3_flush_w;

    // -------------------------------------------------------------------------
    // Memory subsystem <-> control plane
    // -------------------------------------------------------------------------
    wire        accel_busy;
    wire [4:0]  irq_lines;
    wire        id_ex_is_mul_w;

    // -------------------------------------------------------------------------
    // Fetch unit (front end)
    // -------------------------------------------------------------------------
    fetch_unit u_fetch_unit (
        .clk            (clk),
        .rst            (rst),

        .stall          (fetch_stall),
        .flush          (fetch_flush),
        .pc_sel         (pc_sel),
        .branch_addr    (branch_addr_value),
        .mtvec          (mtvec_value),
        .mepc           (mepc_value),
        .q_pop     (!if_id_stall_w),              // always consume; no IF/ID handshake yet

        .mem_req_pc     (fetch_addr),
        .mem_resp_instr (fetch_data),

        .head_pc        (head_pc),
        .head_pc_plus_4 (head_pc_plus_4),
        .head_instr     (head_instr),

        .pc_current     ()                    // unused
    );

    // -------------------------------------------------------------------------
    // Memory subsystem
    // -------------------------------------------------------------------------
    memory_subsystem u_memory_subsystem (
        .clk                   (clk),
        .rst                   (rst),

        .fetch_addr            (fetch_addr),
        .fetch_data            (fetch_data),

        .cpu_addr              (mem_req_addr),
        .cpu_wdata             (mem_req_wdata),
        .cpu_wen               (mem_req_wen),
        .cpu_mem_read          (mem_req_mem_read),
        .cpu_mem_write         (mem_req_mem_write),
        .cpu_rdata             (mem_resp_data),

        .accel_busy            (accel_busy),

        .irq_lines             (irq_lines),

        .uart_rx_event         (uart_rx_event),
        .uart_rx_event_data    (uart_rx_event_data),
        .gpio_pin_event        (gpio_pin_event),
        .gpio_pin_state        (gpio_pin_state)
    );

    // -------------------------------------------------------------------------
    // Datapath
    // -------------------------------------------------------------------------
    datapath u_datapath (
        .clk                        (clk),
        .rst                        (rst),

        .if_pc_in                   (head_pc),
        .if_pc_plus_4_in            (head_pc_plus_4),
        .if_instr_in                (head_instr),

        .if_id_stall                (if_id_stall_w),
        .if_id_flush                (if_id_flush_w),
        .id_ex_stall                (id_ex_stall_w),
        .id_ex_flush                (id_ex_flush_w),
        .ex_mem1_stall              (ex_mem1_stall_w),
        .ex_mem1_flush              (ex_mem1_flush_w),
        .ex_mem1_branch_addr_update (ex_mem1_branch_addr_update_w),
        .mem1_mem2_stall            (mem1_mem2_stall_w),
        .mem1_mem2_flush            (mem1_mem2_flush_w),
        .mem2_mem3_stall            (mem2_mem3_stall_w),
        .mem2_mem3_flush            (mem2_mem3_flush_w),
        .id_ex_is_mul_out           (id_ex_is_mul_w),
        .csr_addr                   (csr_addr),
        .csr_wen                    (csr_wen),
        .csr_wdata                  (csr_wdata),
        .csr_rdata                  (csr_rdata),

        .mem_req_addr               (mem_req_addr),
        .mem_req_wdata              (mem_req_wdata),
        .mem_req_wen                (mem_req_wen),
        .mem_req_mem_read           (mem_req_mem_read),
        .mem_req_mem_write          (mem_req_mem_write),
        .mem_resp_data              (mem_resp_data),

        .if_id_valid_out            (if_id_valid_w),
        .if_id_pc_out               (if_id_pc_w),

        .id_ex_valid_out            (id_ex_valid_w),
        .id_ex_pc_out               (id_ex_pc_w),
        .id_ex_is_mret_out          (id_ex_is_mret_w),
        .id_ex_rs1_dep_out          (id_ex_rs1_dep_w),
        .id_ex_rs2_dep_out          (id_ex_rs2_dep_w),

        .ex_mem1_valid_out          (ex_mem1_valid_w),
        .ex_mem1_pc_out             (ex_mem1_pc_w),
        .ex_mem1_is_branch_out      (ex_mem1_is_branch_w),
        .ex_mem1_is_jump_out        (ex_mem1_is_jump_w),
        .ex_mem1_is_taken_out       (ex_mem1_is_taken_w),
        .ex_mem1_mem_read_out       (ex_mem1_mem_read_w),
        .ex_mem1_mem_write_out      (ex_mem1_mem_write_w),
        .ex_mem1_branch_addr_out    (ex_mem1_branch_addr_w),

        .mem1_mem2_valid_out        (mem1_mem2_valid_w),
        .mem1_mem2_pc_out           (mem1_mem2_pc_w),

        .mem2_mem3_valid_out        (mem2_mem3_valid_w),
        .mem2_mem3_pc_out           (mem2_mem3_pc_w),
        
        .wb_rd_data_out   (wb_rd_data_w),
        .wb_rd_addr_out   (wb_rd_addr_w),
        .wb_reg_write_out (wb_reg_write_w),
        .wb_pc_out        (wb_pc_w),

        .wb_valid_out               (wb_valid_w)
    );

    // -------------------------------------------------------------------------
    // Control plane
    // -------------------------------------------------------------------------
    control_plane u_control_plane (
        .clk                        (clk),
        .rst                        (rst),

        .if_id_valid                (if_id_valid_w),
        .if_id_pc                   (if_id_pc_w),

        .id_ex_valid                (id_ex_valid_w),
        .id_ex_pc                   (id_ex_pc_w),
        .id_ex_is_mret              (id_ex_is_mret_w),
        .id_ex_rs1_dep              (id_ex_rs1_dep_w),
        .id_ex_rs2_dep              (id_ex_rs2_dep_w),

        .ex_mem1_valid              (ex_mem1_valid_w),
        .ex_mem1_pc                 (ex_mem1_pc_w),
        .ex_mem1_is_branch          (ex_mem1_is_branch_w),
        .ex_mem1_is_jump            (ex_mem1_is_jump_w),
        .ex_mem1_is_taken           (ex_mem1_is_taken_w),
        .ex_mem1_mem_read           (ex_mem1_mem_read_w),
        .ex_mem1_mem_write          (ex_mem1_mem_write_w),
        .ex_mem1_branch_addr        (ex_mem1_branch_addr_w),

        .mem1_mem2_valid            (mem1_mem2_valid_w),
        .mem1_mem2_pc               (mem1_mem2_pc_w),

        .mem2_mem3_valid            (mem2_mem3_valid_w),
        .mem2_mem3_pc               (mem2_mem3_pc_w),

        .wb_valid                   (wb_valid_w),

        .csr_addr                   (csr_addr),
        .csr_wen                    (csr_wen),
        .csr_wdata                  (csr_wdata),
        .csr_rdata                  (csr_rdata),

        .id_ex_is_mul               (id_ex_is_mul_w),
        .irq_lines                  (irq_lines),
        .accel_busy                 (accel_busy),

        .if_id_stall                (if_id_stall_w),
        .if_id_flush                (if_id_flush_w),
        .id_ex_stall                (id_ex_stall_w),
        .id_ex_flush                (id_ex_flush_w),
        .ex_mem1_stall              (ex_mem1_stall_w),
        .ex_mem1_flush              (ex_mem1_flush_w),
        .ex_mem1_branch_addr_update (ex_mem1_branch_addr_update_w),
        .mem1_mem2_stall            (mem1_mem2_stall_w),
        .mem1_mem2_flush            (mem1_mem2_flush_w),
        .mem2_mem3_stall            (mem2_mem3_stall_w),
        .mem2_mem3_flush            (mem2_mem3_flush_w),

        .fetch_stall                (fetch_stall),
        .fetch_flush                (fetch_flush),
        .pc_sel                     (pc_sel),
        .mtvec_out                  (mtvec_value),
        .mepc_out                   (mepc_value),
        .branch_addr_out            (branch_addr_value)
    );

    // -------------------------------------------------------------------------
    // Top-level observation outputs (minimal)
    // -------------------------------------------------------------------------
    assign wb_valid = wb_valid_w;
    assign wb_pc    = wb_pc_w;  // approximate WB PC; will refine when wb_pc is exposed properly
    assign wb_rd_data   = wb_rd_data_w;
    assign wb_rd_addr   = wb_rd_addr_w;
    assign wb_reg_write = wb_reg_write_w;
    assign wb_pc        = wb_pc_w;
    assign wb_valid     = wb_valid_w;

endmodule