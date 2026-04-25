module reg_file (
    input  logic        clk,
    input  logic        rst,
    
    // Read Port 1 (Combinational)
    input  logic [4:0]  rs1_addr,
    output logic [31:0] rs1_data,
    
    // Read Port 2 (Combinational)
    input  logic [4:0]  rs2_addr,
    output logic [31:0] rs2_data,
    
    // Write Port (Synchronous)
    input  logic        reg_we,
    input  logic [4:0]  rd_addr,
    input  logic [31:0] rd_data
);

    // The actual memory array: 32 registers, 32 bits wide
    logic [31:0] registers [31:0];

    // --- Asynchronous Reads ---
    // If the address is 0, always output 0. Otherwise, read the array.
    assign rs1_data = (rs1_addr == 5'd0) ? 32'd0 : registers[rs1_addr];
    assign rs2_data = (rs2_addr == 5'd0) ? 32'd0 : registers[rs2_addr];

    // --- Synchronous Write ---
    always_ff @(posedge clk) begin
        if (rst) begin
            // Loop to clear all registers on reset (great for clean simulations)
            for (int i = 1; i < 32; i++) begin
                registers[i] <= 32'd0;
            end
        end else if (reg_we && rd_addr != 5'd0) begin
            // Write data only if Write Enable is high AND we aren't writing to x0
            registers[rd_addr] <= rd_data;
        end
    end

endmodule
