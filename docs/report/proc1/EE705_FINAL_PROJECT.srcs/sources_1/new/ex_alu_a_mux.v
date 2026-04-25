// =============================================================================
// ex_alu_a_mux.v
// EX-stage operand A mux for the ALU (also feeds CSR write data path
// for CSRRW via the same rs1-resolved value).
//
// Sources:
//   0000 = rs1_data         (from ID/EX, no forwarding)
//   0001 = pc               (current instruction's PC, for AUIPC/JAL)
//   0010 = ex_mem1_fwd      (forward from EX/MEM1.ex_result)
//   0011 = mem1_mem2_fwd    (forward from MEM1/MEM2.ex_result)
//   0100 = mem2_mem3_fwd    (forward from MEM2/MEM3.ex_result, non-load)
//   0101 = mask_unit_fwd    (forward from MEM3 mask unit output, load)
//   0110 = mem3_wb_fwd      (forward from MEM3/WB.write_data)
//   0111 = ex_mem1_pc_fwd   (forward PC from EX/MEM1.pc)
//   others = reserved (default to rs1_data)
//
// sel is 4 bits, driven by the forwarding unit.
// =============================================================================

module ex_alu_a_mux (
    input  wire [2:0]  sel,
    input  wire [31:0] rs1_data,
    input  wire [31:0] pc,
    input  wire [31:0] ex_mem1_fwd,
    input  wire [31:0] mem1_mem2_fwd,
    input  wire [31:0] mem2_mem3_fwd,
    input  wire [31:0] mask_unit_fwd,
    input  wire [31:0] mem3_wb_fwd,
    input  wire [31:0] ex_mem1_pc_fwd,
    output reg  [31:0] alu_a
);

    always @(*) begin
        case (sel)
            3'b000: alu_a = rs1_data;
            3'b001: alu_a = pc;
            3'b010: alu_a = ex_mem1_fwd;
            3'b011: alu_a = mem1_mem2_fwd;
            3'b100: alu_a = mem2_mem3_fwd;
            3'b101: alu_a = mask_unit_fwd;
            3'b110: alu_a = mem3_wb_fwd;
            3'b111: alu_a = ex_mem1_pc_fwd;
            default: alu_a = rs1_data;
        endcase
    end

endmodule