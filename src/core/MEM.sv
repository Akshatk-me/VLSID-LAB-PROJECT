
module mem_stage (
    input logic           clk,
    input logic           rst,
    input ex_mem_packet_t ex_mem_in,

    // NEW: Downstream stall (mem_wb_stall from Hazard Unit)
    // Even though WB doesn't stall in our current design, wiring this makes it future-proof!
    input logic mem_wb_stall,

    cpu_bus_intf.master bus,

    output mem_wb_packet_t mem_wb_out,
    output logic           mem_stall
);
    import core_types::*;

    logic request_pending;

    // Does this instruction actually need the bus?
    logic is_mem_op;
    assign is_mem_op = ex_mem_in.valid && (ex_mem_in.mem_re || ex_mem_in.mem_we);

    // --- State Machine ---
    always_ff @(posedge clk) begin
        if (rst) begin
            request_pending <= 1'b0;
        end else begin
            if (bus.grant) begin
                request_pending <= 1'b1;
            end else if (bus.rdata_valid && bus.ready) begin
                request_pending <= 1'b0;
            end
        end
    end

    // --- Bus Master Interface ---
    assign bus.ready = !mem_stall;

    // Request if it's a memory op, not already pending, and we aren't blocked
    assign bus.req_valid = is_mem_op && !request_pending && !mem_wb_stall;

    assign bus.addr = ex_mem_in.result;  // ALU calculated the memory address
    assign bus.we = ex_mem_in.mem_we;
    assign bus.be = 4'b1111;  // Simplified to Word-only for now
    assign bus.wdata = ex_mem_in.rs2_data;

    // --- Output & Stall Logic ---
    // MEM stalls the CPU if it's a memory op, but the transaction hasn't finished yet
    assign mem_stall = is_mem_op &&
                   ((bus.req_valid && !bus.grant) ||
                    (request_pending && !bus.rdata_valid));

    // Pack the Output Pipeline Register
    always_comb begin
        mem_wb_out            = '0;

        // Instruction is valid to move forward if it's a valid instruction AND we aren't stalling it
        mem_wb_out.valid      = ex_mem_in.valid && !mem_stall;

        mem_wb_out.alu_result = ex_mem_in.result;
        mem_wb_out.mem_data   = bus.rdata;  // Will be safely ignored by WB if mem_re == 0
        mem_wb_out.rd_addr    = ex_mem_in.rd_addr;
        mem_wb_out.reg_we     = ex_mem_in.reg_we;
        mem_wb_out.mem_re     = ex_mem_in.mem_re;
    end

endmodule



// Instead of writing custom memory array, write a wrapper that maps
// dmem_bus_interface directly to the standard ports of the generated BRAM IP

module bram_mmio_wrapper (
    input logic clk,
    input logic rst,

    // The slave side of our memory bus
    dmem_bus_intf.slave dmem
);

    // BRAM usually requires a write enable per byte (4 bits total for 32-bit data)
    logic [3:0] bram_we;
    logic       write_req_d;

    // If bus is valid and requesting a write, apply the byte enables
    assign bram_we = (dmem.req_valid && dmem.we) ? dmem.be : 4'b0000;

    // Track read request (1-cycle pipeline)
    logic read_req_d;

    // Because BRAM read latency is 1 cycle, we delay the 'rdata_valid' signal by 1 cycle
    always_ff @(posedge clk) begin
        if (rst) begin
            read_req_d <= 1'b0;
            write_req_d <= 0;
            dmem.rdata_valid <= 1'b0;

        end else begin
            // If we requested a read this cycle, data will be valid next cycle
            read_req_d  <= (dmem.req_valid && !dmem.we);
            write_req_d <= (dmem.req_valid && dmem.we);

            if (dmem.rdata_valid && dmem.ready) begin
                dmem.rdata_valid <= 0;
            end else if (read_req_d) begin
                dmem.rdata_valid <= 1;
            end
        end

    end

    // --- Instantiate the Vendor BRAM IP ---
    // (This matches standard Xilinx/Intel Native BRAM generator ports)
    blk_mem_gen_0 u_bram (
        .clka (clk),
        .ena  (dmem.req_valid),   // Chip enable (saves power when not accessed)
        .wea  (bram_we),          // 4-bit write enable
        .addra(dmem.addr[31:2]),  // BRAM is word-addressed, so drop the bottom 2 bits!
        .dina (dmem.wdata),       // Data in
        .douta(dmem.rdata)        // Data out (Takes 1 cycle to appear!)
    );

endmodule
