module sha256_mmio_wrapper (
    input  wire        clk,
    input  wire        rst,
    
    // Memory-Mapped Bus Interface (From CPU/MMIO Bridge)
    input  wire [31:0] addr,
    input  wire [31:0] wdata,
    input  wire        we,     // Write Enable
    input  wire        re,     // Read Enable
    output reg  [31:0] rdata,
    output wire        interrupt_out  // <--- ADD THIS LINE!
);

    // --------------------------------------------------------
    // 1. Internal Registers
    // --------------------------------------------------------
    reg [31:0] data_in [15:0]; // 16 words for the 512-bit block
    reg        ctrl_start;     // Bit 0 of CTRL reg (Now a strict pulse)
    reg        ctrl_init;      // Bit 1 of CTRL reg

    reg irq_pending;
    assign interrupt_out = irq_pending; // Route this to your CPU's external interrupt pin
    
    // Wires from the hardware engine
    wire         engine_done;
    wire         engine_busy;  // NEW: Exposed busy state from the engine
    wire [255:0] engine_hash_out;

    // --------------------------------------------------------
    // 2. Write Logic (CPU -> Accelerator)
    // --------------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
	    irq_pending <= 1'b0;
            ctrl_start <= 1'b0;
            ctrl_init  <= 1'b0;
        end else begin
            // Default assignment: ALWAYS pull start low to guarantee a 1-cycle pulse
	    if (engine_done) begin
                 irq_pending <= 1'b1;
            end

            ctrl_start <= 1'b0;

            if (we && (addr[31:12] == 20'h80000)) begin
                case (addr[11:0])
                    // 0x200 to 0x23C: Data Input Registers (W0 to W15)
                    // FIXED: Only allow CPU to write if the engine is NOT currently busy
                    12'h200: if (!engine_busy) data_in[0]  <= wdata;
                    12'h204: if (!engine_busy) data_in[1]  <= wdata;
                    12'h208: if (!engine_busy) data_in[2]  <= wdata;
                    12'h20C: if (!engine_busy) data_in[3]  <= wdata;
                    12'h210: if (!engine_busy) data_in[4]  <= wdata;
                    12'h214: if (!engine_busy) data_in[5]  <= wdata;
                    12'h218: if (!engine_busy) data_in[6]  <= wdata;
                    12'h21C: if (!engine_busy) data_in[7]  <= wdata;
                    12'h220: if (!engine_busy) data_in[8]  <= wdata;
                    12'h224: if (!engine_busy) data_in[9]  <= wdata;
                    12'h228: if (!engine_busy) data_in[10] <= wdata;
                    12'h22C: if (!engine_busy) data_in[11] <= wdata;
                    12'h230: if (!engine_busy) data_in[12] <= wdata;
                    12'h234: if (!engine_busy) data_in[13] <= wdata;
                    12'h238: if (!engine_busy) data_in[14] <= wdata;
                    12'h23C: if (!engine_busy) data_in[15] <= wdata;

                    // 0x240: Control Register
                    12'h240: begin
                        // FIXED: Only accept the start command if the engine is idle
			if (wdata[2]) begin
                            irq_pending <= 1'b0; 
                        end

                        if (!engine_busy) begin
                            ctrl_start <= wdata[0];
                        end
                        ctrl_init <= wdata[1];
                    end
                endcase
            end
        end
    end

    // --------------------------------------------------------
    // 3. Read Logic (Accelerator -> CPU)
    // --------------------------------------------------------
    always @(*) begin
        rdata = 32'b0;
        if (re && (addr[31:12] == 20'h80000)) begin
            case (addr[11:0])
                // 0x240: Status Register 
                // FIXED: Now exposes both Busy (Bit 1) and Done (Bit 0)
                12'h240: rdata = {30'b0, engine_busy, engine_done};

                // 0x244 to 0x260: Hash Output Registers (H0 to H7)
                12'h244: rdata = engine_hash_out[255:224];
                12'h248: rdata = engine_hash_out[223:192];
                12'h24C: rdata = engine_hash_out[191:160];
                12'h250: rdata = engine_hash_out[159:128];
                12'h254: rdata = engine_hash_out[127:96];
                12'h258: rdata = engine_hash_out[95:64];
                12'h25C: rdata = engine_hash_out[63:32];
                12'h260: rdata = engine_hash_out[31:0];
                
                default: rdata = 32'b0;
            endcase
        end
    end

    // --------------------------------------------------------
    // 4. Instantiate the Under-the-Hood Engine
    // --------------------------------------------------------
wire [511:0] full_block = {
        data_in[15], data_in[14], data_in[13], data_in[12],
        data_in[11], data_in[10], data_in[9],  data_in[8],
        data_in[7],  data_in[6],  data_in[5],  data_in[4],
        data_in[3],  data_in[2],  data_in[1],  data_in[0]
    };
    
    sha256_top_engine sha256_inst (
        .clk(clk),
        .rst(rst),
        .start(ctrl_start),
        .init(ctrl_init),
        .block_in(full_block),
        .busy(engine_busy),   // NEW: Wired the busy flag from the engine
        .done(engine_done),
        .hash_out(engine_hash_out)
    );

endmodule
