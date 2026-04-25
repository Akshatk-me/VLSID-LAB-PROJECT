module forwarding_unit (
    // What the EX stage wants to read
    input  logic [4:0] id_ex_rs1,
    input  logic [4:0] id_ex_rs2,

    // What the MEM stage is writing
    input  logic       ex_mem_reg_we,
    input  logic [4:0] ex_mem_rd,

    // What the WB stage is writing
    input  logic       mem_wb_reg_we,
    input  logic [4:0] mem_wb_rd,

    // Forwarding Mux Controls (00: Normal, 01: Forward from MEM, 10: Forward from WB)
    output logic [1:0] forward_a,
    output logic [1:0] forward_b
);

    // --- Forwarding Logic for Operand A (rs1) ---
    always_comb begin
        forward_a = 2'b00; // Default: Use the data directly from the ID/EX register

        // Priority 1: EX/MEM Stage (The most recent instruction)
        // Must be a valid write, NOT to the zero register, and the addresses must match.
        if (ex_mem_reg_we && (ex_mem_rd != 5'd0) && (ex_mem_rd == id_ex_rs1)) begin
            forward_a = 2'b01; 
        end 
        // Priority 2: MEM/WB Stage (The older instruction)
        // Only forward if the EX/MEM stage isn't ALREADY forwarding to this same register.
        else if (mem_wb_reg_we && (mem_wb_rd != 5'd0) && (mem_wb_rd == id_ex_rs1)) begin
            forward_a = 2'b10;
        end
    end

    // --- Forwarding Logic for Operand B (rs2) ---
    always_comb begin
        forward_b = 2'b00; // Default: Use the data directly from the ID/EX register

        if (ex_mem_reg_we && (ex_mem_rd != 5'd0) && (ex_mem_rd == id_ex_rs2)) begin
            forward_b = 2'b01;
        end else if (mem_wb_reg_we && (mem_wb_rd != 5'd0) && (mem_wb_rd == id_ex_rs2)) begin
            forward_b = 2'b10;
        end
    end

endmodule
