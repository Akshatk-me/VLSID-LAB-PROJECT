
module id_stage (
    input logic clk,
    input logic rst,

    // Input from IF Stage
    input if_id_packet_t if_id_in,

    // Write-Back Interface (From the final WB stage)
    input logic        wb_reg_we,
    input logic [ 4:0] wb_rd_addr,
    input logic [31:0] wb_rd_data,

    // Output to EX Stage
    output id_ex_packet_t id_ex_out
);
    import core_types::*;

    // Guts of the decoder will go here...
    // Extracting RISC-V Instruction Fields

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [4:0] rs1_addr, rs2_addr, rd_addr;

    assign opcode   = if_id_in.instr[6:0];
    assign rd_addr  = if_id_in.instr[11:7];
    assign funct3   = if_id_in.instr[14:12];
    assign rs1_addr = if_id_in.instr[19:15];
    assign rs2_addr = if_id_in.instr[24:20];
    assign funct7   = if_id_in.instr[31:25];


    // Immediate generation
    logic [31:0] imm_ext;

    always_comb begin
        // Default to zero to prevent latches
        imm_ext = 32'b0;

        unique case (opcode)
            7'b0010011,  // I-Type (e.g., ADDI, LW)
            7'b0000011:  // I-Type Load
            imm_ext = {{20{if_id_in.instr[31]}}, if_id_in.instr[31:20]};

            7'b0100011:  // S-Type (e.g., SW)
            imm_ext = {{20{if_id_in.instr[31]}}, if_id_in.instr[31:25], if_id_in.instr[11:7]};

            7'b1100011:  // B-Type (e.g., BEQ)
            imm_ext = {
                {20{if_id_in.instr[31]}},
                if_id_in.instr[7],
                if_id_in.instr[30:25],
                if_id_in.instr[11:8],
                1'b0
            };

            // (You can add U-Type and J-Type here)
            default: imm_ext = 32'b0;
        endcase
    end


    // --- 2. Register File Instantiation ---
    logic [31:0] rs1_data_out;
    logic [31:0] rs2_data_out;

    reg_file u_reg_file (
        .clk(clk),
        .rst(rst),

        // Read connections
        .rs1_addr(rs1_addr),
        .rs1_data(rs1_data_out),
        .rs2_addr(rs2_addr),
        .rs2_data(rs2_data_out),

        // Write connections (fed from the WB stage inputs)
        .reg_we (wb_reg_we),
        .rd_addr(wb_rd_addr),
        .rd_data(wb_rd_data)
    );

    // Main Control Unit
    always_comb begin
        // Carry forward the valid bit (or clear it if we need a bubble) 
        id_ex_out.valid = if_id_in.valid;

        // Data and addresses 
        id_ex_out.rs1_addr = rs1_addr;
        id_ex_out.rs2_addr = rs2_addr;
        id_ex_out.rs1_data = rs1_data_out;
        id_ex_out.rs2_data = rs2_data_out;
        id_ex_out.imm = imm_ext;
        id_ex_out.rd_addr = rd_addr;


        // 1. Default Assignments (Crucial to prevent inferred latches!)
        id_ex_out.reg_we    = 1'b0;
        id_ex_out.mem_re    = 1'b0;
        id_ex_out.mem_we    = 1'b0;
        id_ex_out.alu_src   = 1'b0; // 0 = rs2, 1 = imm
        id_ex_out.is_branch = 1'b0;
        id_ex_out.is_mult   = 1'b0; // NEW: M-extension flag
        // (Default ALU op code here)

        // 2. Decode based on opcode
        unique case (opcode)
            7'b0110011: begin  // R-Type (ALU & M-Extension)
                id_ex_out.reg_we  = 1'b1;
                id_ex_out.alu_src = 1'b0;  // Use rs2, not imm

                // M-Extension Check
                if (funct7 == 7'b0000001) begin
                    // It's a Multiply instruction! 
                    if (funct3[2] == 1'b0) id_ex_out.is_mult = 1'b1;
                    else begin
                        // Division not supported -> treat as invalid or
                        // NOP, here NOP is fine
                        id_ex_out.valid = 1'b0;
                    end
                    // (You could use funct3 to specify MUL vs MULH, etc.)
                end else begin
                    // Standard R-Type ALU (ADD, SUB, XOR, etc.)
                    // (Set ALU op based on funct3 and funct7[5])
                end
            end

            7'b0010011: begin  // I-Type ALU (ADDI, XORI, etc.)
                id_ex_out.reg_we  = 1'b1;
                id_ex_out.alu_src = 1'b1;  // Use immediate!
                // (Set ALU op based on funct3)
            end

            // (Add cases for Load, Store, Branch, etc.)
            default: ;  // Do nothing, keep defaults
        endcase
    end



endmodule
