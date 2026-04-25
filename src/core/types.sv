package core_types;

    // 1. Define the packet of data moving from IF to ID
    typedef struct packed {
        logic [31:0] instr;
        logic        valid;
    } if_id_packet_t;

    typedef struct packed {
        logic [31:0] pc;        // Pass the PC along (needed for branch/jump calculations in EX)
        logic [31:0] rs1_data;  // Data read from Register Source 1
        logic [31:0] rs2_data;  // Data read from Register Source 2
        logic [31:0] imm;       // Sign-extended immediate value
        logic [4:0]  rd_addr;   // Destination register address

        // --- NEW SIGNALS ---
        logic [4:0] rs1_addr;  // Needed for Forwarding Unit
        logic [4:0] rs2_addr;  // Needed for Forwarding Unit
        logic       is_jump;   // Needed for EX branch logic

        // Control Signals (Expand these based on your ISA)
        logic       reg_we;     // Register Write Enable
        logic       mem_re;     // Memory Read Enable
        logic       mem_we;     // Memory Write Enable
        logic [3:0] alu_op;     // ALU Operation Code
        logic       alu_src;    // ALU Source (0: rs2, 1: imm)
        logic       is_branch;  // Is this a branch instruction?
        logic       is_mult;
        logic       valid;      // Is this a valid instruction (not a bubble?)
    } id_ex_packet_t;


    typedef struct packed {
        logic [31:0] result;  // The ALU or Multiplier calculated result (often acts as Memory Address)
        logic [31:0] rs2_data;  // Data to be written to memory (for Store instructions)
        logic [4:0] rd_addr;  // Destination register address for WB

        // Control Signals
        logic reg_we;  // Will we eventually write to a register?
        logic mem_re;  // Do we need to read from data memory?
        logic mem_we;  // Do we need to write to data memory?
        logic valid;   // Is this a valid instruction?
    } ex_mem_packet_t;

    typedef struct packed {
        logic [31:0] alu_result;  // Passed through (used for non-memory WB, or as the MMIO address)
        logic [31:0] mem_data;
        logic [4:0] rd_addr;  // Destination register
        logic reg_we;  // Will we write to a register?
        logic mem_re;  // Did we request a memory read? (Tells WB to pick mem data over ALU data)
        logic valid;  // Is this a valid instruction?
    } mem_wb_packet_t;


endpackage
