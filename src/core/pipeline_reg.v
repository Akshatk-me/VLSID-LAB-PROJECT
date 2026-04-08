module if_id_reg (
    input  wire        clk,
    input  wire        rst,
    input  wire        stall, 
    input  wire        flush,

    input  wire [31:0] pc_in,
    input  wire [31:0] instr_in,

    output reg  [31:0] pc_out,
    output reg  [31:0] instr_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        pc_out    <= 32'b0;
        instr_out <= 32'b0;
    end
    else if (flush) begin
        // Insert bubble (NOP)
        pc_out    <= 32'b0;
        instr_out <= 32'b0;
    end
    else if (!stall) begin
        pc_out    <= pc_in;
        instr_out <= instr_in;
    end
    // if stall → hold values
end

endmodule


module id_ex_reg (
    input  wire        clk,
    input  wire        rst,
    input  wire        stall,
    input  wire        flush,

    // Data inputs
    input  wire [31:0] pc_in,
    input  wire [31:0] imm_in,
    input  wire [4:0]  rd_in,
    input  wire [4:0]  rs1_in,
    input  wire [4:0]  rs2_in,
    input  wire [31:0] rs1_data_in,
    input  wire [31:0] rs2_data_in,

    // Control signals
    input  wire        reg_write_en_in,
    input  wire        mem_read_in,
    input  wire        mem_write_in,
    input  wire        alu_src_in,
    input  wire [3:0]  alu_op_in,

    // Outputs
    output reg  [31:0] pc_out,
    output reg  [31:0] imm_out,
    output reg  [4:0]  rd_out,
    output reg  [4:0]  rs1_out,
    output reg  [4:0]  rs2_out,
    output reg  [31:0] rs1_data_out,
    output reg  [31:0] rs2_data_out,

    output reg         reg_write_en_out,
    output reg         mem_read_out,
    output reg         mem_write_out,
    output reg         alu_src_out,
    output reg  [3:0]  alu_op_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        pc_out <= 0; imm_out <= 0;
        rd_out <= 0; rs1_out <= 0; rs2_out <= 0;
        rs1_data_out <= 0; rs2_data_out <= 0;

        reg_write_en_out <= 0;
        mem_read_out     <= 0;
        mem_write_out    <= 0;
        alu_src_out      <= 0;
        alu_op_out       <= 0;
    end
    else if (flush) begin
        // Kill instruction (important for branches)
        reg_write_en_out <= 0;
        mem_read_out     <= 0;
        mem_write_out    <= 0;
        alu_src_out      <= 0;
        alu_op_out       <= 0;
    end
    else if (!stall) begin
        pc_out <= pc_in;
        imm_out <= imm_in;

        rd_out  <= rd_in;
        rs1_out <= rs1_in;
        rs2_out <= rs2_in;

        rs1_data_out <= rs1_data_in;
        rs2_data_out <= rs2_data_in;

        reg_write_en_out <= reg_write_en_in;
        mem_read_out     <= mem_read_in;
        mem_write_out    <= mem_write_in;
        alu_src_out      <= alu_src_in;
        alu_op_out       <= alu_op_in;
    end
end

endmodule

module ex_mem_reg (
    input  wire        clk,
    input  wire        rst,
    input  wire        stall,
    input  wire        flush,

    input  wire [31:0] pc_in,
    input  wire [31:0] alu_result_in,
    input  wire [31:0] rs2_data_in, // for store
    input  wire [4:0]  rd_in,

    input  wire        reg_write_en_in,
    input  wire        mem_read_in,
    input  wire        mem_write_in,

    output reg  [31:0] pc_out,
    output reg  [31:0] alu_result_out,
    output reg  [31:0] rs2_data_out,
    output reg  [4:0]  rd_out,

    output reg         reg_write_en_out,
    output reg         mem_read_out,
    output reg         mem_write_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        pc_out <= 0;
        alu_result_out <= 0;
        rs2_data_out <= 0;
        rd_out <= 0;

        reg_write_en_out <= 0;
        mem_read_out <= 0;
        mem_write_out <= 0;
    end
    else if (flush) begin
        reg_write_en_out <= 0;
        mem_read_out <= 0;
        mem_write_out <= 0;
    end
    else if (!stall) begin
        pc_out <= pc_in;
        alu_result_out <= alu_result_in;
        rs2_data_out <= rs2_data_in;
        rd_out <= rd_in;

        reg_write_en_out <= reg_write_en_in;
        mem_read_out <= mem_read_in;
        mem_write_out <= mem_write_in;
    end
end

endmodule

module mem_wb_reg (
    input  wire        clk,
    input  wire        rst,
    input  wire        stall,

    input  wire [31:0] pc_in,
    input  wire [31:0] result_in,
    input  wire [4:0]  rd_in,
    input  wire        reg_write_en_in,

    output reg  [31:0] pc_out,
    output reg  [31:0] result_out,
    output reg  [4:0]  rd_out,
    output reg         reg_write_en_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        pc_out <= 0;
        result_out <= 0;
        rd_out <= 0;
        reg_write_en_out <= 0;
    end
    else if (!stall) begin
        pc_out <= pc_in;
        result_out <= result_in;
        rd_out <= rd_in;
        reg_write_en_out <= reg_write_en_in;
    end
end

endmodule
