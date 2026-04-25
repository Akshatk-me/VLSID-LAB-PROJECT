// State Encodings
`define FETCH      4'd0
`define FETCH_WAIT 4'd1
`define DECODE     4'd2
`define EXECUTE    4'd3
`define MEM        4'd4
`define MEM_WAIT   4'd5
`define WRITEBACK  4'd6

// ALU Operations (alu_sel)
`define ALU_ADD    5'b00000
`define ALU_SUB    5'b00001
`define ALU_AND    5'b01001
`define ALU_OR     5'b01000
`define ALU_XOR    5'b00101
`define ALU_SLL    5'b00010
`define ALU_SRL    5'b00110
`define ALU_SRA    5'b00111
`define ALU_SLT    5'b00011
`define ALU_SLTU   5'b00104
`define ALU_COPY_B 5'b01010

// ALU Opcode Types (alu_op)
`define ALUOP_LOAD_STORE 2'b00
`define ALUOP_BRANCH     2'b01
`define ALUOP_RTYPE      2'b10
