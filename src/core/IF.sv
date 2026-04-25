
module if_stage (
    input logic        clk,
    input logic        rst,
    input logic [31:0] pc,

    // NEW: Local stall from Hazard Unit (Can the pipeline accept an instruction?)
    input logic if_id_stall,

    cpu_bus_intf.master bus,

    output if_id_packet_t if_id_out,
    output logic          if_stall
);

    import core_types::*;
    logic request_pending;

    // --- State Machine ---
    always_ff @(posedge clk) begin
        if (rst) begin
            request_pending <= 1'b0;
        end else begin
            if (bus.grant) begin
                request_pending <= 1'b1;
            end else if (bus.rdata_valid && bus.ready) begin
                request_pending <= 1'b0;
            end
        end
    end

    // --- Bus Master Interface ---
    // Rule: Ready if our local pipeline register is NOT stalled
    assign bus.ready       = !if_stall;

    // Rule: Request only if we don't have one pending, AND we aren't blocked from fetching
    assign bus.req_valid   = !request_pending && !if_id_stall;

    assign bus.addr        = pc;
    assign bus.we          = 1'b0;  // IF never writes
    assign bus.be          = 4'b1111;
    assign bus.wdata       = 32'd0;

    // --- Output & Stall Logic ---
    // IF is stalling the CPU if it wants an instruction but doesn't have it yet.
    assign if_stall        = (bus.req_valid && !bus.grant) || (request_pending && !bus.rdata_valid);

    // Only pass data forward if we are actively receiving and consuming it
    assign if_id_out.instr = bus.rdata;
    assign if_id_out.valid = bus.rdata_valid && bus.ready;

endmodule

// Below combines pc with if_stage to create the fetch subsystem.  

module fetch_subsystem (
    input  logic                 clk,
    input  logic                 rst,
    // pipeline_stall could come from other stages (like Decode or Execute)
    input  logic                 pipeline_stall,
    input  logic                 branch_taken,    // From EXEC: 1 if branch condition is met 
    input  logic          [31:0] branch_target,   // From EXEC: The calculated jump address
    output if_id_packet_t        if_id_out,       // signals to send to if_id reg 

    cpu_bus_intf.master bus
);

    logic [31:0] current_pc;
    logic [31:0] next_pc;
    logic [31:0] pc_plus_4;
    logic        if_stall;

    assign pc_plus_4 = current_pc + 32'd4;

    // Branching logic, EX stage tells if branch taken or not 
    assign next_pc   = branch_taken ? branch_target : pc_plus_4;

    // Combine stalls: Stall if the pipeline asks to, OR if we are waiting on memory
    logic global_pc_stall;
    assign global_pc_stall = pipeline_stall | if_stall;

    pc_unit u_pc (
        .clk    (clk),
        .rst    (rst),
        .stall  (global_pc_stall),  // PC freezes during multi-cycle MMIO waits
        .next_pc(next_pc),
        .pc     (current_pc)
    );

    if_stage u_if (
        .clk        (clk),
        .rst        (rst),
        .pc         (current_pc),
        .if_id_stall(global_pc_stall),
        .bus        (bus),
        .if_id_out  (if_id_out),
        .if_stall   (if_stall)          // Output stall signal
    );

endmodule

