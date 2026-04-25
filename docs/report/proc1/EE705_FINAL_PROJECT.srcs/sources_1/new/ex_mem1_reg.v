// =============================================================================
// ex_mem1_reg.v
// EX/MEM1 pipeline register.
// Carries: pc, ex_result, branch_addr, store_data, rd_addr, valid,
//          mem control (mem_read, mem_write, wen, is_branch, is_jump, is_taken),
//          carried forward: ld_select, reg_write
//
// branch_addr_update: when asserted, branch_addr field updates from
// branch_addr_in even if the rest is stalled. Used by hazard unit during
// BRANCH_CYCLE1.
//
// Priority: rst > flush > stall > normal
// =============================================================================

module ex_mem1_reg (
    input  wire        clk,
    input  wire        rst,
    input  wire        stall,
    input  wire        flush,

    input  wire        branch_addr_update,

    // Data inputs
    input  wire [31:0] pc_in,
    input  wire [31:0] ex_result_in,
    input  wire [31:0] branch_addr_in,
    input  wire [31:0] store_data_in,
    input  wire [4:0]  rd_addr_in,

    // MEM stage control inputs
    input  wire        mem_read_in,
    input  wire        mem_write_in,
    input  wire [3:0]  wen_in,
    input  wire        is_branch_in,
    input  wire        is_jump_in,
    input  wire        is_taken_in,

    // Control carried forward
    input  wire [2:0]  ld_select_in,
    input  wire        reg_write_in,

    // Data outputs
    output reg  [31:0] pc_out,
    output reg  [31:0] ex_result_out,
    output reg  [31:0] branch_addr_out,
    output reg  [31:0] store_data_out,
    output reg  [4:0]  rd_addr_out,

    // MEM stage control outputs
    output reg         mem_read_out,
    output reg         mem_write_out,
    output reg  [3:0]  wen_out,
    output reg         is_branch_out,
    output reg         is_jump_out,
    output reg         is_taken_out,

    // Forwarded control outputs
    output reg  [2:0]  ld_select_out,
    output reg         reg_write_out,

    output reg         valid_out
);

    always @(posedge clk) begin
        if (rst || flush) begin
            pc_out          <= 32'b0;
            ex_result_out   <= 32'b0;
            branch_addr_out <= 32'b0;
            store_data_out  <= 32'b0;
            rd_addr_out     <= 5'b0;
            mem_read_out    <= 1'b0;
            mem_write_out   <= 1'b0;
            wen_out         <= 4'b0;
            is_branch_out   <= 1'b0;
            is_jump_out     <= 1'b0;
            is_taken_out    <= 1'b0;
            ld_select_out   <= 3'b0;
            reg_write_out   <= 1'b0;
            valid_out       <= 1'b0;
        end else if (stall) begin
            pc_out          <= pc_out;
            ex_result_out   <= ex_result_out;
            branch_addr_out <= branch_addr_update ? branch_addr_in : branch_addr_out;
            store_data_out  <= store_data_out;
            rd_addr_out     <= rd_addr_out;
            mem_read_out    <= mem_read_out;
            mem_write_out   <= mem_write_out;
            wen_out         <= wen_out;
            is_branch_out   <= is_branch_out;
            is_jump_out     <= is_jump_out;
            is_taken_out    <= is_taken_out;
            ld_select_out   <= ld_select_out;
            reg_write_out   <= reg_write_out;
            valid_out       <= valid_out;
        end else begin
            pc_out          <= pc_in;
            ex_result_out   <= ex_result_in;
            branch_addr_out <= branch_addr_in;
            store_data_out  <= store_data_in;
            rd_addr_out     <= rd_addr_in;
            mem_read_out    <= mem_read_in;
            mem_write_out   <= mem_write_in;
            wen_out         <= wen_in;
            is_branch_out   <= is_branch_in;
            is_jump_out     <= is_jump_in;
            is_taken_out    <= is_taken_in;
            ld_select_out   <= ld_select_in;
            reg_write_out   <= reg_write_in;
            valid_out       <= 1'b1;
        end
    end

endmodule