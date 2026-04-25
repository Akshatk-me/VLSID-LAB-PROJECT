`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2026 05:52:51 AM
// Design Name: 
// Module Name: mem_arbiter
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
// mem_arbiter.v
// Single-port BRAM arbiter for the CPU memory bus.
// Sources (priority high to low):
//   1. SHA-256 accelerator (highest)
//   2. CPU MEM stage (load/store)
//   3. CPU fetch unit (lowest)
//
// Combinational priority pick on the request side. Owner ID is shifted
// through a 2-deep register to track who issued the request 2 cycles ago,
// since BRAM responses arrive with 2-cycle latency. The owner_id_resp
// output tells the rest of the system which source the current bram_dout
// belongs to.
//
// Owner IDs:
//   2'b00 = none / idle  (no request was issued)
//   2'b01 = fetch
//   2'b10 = MEM stage
//   2'b11 = accelerator
// =============================================================================

module mem_arbiter (
    input  wire        clk,
    input  wire        rst,

    // ----- Fetch unit request -----
    input  wire [31:0] fetch_addr,
    input  wire        fetch_req,        // always high if fetch wants the port

    // ----- MEM stage request -----
    input  wire [31:0] mem_addr,
    input  wire [31:0] mem_wdata,
    input  wire [3:0]  mem_wen,
    input  wire        mem_req,          // 1 = load or store this cycle

    // ----- Accelerator request -----
    input  wire [31:0] accel_addr,
    input  wire        accel_req,        // 1 = accelerator in READ state

    // ----- BRAM port -----
    output reg  [31:0] bram_addr,
    output reg  [31:0] bram_wdata,
    output reg  [3:0]  bram_wen,

    // ----- Owner tracking -----
    output wire [1:0]  owner_id_issue,   // who got the port this cycle
    output wire [1:0]  owner_id_resp     // who owns the response this cycle (= 2 cycles ago's issue)
);

    localparam [1:0] OWN_NONE  = 2'b00;
    localparam [1:0] OWN_FETCH = 2'b01;
    localparam [1:0] OWN_MEM   = 2'b10;
    localparam [1:0] OWN_ACCEL = 2'b11;

    // -------------------------------------------------------------------------
    // Combinational priority decode
    // -------------------------------------------------------------------------
    reg [1:0] owner_now;

    always @(*) begin
        if (accel_req) begin
            owner_now  = OWN_ACCEL;
            bram_addr  = accel_addr;
            bram_wdata = 32'b0;
            bram_wen   = 4'b0;
        end else if (mem_req) begin
            owner_now  = OWN_MEM;
            bram_addr  = mem_addr;
            bram_wdata = mem_wdata;
            bram_wen   = mem_wen;
        end else if (fetch_req) begin
            owner_now  = OWN_FETCH;
            bram_addr  = fetch_addr;
            bram_wdata = 32'b0;
            bram_wen   = 4'b0;
        end else begin
            owner_now  = OWN_NONE;
            bram_addr  = 32'b0;
            bram_wdata = 32'b0;
            bram_wen   = 4'b0;
        end
    end

    assign owner_id_issue = owner_now;

    // -------------------------------------------------------------------------
    // Owner shift register (2 deep, matches BRAM read latency)
    // owner_pipe[0] = issued this cycle (= owner_now)
    // owner_pipe[1] = issued last cycle
    // owner_id_resp = owner_pipe[1] (response arriving this cycle was issued
    //                  2 cycles ago, which is what's about to be shifted out)
    // -------------------------------------------------------------------------
    reg [1:0] owner_pipe_0;
    reg [1:0] owner_pipe_1;

    always @(posedge clk) begin
        if (rst) begin
            owner_pipe_0 <= OWN_NONE;
            owner_pipe_1 <= OWN_NONE;
        end else begin
            owner_pipe_0 <= owner_now;
            owner_pipe_1 <= owner_pipe_0;
        end
    end

    assign owner_id_resp = owner_pipe_1;

endmodule
