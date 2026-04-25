`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2026 02:45:29 AM
// Design Name: 
// Module Name: csr_int_en_reg
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
// csr_int_en_reg.v
// Custom CSR register for Interrupt Enables
// Bits [4:0]   : R/W - 1 UART interrupt + 4 GPIO interrupts
// Bits [31:5]  : Hardwired to 0
// =============================================================================

module csr_int_en_reg (
    input  wire        clk,
    input  wire        rst,
    input  wire        wen,
    input  wire [31:0] wdata,
    output wire [31:0] rdata
);

    // Only 5 bits of actual physical storage are needed
    reg [4:0] int_en;

    always @(posedge clk) begin
        if (rst) begin
            int_en <= 5'b0;
        end else if (wen) begin
            // Capture only the lower 5 bits, ignoring the rest
            int_en <= wdata[4:0];
        end
    end

    // Pad the upper 27 bits with zeros for the read data path
    assign rdata = {27'b0, int_en};

endmodule
