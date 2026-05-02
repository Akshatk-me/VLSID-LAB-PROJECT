import core_types::*;
module ex_stage (
    input logic clk,
    input logic rst,

    // Input from Decode Stage
    // If we go multicycle it's assumed id_ex_in will be stalled properly 
    // Otherwise we'll need to create internal register to save state of
    // id_ex_in, for operand, etc storage
    input id_ex_packet_t id_ex_in,

    // Outputs to the rest of the CPU
    output logic ex_stall,  // Halts the PC, IF, and ID stages

    output logic        branch_taken,
    output logic [31:0] branch_target,


    // We define an ex_mem_packet_t in our package for the next stage
    output ex_mem_packet_t ex_mem_out,

    // Forwarded Signals 
    input logic [ 1:0] forward_a,
    input logic [ 1:0] forward_b,
    input logic [31:0] forwarded_mem_data,  // Data coming from EX/MEM register 
    input logic [31:0] forwarded_wb_data    // Data coming from MEM/WB register 
);

    logic [31:0] forwarded_rs1;
    logic [31:0] forwarded_rs2;

    // 1. Resolve Forwarding Muxes First 
    always_comb begin
        case (forward_a)
            2'b01:   forwarded_rs1 = forwarded_mem_data;
            2'b10:   forwarded_rs1 = forwarded_wb_data;
            default: forwarded_rs1 = id_ex_in.rs1_data;
        endcase

        case (forward_b)
            2'b01:   forwarded_rs2 = forwarded_mem_data;
            2'b10:   forwarded_rs2 = forwarded_wb_data;
            default: forwarded_rs2 = id_ex_in.rs2_data;
        endcase

    end


    // --- 1. ALU Datapath Setup ---
    logic [31:0] alu_operand_a;
    logic [31:0] alu_operand_b;
    logic [31:0] alu_result;

    assign alu_operand_a = forwarded_rs1;
    // Mux for Operand B: Choose between rs2 and the Immediate
    assign alu_operand_b = id_ex_in.alu_src ? id_ex_in.imm : forwarded_rs2;

    // --- 2. Standard Combinational ALU ---
    always_comb begin
        // Example basic ALU logic (Expand based on your alu_op codes)
        alu_result = 32'd0;
        if (id_ex_in.valid)
            unique case (id_ex_in.alu_op)
                4'b0000: alu_result = alu_operand_a + alu_operand_b;  // ADD
                4'b0001: alu_result = alu_operand_a - alu_operand_b;  // SUB
                4'b0010: alu_result = alu_operand_a & alu_operand_b;  // AND
                4'b0011: alu_result = alu_operand_a | alu_operand_b;  // OR
                4'b0100: alu_result = alu_operand_a ^ alu_operand_b;  // XOR
                // ... shifts and comparisons go here ...
                default: alu_result = 32'd0;
            endcase
    end

    // --- 3. The Multiplier ---
    logic [63:0] mul_result_64;
    logic [31:0] mul_result;
    logic        mul_done;
    logic        start_mul;
    logic        mul_active;


    // Don't rely on id_ex_in.is_mult, EX should remember it's doing
    // multiplication
    always_ff @(posedge clk) begin
        if (rst) mul_active <= 0;
        else begin
            if (id_ex_in.valid && id_ex_in.is_mult && !mul_active) mul_active <= 1;
            else if (mul_done) mul_active <= 0;
        end
    end




    assign mul_result = mul_result_64[31:0];  // for MUL

    // Start the multiplier only if this is a valid instruction AND it's a multiply
    // AND we aren't already computing it (prevents restarting in the middle)
    assign start_mul  = id_ex_in.valid && id_ex_in.is_mult && !mul_active;

    radix4_multiplier u_mul (
        .clk         (clk),
        .rst         (rst),
        .start       (start_mul),
        .multiplicand(forwarded_rs1),
        .multiplier  (forwarded_rs2),
        .result_64   (mul_result_64),
        .done        (mul_done)
    );

    // --- 4. Stall Logic ---
    // If the instruction is a multiply, we MUST stall until `mul_done` goes high.
    assign ex_stall = (id_ex_in.valid && id_ex_in.is_mult && !mul_done);

    // --- 5. Pack the Output to the MEM Stage ---
    always_comb begin
        ex_mem_out = '0;  // Ensure it's zero initialized before we use it
        ex_mem_out.valid = id_ex_in.valid && !ex_stall;  // Don't pass valid data while stalling!

        // Final Result Mux: Choose between ALU and Multiplier
        if (mul_active)
            ex_mem_out.result  = mul_done ? mul_result : 32'd0; // Till multiplication is done have 0 as result
        else ex_mem_out.result = alu_result;

        // Pass control signals forward
        ex_mem_out.rd_addr  = id_ex_in.rd_addr;
        ex_mem_out.reg_we   = id_ex_in.reg_we;
        ex_mem_out.mem_re   = id_ex_in.mem_re;
        ex_mem_out.mem_we   = id_ex_in.mem_we;
        ex_mem_out.rs2_data = id_ex_in.rs2_data;  // Needed for store instructions in MEM
    end

    // --- 6. Branch and Jump Logic ---
    always_comb begin
        branch_taken  = 1'b0;
        branch_target = 32'd0;

        if (id_ex_in.valid) begin
            // By default, the target is usually PC + Immediate (for JAL and Branches)
            // Note: If you have JALR, the target is rs1_data + Immediate
            branch_target = id_ex_in.pc + id_ex_in.imm;

            // Example generic catch-all for Jumps (JAL / JALR)
            if (id_ex_in.is_jump) begin
                branch_taken = 1'b1;
            end  // Example generic Branch (BEQ)
                 // To support BNE, BLT, BGE, etc., you will expand this using the instruction's funct3
            else if (id_ex_in.is_branch) begin
                if (alu_operand_a == alu_operand_b) begin  // Simplest BEQ condition
                    branch_taken = 1'b1;
                end
            end
        end
    end

endmodule
