// =============================================================================
// ex_alu_b_mux.v
// EX-stage operand B mux for the ALU.
//
// Sources:
//   000 = rs2_data        (from ID/EX, no forwarding)
//   001 = imm             (from ID/EX, for I-type / loads / stores / etc.)
//   010 = ex_mem1_fwd     (forward from EX/MEM1.ex_result)
//   011 = mem1_mem2_fwd   (forward from MEM1/MEM2.ex_result)
//   100 = mem2_mem3_fwd   (forward from MEM2/MEM3.ex_result, non-load)
//   101 = mask_unit_fwd   (forward from MEM3 mask unit output, load)
//   110 = mem3_wb_fwd     (forward from MEM3/WB.write_data)
//   111 = csr_read        (from CSR file, for CSRRS/CSRRC)
//
// sel is 3 bits, driven by the forwarding unit (combined with the
// alu_src_b control field from decode for the rs2 vs imm vs csr distinction).
// =============================================================================

module ex_alu_b_mux (
    input  wire [2:0]  sel,
    input  wire [31:0] rs2_data,
    input  wire [31:0] imm,
    input  wire [31:0] ex_mem1_fwd,
    input  wire [31:0] mem1_mem2_fwd,
    input  wire [31:0] mem2_mem3_fwd,
    input  wire [31:0] mask_unit_fwd,
    input  wire [31:0] mem3_wb_fwd,
    input  wire [31:0] csr_read,
    output reg  [31:0] alu_b
);

    always @(*) begin
        case (sel)
            3'b000: alu_b = rs2_data;
            3'b001: alu_b = imm;
            3'b010: alu_b = ex_mem1_fwd;
            3'b011: alu_b = mem1_mem2_fwd;
            3'b100: alu_b = mem2_mem3_fwd;
            3'b101: alu_b = mask_unit_fwd;
            3'b110: alu_b = mem3_wb_fwd;
            3'b111: alu_b = csr_read;
            default: alu_b = rs2_data;
        endcase
    end

endmodule