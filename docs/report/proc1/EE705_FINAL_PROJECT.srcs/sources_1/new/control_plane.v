`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2026 04:15:19 PM
// Design Name: 
// Module Name: control_plane
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
// control_plane.v
// Wraps csr_file, interrupt_controller, and hazard_unit.
// "Brain" of the core: makes all stall/flush/redirect/trap decisions.
// =============================================================================

module control_plane (
    input  wire        clk,
    input  wire        rst,

    // ----- From datapath: pipeline visibility -----
    input  wire        if_id_valid,
    input  wire [31:0] if_id_pc,

    input  wire        id_ex_valid,
    input  wire [31:0] id_ex_pc,
    input  wire        id_ex_is_mret,
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

    // WB commit (for minstret)
    input  wire        wb_valid,
    input  wire        id_ex_is_mul,
    // ----- From datapath: CSR software interface -----
    input  wire [11:0] csr_addr,
    input  wire        csr_wen,
    input  wire [31:0] csr_wdata,
    output wire [31:0] csr_rdata,

    // ----- From memory subsystem -----
    input  wire        accel_busy,
    input  wire [4:0]  irq_lines,

    // ----- To memory subsystem -----

    // ----- To datapath: per-stage stall/flush -----
    output wire        if_id_stall,
    output wire        if_id_flush,
    output wire        id_ex_stall,
    output wire        id_ex_flush,
    output wire        ex_mem1_stall,
    output wire        ex_mem1_flush,
    output wire        ex_mem1_branch_addr_update,
    output wire        mem1_mem2_stall,
    output wire        mem1_mem2_flush,
    output wire        mem2_mem3_stall,
    output wire        mem2_mem3_flush,

    // ----- To fetch unit -----
    output wire        fetch_stall,
    output wire        fetch_flush,
    output wire [1:0]  pc_sel,
    output wire [31:0] mtvec_out,
    output wire [31:0] mepc_out,
    output wire [31:0] branch_addr_out
);

    // -------------------------------------------------------------------------
    // CSR file ? hazard unit ? interrupt controller wiring
    // -------------------------------------------------------------------------
    wire [31:0] hw_mtvec;
    wire [31:0] hw_mepc;
    wire [31:0] hw_mcause;
    wire        hw_mstatus_mie;
    wire [4:0]  hw_int_en;

    wire        trap_entry;
    wire [31:0] trap_pc;
    wire [2:0]  trap_cause_id;
    wire        mret_signal;

    wire        trap_req;
    wire [2:0]  trap_cause;

    // -------------------------------------------------------------------------
    // CSR file
    // -------------------------------------------------------------------------
    csr_file u_csr_file (
        .clk            (clk),
        .rst            (rst),

        .csr_addr       (csr_addr),
        .csr_wen        (csr_wen),
        .csr_wdata      (csr_wdata),
        .csr_rdata      (csr_rdata),

        .hw_mtvec       (hw_mtvec),
        .hw_mepc        (hw_mepc),
        .hw_mcause      (hw_mcause),
        .hw_mstatus_mie (hw_mstatus_mie),
        .hw_int_en      (hw_int_en),

        .commit_valid   (wb_valid),
        .trap_entry     (trap_entry),
        .trap_pc        (trap_pc),
        .trap_cause_id  (trap_cause_id),
        .mret           (mret_signal)
    );

    // -------------------------------------------------------------------------
    // Interrupt controller
    // -------------------------------------------------------------------------
    interrupt_controller u_interrupt_controller (
        .clk            (clk),
        .rst            (rst),

        .irq_lines      (irq_lines),
        .hw_int_en      (hw_int_en),
        .hw_mstatus_mie (hw_mstatus_mie),

        .trap_entry     (trap_entry),
        .mret           (mret_signal),

        .trap_req       (trap_req),
        .trap_cause     (trap_cause)
    );

    // -------------------------------------------------------------------------
    // Hazard unit
    // -------------------------------------------------------------------------
    hazard_unit u_hazard_unit (
        .clk                       (clk),
        .rst                       (rst),

        .if_id_valid               (if_id_valid),
        .if_id_pc                  (if_id_pc),

        .id_ex_valid               (id_ex_valid),
        .id_ex_pc                  (id_ex_pc),
        .id_ex_is_mret             (id_ex_is_mret),
        .id_ex_rs1_dep             (id_ex_rs1_dep),
        .id_ex_rs2_dep             (id_ex_rs2_dep),

        .ex_mem1_valid             (ex_mem1_valid),
        .ex_mem1_pc                (ex_mem1_pc),
        .ex_mem1_is_branch         (ex_mem1_is_branch),
        .ex_mem1_is_jump           (ex_mem1_is_jump),
        .ex_mem1_is_taken          (ex_mem1_is_taken),
        .ex_mem1_mem_read          (ex_mem1_mem_read),
        .ex_mem1_mem_write         (ex_mem1_mem_write),
        .ex_mem1_branch_addr       (ex_mem1_branch_addr),

        .mem1_mem2_valid           (mem1_mem2_valid),
        .mem1_mem2_pc              (mem1_mem2_pc),

        .mem2_mem3_valid           (mem2_mem3_valid),
        .mem2_mem3_pc              (mem2_mem3_pc),

        .accel_busy                (accel_busy),
  
        .id_ex_is_mul         (id_ex_is_mul),
        .trap_req                  (trap_req),
        .trap_cause                (trap_cause),

        .hw_mtvec                  (hw_mtvec),
        .hw_mepc                   (hw_mepc),

        .if_id_stall               (if_id_stall),
        .if_id_flush               (if_id_flush),
        .id_ex_stall               (id_ex_stall),
        .id_ex_flush               (id_ex_flush),
        .ex_mem1_stall             (ex_mem1_stall),
        .ex_mem1_flush             (ex_mem1_flush),
        .ex_mem1_branch_addr_update(ex_mem1_branch_addr_update),
        .mem1_mem2_stall           (mem1_mem2_stall),
        .mem1_mem2_flush           (mem1_mem2_flush),
        .mem2_mem3_stall           (mem2_mem3_stall),
        .mem2_mem3_flush           (mem2_mem3_flush),

        .fetch_stall               (fetch_stall),
        .fetch_flush               (fetch_flush),
        .pc_sel                    (pc_sel),

        .trap_entry                (trap_entry),
        .trap_pc                   (trap_pc),
        .trap_cause_id             (trap_cause_id),
        .mret_signal               (mret_signal)

    );

    // -------------------------------------------------------------------------
    // PC mux source values exposed to the fetch unit
    // -------------------------------------------------------------------------
    assign mtvec_out       = hw_mtvec;
    assign mepc_out        = hw_mepc;
    assign branch_addr_out = ex_mem1_branch_addr;

endmodule
