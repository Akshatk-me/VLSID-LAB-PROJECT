module pipeline_reg #(
    // We default to a 32-bit logic, but we will override this 
    // with our specific structs during instantiation.
    parameter type T = logic [31:0]
) (
    input logic clk,
    input logic rst,

    // Control signals from the Hazard Unit
    input logic stall,  // 1 = Freeze data (don't clock in new data)
    input logic flush,  // 1 = Clear data (turn into a bubble/NOP)

    // Data connections
    input  T data_in,
    output T data_out
);

    always_ff @(posedge clk) begin
        if (rst || flush) begin
            // '0 cleanly zeros out every field in whatever struct type is passed in.
            // Crucially, this sets the 'valid' bit inside the struct to 0, 
            // turning it into a harmless pipeline bubble.
            data_out <= '0;
        end else if (!stall) begin
            // Only clock in the new data if we are not stalling
            data_out <= data_in;
        end
        // If stall == 1, it implicitly holds its current value!
    end

endmodule
