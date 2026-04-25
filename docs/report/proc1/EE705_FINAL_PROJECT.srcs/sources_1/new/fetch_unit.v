// =============================================================================
// fetch_unit.v
// Pure-mechanism fetch unit with valid-bit tracking.
//
// Contains:
//   - PC register + PC mux + PC+4 adder
//   - 2-deep in-flight PC shift register (pending_pc, pending_pc_plus_4)
//   - 2-deep valid shift register (v_p0, v_p1)
//   - fetch_queue (4-deep FIFO of {pc, pc_plus_4, instr})
//
// Valid bit semantics:
//   v_live = !stall (combinational, live valid of this cycle's fetch)
//   v_p0 <= v_live at clock edge (1 cycle of pipeline delay)
//   v_p1 <= v_p0   at clock edge (2 cycles of pipeline delay)
//   q_wen = v_p1 (response arriving this cycle is valid iff its fetch was)
//
// Flush: resets PC in-flight register and zeroes v_p0, v_p1. Queue is
// separately flushed by its own input.
// =============================================================================

module fetch_unit (
    input  wire        clk,
    input  wire        rst,

    // Hazard unit control
    input  wire        stall,         // 1 = this cycle's fetch is invalid
    input  wire        flush,         // 1 = clear queue, redirect PC
    input  wire [1:0]  pc_sel,
    input  wire [31:0] branch_addr,
    input  wire [31:0] mtvec,
    input  wire [31:0] mepc,
    input  wire        q_pop,

    // Memory interface
    output wire [31:0] mem_req_pc,
    input  wire [31:0] mem_resp_instr,

    // Outputs to IF/ID
    output wire [31:0] head_pc,
    output wire [31:0] head_pc_plus_4,
    output wire [31:0] head_instr,

    // PC visibility
    output wire [31:0] pc_current
);

    // -------------------------------------------------------------------------
    // PC register + PC+4 + PC mux
    // -------------------------------------------------------------------------
    reg  [31:0] pc;
    wire [31:0] pc_plus_4 = pc + 32'd4;
    wire [31:0] next_pc;

    pc_mux u_pc_mux (
        .pc_sel      (pc_sel),
        .pc_plus_4   (pc_plus_4),
        .branch_addr (branch_addr),
        .mtvec       (mtvec),
        .mepc        (mepc),
        .next_pc     (next_pc)
    );

    // PC advances every cycle except stall. Flush overrides and redirects.
    always @(posedge clk) begin
        if (rst) begin
            pc <= 32'h00000000;
        end else if (flush) begin
            pc <= next_pc;
        end else if (!stall) begin
            pc <= next_pc;
        end
        // stall without flush: PC holds
    end

    assign mem_req_pc = pc;
    assign pc_current = pc;

    // -------------------------------------------------------------------------
    // In-flight PC shift register (2 deep)
    // pending_pc[0] = fetch issued last cycle (in memory pipeline)
    // pending_pc[1] = fetch issued 2 cycles ago (response arriving this cycle)
    // -------------------------------------------------------------------------
    reg [31:0] pending_pc        [0:1];
    reg [31:0] pending_pc_plus_4 [0:1];

    always @(posedge clk) begin
        if (rst || flush) begin
            pending_pc[0]        <= 32'b0;
            pending_pc[1]        <= 32'b0;
            pending_pc_plus_4[0] <= 32'b0;
            pending_pc_plus_4[1] <= 32'b0;
        end else begin
            pending_pc[1]        <= pending_pc[0];
            pending_pc_plus_4[1] <= pending_pc_plus_4[0];
            pending_pc[0]        <= pc;
            pending_pc_plus_4[0] <= pc_plus_4;
        end
    end

    wire [31:0] resp_pc        = pending_pc[1];
    wire [31:0] resp_pc_plus_4 = pending_pc_plus_4[1];

    // -------------------------------------------------------------------------
    // Valid shift register (2 deep)
    // v_live = combinational, live valid of this cycle's fetch
    // v_p0   = registered, valid of last cycle's fetch
    // v_p1   = registered, valid of fetch from 2 cycles ago (its response
    //          is what's on mem_resp_instr this cycle)
    // -------------------------------------------------------------------------
    wire v_live = !stall;
    reg  v_p0;
    reg  v_p1;

    always @(posedge clk) begin
        if (rst || flush) begin
            v_p0 <= 1'b0;
            v_p1 <= 1'b0;
        end else begin
            v_p1 <= v_p0;
            v_p0 <= v_live;
        end
    end

    // -------------------------------------------------------------------------
    // Queue
    // q_wen = v_p1: write only when the response corresponds to a valid fetch
    // -------------------------------------------------------------------------
    wire        q_wen  = v_p1;
    wire [95:0] q_wdata = {resp_pc, resp_pc_plus_4, mem_resp_instr};
    wire [95:0] q_rdata;

    fetch_queue u_fetch_queue (
        .clk   (clk),
        .rst   (rst),
        .flush (flush),
        .wen   (q_wen),
        .wdata (q_wdata),
        .pop   (q_pop),
        .rdata (q_rdata)
    );

    assign head_pc        = q_rdata[95:64];
    assign head_pc_plus_4 = q_rdata[63:32];
    assign head_instr     = q_rdata[31:0];

endmodule