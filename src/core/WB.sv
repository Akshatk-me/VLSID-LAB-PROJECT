module wb_stage (
    // Input from the MEM/WB pipeline register
    input mem_wb_packet_t mem_wb_in,

    // Outputs routing all the way back to the ID Stage (Register File)
    output logic        wb_reg_we,
    output logic [ 4:0] wb_rd_addr,
    output logic [31:0] wb_rd_data
);

    import core_types::*;

    always_comb begin
        // 1. Write Enable Logic
        // We only write to the register file if this instruction is valid 
        // AND it's an instruction that actually targets a register.
        wb_reg_we  = mem_wb_in.valid && mem_wb_in.reg_we;

        // 2. Destination Register Address
        wb_rd_addr = mem_wb_in.rd_addr;

        // 3. The Write-Back Multiplexer
        // If the instruction was a memory read (Load), write the BRAM data.
        // Otherwise, write the ALU or Multiplier result.
        if (mem_wb_in.mem_re) begin
            wb_rd_data = mem_wb_in.mem_data;
        end else begin
            wb_rd_data = mem_wb_in.alu_result;
        end
    end

endmodule
