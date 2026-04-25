module riscv_core (
    input logic clk,
    input logic rst,

    // The two external bus connections to the Interconnect
    cpu_bus_intf.master instr_bus,
    cpu_bus_intf.master data_bus
);

    // =========================================================
    // 1. INTERCONNECT WIRES (Struts)
    // =========================================================

    import core_types::*;


    if_id_packet_t if_id_in, if_id_out;
    id_ex_packet_t id_ex_in, id_ex_out;
    ex_mem_packet_t ex_mem_in, ex_mem_out;
    mem_wb_packet_t mem_wb_in, mem_wb_out;

    // Control wires
    logic [31:0] pc_current, pc_next;
    logic        branch_taken;
    logic [31:0] branch_target;

    // Hazard wires
    logic pc_stall, if_id_stall, id_ex_stall, ex_mem_stall, mem_wb_stall;
    logic if_id_flush, id_ex_flush, ex_mem_flush, mem_wb_flush;
    logic if_stall, ex_stall, mem_stall;

    // Forwarding wires
    logic [1:0] forward_a, forward_b;

    // Writeback wires
    logic        wb_reg_we;
    logic [ 4:0] wb_rd_addr;
    logic [31:0] wb_rd_data;


    // =========================================================
    // 2. PC REGISTER
    // =========================================================
    always_ff @(posedge clk) begin
        if (rst) begin
            pc_current <= 32'h0000_0000;  // Boot address
        end else if (!pc_stall) begin
            pc_current <= branch_taken ? branch_target : (pc_current + 4);
        end
    end


    // =========================================================
    // 3. PIPELINE STAGES & REGISTERS
    // =========================================================

    logic backend_stall;

    // --- FETCH (IF) ---
    if_stage u_if (
        .clk        (clk),
        .rst        (rst),
        .pc         (pc_current),
        .if_id_stall(backend_stall),  // Used as local ready signal
        .bus        (instr_bus),
        .if_id_out  (if_id_in),
        .if_stall   (if_stall)
    );

    pipeline_reg #(
        .T(if_id_packet_t)
    ) reg_if_id (
        .clk     (clk),
        .rst     (rst),
        .stall   (if_id_stall),
        .flush   (if_id_flush),
        .data_in (if_id_in),
        .data_out(if_id_out)
    );

    // --- DECODE (ID) ---
    id_stage u_id (
        .clk       (clk),
        .rst       (rst),
        .if_id_in  (if_id_out),
        .wb_reg_we (wb_reg_we),
        .wb_rd_addr(wb_rd_addr),
        .wb_rd_data(wb_rd_data),
        .id_ex_out (id_ex_in)
    );

    pipeline_reg #(
        .T(id_ex_packet_t)
    ) reg_id_ex (
        .clk     (clk),
        .rst     (rst),
        .stall   (id_ex_stall),
        .flush   (id_ex_flush),
        .data_in (id_ex_in),
        .data_out(id_ex_out)
    );

    // --- EXECUTE (EX) ---
    ex_stage u_ex (
        .clk               (clk),
        .rst               (rst),
        .id_ex_in          (id_ex_out),
        .forward_a         (forward_a),
        .forward_b         (forward_b),
        .forwarded_mem_data(ex_mem_out.result),
        .forwarded_wb_data (wb_rd_data),
        .branch_taken      (branch_taken),
        .branch_target     (branch_target),
        .ex_stall          (ex_stall),
        .ex_mem_out        (ex_mem_in)
    );

    pipeline_reg #(
        .T(ex_mem_packet_t)
    ) reg_ex_mem (
        .clk     (clk),
        .rst     (rst),
        .stall   (ex_mem_stall),
        .flush   (ex_mem_flush),
        .data_in (ex_mem_in),
        .data_out(ex_mem_out)
    );

    // --- MEMORY (MEM) ---
    mem_stage u_mem (
        .clk         (clk),
        .rst         (rst),
        .ex_mem_in   (ex_mem_out),
        .mem_wb_stall(mem_wb_stall),
        .bus         (data_bus),
        .mem_wb_out  (mem_wb_in),
        .mem_stall   (mem_stall)
    );

    pipeline_reg #(
        .T(mem_wb_packet_t)
    ) reg_mem_wb (
        .clk     (clk),
        .rst     (rst),
        .stall   (mem_wb_stall),
        .flush   (mem_wb_flush),
        .data_in (mem_wb_in),
        .data_out(mem_wb_out)
    );

    // --- WRITEBACK (WB) ---
    wb_stage u_wb (
        .mem_wb_in (mem_wb_out),
        .wb_reg_we (wb_reg_we),
        .wb_rd_addr(wb_rd_addr),
        .wb_rd_data(wb_rd_data)
    );


    // =========================================================
    // 4. CONTROL & HAZARD UNITS
    // =========================================================

    hazard_unit u_hazard (
        .if_stall     (if_stall),
        .ex_stall     (ex_stall),
        .mem_stall    (mem_stall),
        .id_ex_mem_re (id_ex_out.mem_re),
        .backend_stall(backend_stall),      // <-- NEW connection
        .id_ex_rd     (id_ex_out.rd_addr),
        .if_id_rs1    (id_ex_in.rs1_addr),  // Ensure you passed rs1/rs2 addrs through IF/ID!
        .if_id_rs2    (id_ex_in.rs2_addr),
        .branch_taken (branch_taken),
        .pc_stall     (pc_stall),
        .if_id_stall  (if_id_stall),
        .id_ex_stall  (id_ex_stall),
        .ex_mem_stall (ex_mem_stall),
        .mem_wb_stall (mem_wb_stall),
        .if_id_flush  (if_id_flush),
        .id_ex_flush  (id_ex_flush),
        .ex_mem_flush (ex_mem_flush),
        .mem_wb_flush (mem_wb_flush)
    );

    forwarding_unit u_forward (
        .id_ex_rs1    (id_ex_out.rs1_addr),
        .id_ex_rs2    (id_ex_out.rs2_addr),
        .ex_mem_reg_we(ex_mem_out.reg_we),
        .ex_mem_rd    (ex_mem_out.rd_addr),
        .mem_wb_reg_we(wb_reg_we),           // Mapped directly to WB outputs
        .mem_wb_rd    (wb_rd_addr),
        .forward_a    (forward_a),
        .forward_b    (forward_b)
    );

endmodule
