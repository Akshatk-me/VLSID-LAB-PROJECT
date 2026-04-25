`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2026 04:49:17 AM
// Design Name: 
// Module Name: fetch_queue
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
// fetch_queue.v
// Dumb FIFO for the fetch unit. Each entry holds {pc, pc_plus_4, instr}.
// Depth = 4 (N+2 with N=2, memory latency = 2).
//
// Interface:
//   - wen      : write enable, advances tail
//   - wdata    : 96-bit entry to write {pc, pc_plus_4, instr}
//   - pop      : read enable, advances head
//   - flush    : synchronous clear, head=tail=0
//   - rdata    : current head entry
//
// No full/empty signals exposed; the fetch_unit wrapper handles flow control.
// =============================================================================

module fetch_queue (
    input  wire         clk,
    input  wire         rst,
    input  wire         flush,

    input  wire         wen,
    input  wire [95:0]  wdata,

    input  wire         pop,
    output wire [95:0]  rdata
);

    localparam DEPTH = 4;
    localparam PTR_W = 2;   // log2(DEPTH)

    reg [95:0] mem [0:DEPTH-1];
    reg [PTR_W-1:0] head_ptr;
    reg [PTR_W-1:0] tail_ptr;

    integer i;

    // Combinational read at head
    assign rdata = mem[head_ptr];

    always @(posedge clk) begin
        if (rst || flush) begin
            head_ptr <= {PTR_W{1'b0}};
            tail_ptr <= {PTR_W{1'b0}};
            for (i = 0; i < DEPTH; i = i + 1)
                mem[i] <= 96'b0;
        end else begin
            if (wen) begin
                mem[tail_ptr] <= wdata;
                tail_ptr      <= tail_ptr + {{(PTR_W-1){1'b0}}, 1'b1};
            end
            if (pop) begin
                head_ptr <= head_ptr + {{(PTR_W-1){1'b0}}, 1'b1};
            end
        end
    end

endmodule