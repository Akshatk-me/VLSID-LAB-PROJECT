module pc_unit (
    input  logic        clk,
    input  logic        rst,      // Assuming active-high synchronous reset
    input  logic        stall,    // High means pause PC execution
    input  logic [31:0] next_pc,  // Next PC value (e.g., PC+4 or Branch Target)
    output logic [31:0] pc        // Current PC value
);

    // Standard Reset Vector (Update this based on your specific architecture)
    localparam logic [31:0] RESET_VECTOR = 32'h0000_0000;

    always_ff @(posedge clk) begin
        if (rst) begin
            pc <= RESET_VECTOR;
        end else if (!stall) begin
            pc <= next_pc;
        end
        // Note: If stall is 1, pc implicitly holds its current value.
    end

endmodule
