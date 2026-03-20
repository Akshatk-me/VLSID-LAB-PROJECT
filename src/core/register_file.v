module register_file (
    input wire clk,
    input wire we,          // Write Enable
    input wire [4:0] rs1,   // Source register 1 address
    input wire [4:0] rs2,   // Source register 2 address
    input wire [4:0] rd,    // Destination register address
    input wire [31:0] wd,   // Write data
    output wire [31:0] rd1, // Read data 1
    output wire [31:0] rd2  // Read data 2
);

    // 32 registers, each 32 bits wide
    reg [31:0] registers [31:0];

    // Synchronous write port
    always @(posedge clk) begin
        // Prevent writing to x0 (hardwired to 0)
        if (we && rd != 5'b00000) begin
            registers[rd] <= wd;
        end
    end

    // Asynchronous read ports
    // Bypassing x0 to always output 0
    assign rd1 = (rs1 == 5'b00000) ? 32'b0 : registers[rs1];
    assign rd2 = (rs2 == 5'b00000) ? 32'b0 : registers[rs2];

endmodule
