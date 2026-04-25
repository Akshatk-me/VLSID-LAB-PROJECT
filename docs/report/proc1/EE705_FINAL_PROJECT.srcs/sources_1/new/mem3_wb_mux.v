`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 07:48:19 AM
// Design Name: 
// Module Name: mem3_wb_mux
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
// mem3_wb_mux.v
// MEM3-stage writeback mux. Selects between the EX-stage result (carried
// through MEM1, MEM2, MEM3) and the aligned load data from the load mask
// unit. Result feeds MEM3/WB.write_data_in.
//
// sel encoding:
//   0 = ex_result    (non-load: ALU result, imm, csr_read, pc_plus_4, mul)
//   1 = load_data    (load: aligned + extended data from load_mask_unit)
//
// In practice the select signal is the mem_read bit carried through to
// MEM2/MEM3 (=> MEM3 stage logic).
// =============================================================================

module mem3_wb_mux (
    input  wire        sel,
    input  wire [31:0] ex_result,
    input  wire [31:0] load_data,
    output reg  [31:0] write_data
);

    always @(*) begin
        case (sel)
            1'b0: write_data = ex_result;
            1'b1: write_data = load_data;
            default: write_data = ex_result;
        endcase
    end

endmodule
