`include "rv32i_defines.vh"
module control_unit (
    input  wire        clk,
    input  wire        rst,
    
    input  wire [6:0]  opcode,
    input  wire [2:0]  funct3,
    input  wire [6:0]  funct7,
    
    output reg         pc_write,
    output reg         ir_write,
    output reg         reg_write,
    
    output reg  [1:0]  alu_src_a,
    output reg  [1:0]  alu_src_b,
    output reg  [1:0]  result_src,
    output reg  [1:0]  alu_op,      // → goes to ALUControl
    output reg adr_src, // o for PC, 1 for ALU_Result
    
    output reg         mem_we,
    output reg         mem_re
);

    // -------------------------
    // State Encoding (pure Verilog)
    // -------------------------
    reg [3:0] state, next_state;

    localparam FETCH      = 4'd0;
    localparam FETCH_WAIT = 4'd1;
    localparam DECODE     = 4'd2;
    localparam EXECUTE    = 4'd3;
    localparam MEM        = 4'd4;
    localparam MEM_WAIT   = 4'd5;
    localparam WRITEBACK  = 4'd6;

    // -------------------------
    // Opcode Definitions
    // -------------------------
    localparam OP_RTYPE  = 7'b0110011;
    localparam OP_ITYPE  = 7'b0010011;
    localparam OP_LOAD   = 7'b0000011;
    localparam OP_STORE  = 7'b0100011;
    localparam OP_BRANCH = 7'b1100011;

    // -------------------------
    // State Register
    // -------------------------
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= FETCH;
        else
            state <= next_state;
    end

    // -------------------------
    // Next State Logic
    // -------------------------
    always @(*) begin
        case (state)
            FETCH:        next_state = FETCH_WAIT;
            FETCH_WAIT:   next_state = DECODE;

            DECODE: begin
                case (opcode)
                    OP_RTYPE,
                    OP_ITYPE: next_state = EXECUTE;

                    OP_LOAD,
                    OP_STORE: next_state = EXECUTE;

                    OP_BRANCH: next_state = EXECUTE;

                    default: next_state = FETCH;
                endcase
            end

            EXECUTE: begin
                case (opcode)
                    OP_LOAD,
                    OP_STORE: next_state = MEM;

                    OP_BRANCH: next_state = FETCH;

                    default: next_state = WRITEBACK;
                endcase
            end

            MEM:        next_state = MEM_WAIT;

            MEM_WAIT: begin
                if (opcode == OP_LOAD)
                    next_state = WRITEBACK;
                else
                    next_state = FETCH;
            end

            WRITEBACK: next_state = FETCH;

            default: next_state = FETCH;
        endcase
    end

    // -------------------------
    // Output Logic (NO LATCHES)
    // -------------------------
    always @(*) begin
        // Defaults
        pc_write   = 0;
        ir_write   = 0;
        reg_write  = 0;
        alu_src_a  = 0;
        alu_src_b  = 0;
        result_src = 0;
        alu_op     = 2'b00;
        mem_we     = 0;
        mem_re     = 0;

        case (state)

            // FETCH
            // -------------------------
            FETCH: begin
                mem_re    = 1;
                alu_src_a = 2'b00; // PC
                alu_src_b = 2'b10; // +4
            end

            FETCH_WAIT: begin
                mem_re   = 1;   // HOLD for BRAM
                ir_write = 1;
                pc_write = 1;
            end

            // DECODE
            // -------------------------
            DECODE: begin
                // nothing
            end

            // EXECUTE
            // -------------------------
            EXECUTE: begin
                case (opcode)

                    OP_RTYPE: begin
                        alu_src_a = 2'b01;
                        alu_src_b = 2'b00;
                        alu_op    = 2'b10;
                    end

                    OP_ITYPE: begin
                        alu_src_a = 2'b01;
                        alu_src_b = 2'b01;
                        alu_op    = 2'b10;
                    end

                    OP_LOAD,
                    OP_STORE: begin
                        alu_src_a = 2'b01;
                        alu_src_b = 2'b01;
                        alu_op    = 2'b00;
                    end

                    OP_BRANCH: begin
                        alu_src_a = 2'b01;
                        alu_src_b = 2'b00;
                        alu_op    = 2'b01;
                        pc_write  = 1; // (later gate with condition)
                    end
                endcase
            end

            // MEM
            // -------------------------
            MEM: begin
                if (opcode == OP_LOAD)
                    mem_re = 1;
                else if (opcode == OP_STORE)
                    mem_we = 1;
            end

            MEM_WAIT: begin
                if (opcode == OP_LOAD)
                    mem_re = 1;
                else if (opcode == OP_STORE)
                    mem_we = 1;
            end

            // WRITEBACK
            // -------------------------
            WRITEBACK: begin
                reg_write = 1;

                if (opcode == OP_LOAD)
                    result_src = 2'b01; // memory
                else
                    result_src = 2'b00; // ALU
            end

        endcase
    end

endmodule
