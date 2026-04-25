// =============================================================================
// hazard_unit.v
// Central hazard/trap controller for the RV32IM pipelined core.
//
// Combinational fast-path in S_IDLE:
//   - Branches (via branch_resolved 1-bit flag):
//       Cycle 1: stall + branch_addr_update + bubble at MEM1/MEM2
//       Cycle 2: flush + redirect to branch_addr
//   - Jumps: immediate flush + redirect
//   - Load-use: stall IF/ID + ID/EX, bubble at EX/MEM1 (stage 00 or 01)
//   - Load contention: fetch stall only
//
// State-driven:
//   IDLE, ACCEL, MUL, TRAP, MRET
//
// Priority in S_IDLE (highest first):
//   branch_cycle2 > branch_cycle1 > jump > load_use > mul > mem_contention
//
// load_use is higher priority than mul because MUL's operands might depend
// on a load in flight. We resolve the load first, then enter S_MUL.
//
// Traps are deferred while in ACCEL, MUL, or mid-branch-resolution.
// mepc rule: if a jump or taken branch is at EX/MEM1, save that instruction's
// own PC (re-execute on MRET, idempotent).
// =============================================================================

module hazard_unit #(
    parameter MULTIPLIER_CYCLES = 3
) (
    input  wire        clk,
    input  wire        rst,

    // ----- Pipeline register state -----
    input  wire        if_id_valid,
    input  wire [31:0] if_id_pc,

    input  wire        id_ex_valid,
    input  wire [31:0] id_ex_pc,
    input  wire        id_ex_is_mret,
    input  wire        id_ex_is_mul,
    input  wire [3:0]  id_ex_rs1_dep,
    input  wire [3:0]  id_ex_rs2_dep,

    input  wire        ex_mem1_valid,
    input  wire [31:0] ex_mem1_pc,
    input  wire        ex_mem1_is_branch,
    input  wire        ex_mem1_is_jump,
    input  wire        ex_mem1_is_taken,
    input  wire        ex_mem1_mem_read,
    input  wire        ex_mem1_mem_write,
    input  wire [31:0] ex_mem1_branch_addr,

    input  wire        mem1_mem2_valid,
    input  wire [31:0] mem1_mem2_pc,

    input  wire        mem2_mem3_valid,
    input  wire [31:0] mem2_mem3_pc,

    // ----- Accelerator -----
    input  wire        accel_busy,

    // ----- Interrupt controller -----
    input  wire        trap_req,
    input  wire [2:0]  trap_cause,

    // ----- CSR hardware interface -----
    input  wire [31:0] hw_mtvec,
    input  wire [31:0] hw_mepc,

    // ----- Outputs to pipeline registers -----
    output reg         if_id_stall,
    output reg         if_id_flush,
    output reg         id_ex_stall,
    output reg         id_ex_flush,
    output reg         ex_mem1_stall,
    output reg         ex_mem1_flush,
    output reg         ex_mem1_branch_addr_update,
    output reg         mem1_mem2_stall,
    output reg         mem1_mem2_flush,
    output reg         mem2_mem3_stall,
    output reg         mem2_mem3_flush,

    // ----- Outputs to fetch unit -----
    output reg         fetch_stall,
    output reg         fetch_flush,
    output reg  [1:0]  pc_sel,

    // ----- Outputs to CSR file / interrupt controller -----
    output reg         trap_entry,
    output reg  [31:0] trap_pc,
    output reg  [2:0]  trap_cause_id,
    output reg         mret_signal
);

    // -------------------------------------------------------------------------
    // PC mux encoding
    // -------------------------------------------------------------------------
    localparam [1:0] PC_PLUS_4 = 2'b00;
    localparam [1:0] PC_BRANCH = 2'b01;
    localparam [1:0] PC_MTVEC  = 2'b10;
    localparam [1:0] PC_MEPC   = 2'b11;

    // -------------------------------------------------------------------------
    // FSM states
    // -------------------------------------------------------------------------
    localparam [2:0] S_IDLE  = 3'd0;
    localparam [2:0] S_ACCEL = 3'd1;
    localparam [2:0] S_MUL   = 3'd2;
    localparam [2:0] S_TRAP  = 3'd3;
    localparam [2:0] S_MRET  = 3'd4;

    reg [2:0] state;
    reg [2:0] next_state;

    reg       branch_resolved;
    reg       next_branch_resolved;

    reg [3:0] mul_counter;
    reg [3:0] next_mul_counter;

    reg [31:0] saved_mepc_value;
    reg [2:0]  saved_trap_cause;

    // -------------------------------------------------------------------------
    // Condition decodes
    // -------------------------------------------------------------------------
    wire id_ex_rs1_is_valid = id_ex_rs1_dep[3];
    wire [1:0] id_ex_rs1_stage = id_ex_rs1_dep[2:1];
    wire id_ex_rs1_is_load = id_ex_rs1_dep[0];
    wire id_ex_rs2_is_valid = id_ex_rs2_dep[3];
    wire [1:0] id_ex_rs2_stage = id_ex_rs2_dep[2:1];
    wire id_ex_rs2_is_load = id_ex_rs2_dep[0];

    wire load_use_detected =
        (id_ex_rs1_is_valid && id_ex_rs1_is_load &&
         (id_ex_rs1_stage == 2'b00 || id_ex_rs1_stage == 2'b01)) ||
        (id_ex_rs2_is_valid && id_ex_rs2_is_load &&
         (id_ex_rs2_stage == 2'b00 || id_ex_rs2_stage == 2'b01));

    wire branch_taken_detected = ex_mem1_valid && ex_mem1_is_branch && ex_mem1_is_taken;
    wire jump_detected         = ex_mem1_valid && ex_mem1_is_jump;
    wire mret_detected         = id_ex_valid && id_ex_is_mret;
    wire mem_contention        = ex_mem1_valid && (ex_mem1_mem_read || ex_mem1_mem_write);
    wire mul_detected          = id_ex_valid && id_ex_is_mul;

    wire branch_cycle1 = branch_taken_detected && !branch_resolved;
    wire branch_cycle2 = branch_taken_detected && branch_resolved;

    wire early_commit_at_em1 = ex_mem1_valid &&
                               (ex_mem1_mem_write || branch_taken_detected || jump_detected);

    // MUL can fire only if no load-use dependency is pending. This prevents
    // MUL from reading a load's address (ex_mem1_fwd) instead of its data
    // (which is not yet available at stage 00 or 01).
    wire mul_ready = mul_detected && !load_use_detected;

    wire trap_can_fire =
        trap_req && (
            (state == S_IDLE && !branch_cycle1)
        );

    // -------------------------------------------------------------------------
    // mepc selection
    //   - If a jump or taken branch is at EX/MEM1, save that instruction's PC
    //     (re-execute on MRET, idempotent)
    //   - Otherwise during ACCEL/MUL/early_commit: pick from ID/EX
    //   - Otherwise normal scan from MEM2/MEM3 backward
    // -------------------------------------------------------------------------
    reg [31:0] mepc_candidate;
    always @(*) begin
        if (ex_mem1_valid && (jump_detected || branch_taken_detected)) begin
            mepc_candidate = ex_mem1_pc;
        end
        else if (state == S_ACCEL || state == S_MUL || early_commit_at_em1) begin
            if (id_ex_valid)       mepc_candidate = id_ex_pc;
            else if (if_id_valid)  mepc_candidate = if_id_pc;
            else                   mepc_candidate = 32'b0;
        end else begin
            if (mem2_mem3_valid)      mepc_candidate = mem2_mem3_pc;
            else if (mem1_mem2_valid) mepc_candidate = mem1_mem2_pc;
            else if (ex_mem1_valid)   mepc_candidate = ex_mem1_pc;
            else if (id_ex_valid)     mepc_candidate = id_ex_pc;
            else if (if_id_valid)     mepc_candidate = if_id_pc;
            else                      mepc_candidate = 32'b0;
        end
    end

    // -------------------------------------------------------------------------
    // Next-state logic
    // -------------------------------------------------------------------------
    always @(*) begin
        next_state = state;

        case (state)
            S_IDLE: begin
                if (trap_can_fire)         next_state = S_TRAP;
                else if (mret_detected)    next_state = S_MRET;
                else if (mul_ready)        next_state = S_MUL;
                else if (accel_busy)       next_state = S_ACCEL;
            end

            S_ACCEL: begin
                if (!accel_busy) next_state = S_IDLE;
            end

            S_MUL: begin
                if (mul_counter == 4'd0) next_state = S_IDLE;
            end

            S_TRAP: next_state = S_IDLE;
            S_MRET: next_state = S_IDLE;

            default: next_state = S_IDLE;
        endcase
    end

    // -------------------------------------------------------------------------
    // Branch resolved flag update
    // -------------------------------------------------------------------------
    always @(*) begin
        next_branch_resolved = branch_resolved;
        if (branch_cycle1)      next_branch_resolved = 1'b1;
        else if (branch_cycle2) next_branch_resolved = 1'b0;
        else if (!branch_taken_detected) next_branch_resolved = 1'b0;
    end

    // -------------------------------------------------------------------------
    // MUL counter update
    //   Load counter only when MUL is ready to enter S_MUL
    // -------------------------------------------------------------------------
    always @(*) begin
        next_mul_counter = mul_counter;
        if (state == S_IDLE && mul_ready) begin
            next_mul_counter = MULTIPLIER_CYCLES[3:0];
        end else if (state == S_MUL && mul_counter != 4'd0) begin
            next_mul_counter = mul_counter - 4'd1;
        end
    end

    // -------------------------------------------------------------------------
    // Output logic (combinational)
    // -------------------------------------------------------------------------
    always @(*) begin
        if_id_stall                = 1'b0;
        if_id_flush                = 1'b0;
        id_ex_stall                = 1'b0;
        id_ex_flush                = 1'b0;
        ex_mem1_stall              = 1'b0;
        ex_mem1_flush              = 1'b0;
        ex_mem1_branch_addr_update = 1'b0;
        mem1_mem2_stall            = 1'b0;
        mem1_mem2_flush            = 1'b0;
        mem2_mem3_stall            = 1'b0;
        mem2_mem3_flush            = 1'b0;
        fetch_stall                = 1'b0;
        fetch_flush                = 1'b0;
        pc_sel                     = PC_PLUS_4;
        trap_entry                 = 1'b0;
        trap_pc                    = 32'b0;
        trap_cause_id              = 3'b0;
        mret_signal                = 1'b0;

        case (state)
            // -----------------------------------------------------------------
            S_IDLE: begin
                // Priority: branch_cycle2 > branch_cycle1 > jump >
                //           load-use > mul entry > mem contention

                if (branch_cycle2) begin
                    if_id_flush   = 1'b1;
                    id_ex_flush   = 1'b1;
                    ex_mem1_flush = 1'b1;
                    fetch_flush   = 1'b1;
                    pc_sel        = PC_BRANCH;
                end
                else if (branch_cycle1) begin
                    if_id_stall                = 1'b1;
                    id_ex_stall                = 1'b1;
                    ex_mem1_stall              = 1'b1;
                    ex_mem1_branch_addr_update = 1'b1;
                    fetch_stall                = 1'b1;
                    mem1_mem2_flush            = 1'b1;
                end
                else if (jump_detected) begin
                    if_id_flush   = 1'b1;
                    id_ex_flush   = 1'b1;
                    ex_mem1_flush = 1'b1;
                    fetch_flush   = 1'b1;
                    pc_sel        = PC_BRANCH;
                end
                else if (load_use_detected) begin
                    if_id_stall   = 1'b1;
                    id_ex_stall   = 1'b1;
                    ex_mem1_flush = 1'b1;
                    fetch_stall   = 1'b1;
                end
                else if (mul_ready) begin
                    // Pre-entry stall: freeze everything before S_MUL
                    if_id_stall     = 1'b1;
                    id_ex_stall     = 1'b1;
                    ex_mem1_stall   = 1'b1;
                    mem1_mem2_stall = 1'b1;
                    mem2_mem3_stall = 1'b1;
                    fetch_stall     = 1'b1;
                end
                else if (mem_contention) begin
                    fetch_stall = 1'b1;
                end
            end

            // -----------------------------------------------------------------
            S_ACCEL: begin
                if_id_stall     = 1'b1;
                id_ex_stall     = 1'b1;
                ex_mem1_stall   = 1'b1;
                mem1_mem2_stall = 1'b1;
                mem2_mem3_stall = 1'b1;
                fetch_stall     = 1'b1;
            end

            // -----------------------------------------------------------------
            S_MUL: begin
                if (mul_counter != 4'd0) begin
                    if_id_stall     = 1'b1;
                    id_ex_stall     = 1'b1;
                    ex_mem1_stall   = 1'b1;
                    mem1_mem2_stall = 1'b1;
                    mem2_mem3_stall = 1'b1;
                    fetch_stall     = 1'b1;
                end
            end

            // -----------------------------------------------------------------
            S_TRAP: begin
                if_id_flush     = 1'b1;
                id_ex_flush     = 1'b1;
                ex_mem1_flush   = 1'b1;
                mem1_mem2_flush = 1'b1;
                mem2_mem3_flush = 1'b1;
                fetch_flush     = 1'b1;
                pc_sel          = PC_MTVEC;
                trap_entry      = 1'b1;
                trap_pc         = saved_mepc_value;
                trap_cause_id   = saved_trap_cause;
            end

            // -----------------------------------------------------------------
            S_MRET: begin
                if_id_flush   = 1'b1;
                id_ex_flush   = 1'b1;
                ex_mem1_flush = 1'b1;
                fetch_flush   = 1'b1;
                pc_sel        = PC_MEPC;
                mret_signal   = 1'b1;
            end

            default: ;
        endcase
    end

    // -------------------------------------------------------------------------
    // Sequential
    // -------------------------------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            state            <= S_IDLE;
            branch_resolved  <= 1'b0;
            mul_counter      <= 4'd0;
            saved_mepc_value <= 32'b0;
            saved_trap_cause <= 3'b0;
        end else begin
            state           <= next_state;
            branch_resolved <= next_branch_resolved;
            mul_counter     <= next_mul_counter;

            if (next_state == S_TRAP && state != S_TRAP) begin
                saved_mepc_value <= mepc_candidate;
                saved_trap_cause <= trap_cause;
            end
        end
    end

endmodule