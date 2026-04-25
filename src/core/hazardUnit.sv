module hazard_unit (
    // --- Stall Requests ---
    input logic if_stall,  // IF is waiting for instruction memory
    input logic ex_stall,  // EX is waiting for multiplier
    input logic mem_stall, // MEM is waiting for BRAM/Peripheral

    // --- Load-Use Hazard Detection Inputs ---
    input logic       id_ex_mem_re,
    input logic [4:0] id_ex_rd,
    input logic [4:0] if_id_rs1,
    input logic [4:0] if_id_rs2,

    // --- Control Hazards ---
    input logic branch_taken,

    // --- PC and Pipeline Register Stalls ---
    output logic pc_stall,
    output logic if_id_stall,
    output logic id_ex_stall,
    output logic ex_mem_stall,
    output logic mem_wb_stall,
    output logic backend_stall,

    // --- Pipeline Register Flushes ---
    output logic if_id_flush,
    output logic id_ex_flush,
    output logic ex_mem_flush,
    output logic mem_wb_flush
);

    // ==========================================
    // 1. LOAD-USE HAZARD DETECTION
    // ==========================================
    logic load_use_hazard;
    always_comb begin
        load_use_hazard = 1'b0;
        if (id_ex_mem_re && (id_ex_rd != 5'd0)) begin
            if ((id_ex_rd == if_id_rs1) || (id_ex_rd == if_id_rs2)) begin
                load_use_hazard = 1'b1;
            end
        end
    end

    // ==========================================
    // 2. STALL LOGIC (The Global Rule)
    // ==========================================
    logic global_stall;

    // A stall anywhere freezes the main forward progression
    assign backend_stall = ex_stall || mem_stall;
    assign global_stall  = if_stall || backend_stall;

    // The front of the pipeline stalls for global backpressure OR a Load-Use bubble
    assign pc_stall      = global_stall || load_use_hazard;
    assign if_id_stall   = global_stall || load_use_hazard;

    // ID/EX freezes for any global stall
    assign id_ex_stall   = global_stall;

    // EX/MEM only freezes if MEM itself is stalled. 
    // (If IF stalls, we want MEM to keep draining!)
    assign ex_mem_stall  = mem_stall;

    // WB never stalls in our architecture
    assign mem_wb_stall  = 1'b0;


    // ==========================================
    // 3. FLUSH LOGIC
    // ==========================================
    always_comb begin
        if_id_flush  = 1'b0;
        id_ex_flush  = 1'b0;
        ex_mem_flush = 1'b0;
        mem_wb_flush = 1'b0;

        if (branch_taken) begin
            // Kill the wrong-path instructions fetched after the branch
            if_id_flush = 1'b1;
            id_ex_flush = 1'b1;
        end else if (load_use_hazard) begin
            // Inject a bubble into EX to delay the dependent instruction
            id_ex_flush = 1'b1;
        end
    end

endmodule
