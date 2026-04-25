// =============================================================================
// if_id_reg.v
// IF/ID pipeline register.
// Carries: pc, pc_plus_4, instr, valid
// Priority: rst > flush > stall > normal
// Flush: instr = NOP (ADDI x0,x0,0), pc = 0, pc_plus_4 = 0, valid = 0
// =============================================================================

module if_id_reg (
    input  wire        clk,
    input  wire        rst,
    input  wire        stall,
    input  wire        flush,

    input  wire [31:0] pc_in,
    input  wire [31:0] pc_plus_4_in,
    input  wire [31:0] instr_in,

    output reg  [31:0] pc_out,
    output reg  [31:0] pc_plus_4_out,
    output reg  [31:0] instr_out,
    output reg         valid_out
);

    localparam [31:0] NOP_INSTR = 32'h00000013;

    always @(posedge clk) begin
        if (rst || flush) begin
            pc_out        <= 32'b0;
            pc_plus_4_out <= 32'b0;
            instr_out     <= NOP_INSTR;
            valid_out     <= 1'b0;
        end else if (stall) begin
            pc_out        <= pc_out;
            pc_plus_4_out <= pc_plus_4_out;
            instr_out     <= instr_out;
            valid_out     <= valid_out;
        end else begin
            pc_out        <= pc_in;
            pc_plus_4_out <= pc_plus_4_in;
            instr_out     <= instr_in;
            valid_out     <= 1'b1;
        end
    end

endmodule