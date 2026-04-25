// =============================================================================
// mmio_bridge.v
// Address decoder + read mux for the CPU's MEM1 interface.
// Routes loads/stores between BRAM, SHA-256 accelerator, UART, and GPIO.
//
// Address map:
//   0x00000000 - 0x0FFFFFFF : BRAM
//   0x10000000 - 0x1FFFFFFF : SHA-256 accelerator
//   0x20000000 - 0x20000FFF : UART
//   0x20001000 - 0x20001FFF : GPIO
//
// Read latency: BRAM has 2-cycle latency. MMIO peripherals are combinational,
// so the bridge artificially delays MMIO read responses by 2 cycles via an
// internal shift register, matching BRAM timing. This way the pipeline sees
// uniform load latency regardless of target.
// =============================================================================

module mmio_bridge (
    input  wire        clk,
    input  wire        rst,

    // -------------------- CPU side (driven from MEM1) --------------------
    input  wire [31:0] cpu_addr,
    input  wire [31:0] cpu_wdata,
    input  wire        cpu_wen,
    input  wire        cpu_ren,
    input  wire [3:0]  cpu_byte_en,    // byte write strobes (BRAM only)
    output wire [31:0] cpu_rdata,      // load data, 2 cycles after addr (matches BRAM)

    // -------------------- BRAM interface --------------------
    output wire [31:0] bram_addr,
    output wire [31:0] bram_wdata,
    output wire [3:0]  bram_wen,
    input  wire [31:0] bram_dout,

    // -------------------- Accelerator interface --------------------
    output wire        accel_cfg_wen,
    output wire [3:0]  accel_cfg_addr,
    output wire [31:0] accel_cfg_wdata,
    input  wire [255:0] accel_digest,   // 8 word output sliced by addr[4:2]

    // -------------------- UART interface --------------------
    output wire        uart_wen,
    output wire        uart_ren,
    output wire [3:0]  uart_addr,
    output wire [31:0] uart_wdata,
    input  wire [31:0] uart_rdata,

    // -------------------- GPIO interface --------------------
    output wire        gpio_wen,
    output wire        gpio_ren,
    output wire [3:0]  gpio_addr,
    output wire [31:0] gpio_wdata,
    input  wire [31:0] gpio_rdata
);

    // -------------------------------------------------------------------------
    // Address decode (combinational)
    // -------------------------------------------------------------------------
    wire sel_bram  = (cpu_addr[31:28] == 4'h0);
    wire sel_accel = (cpu_addr[31:28] == 4'h1);
    wire sel_mmio  = (cpu_addr[31:28] == 4'h2);
    wire sel_uart  = sel_mmio && (cpu_addr[12] == 1'b0);
    wire sel_gpio  = sel_mmio && (cpu_addr[12] == 1'b1);

    // -------------------------------------------------------------------------
    // BRAM forwarding
    // -------------------------------------------------------------------------
    assign bram_addr  = cpu_addr;
    assign bram_wdata = cpu_wdata;
    assign bram_wen   = (cpu_wen && sel_bram) ? cpu_byte_en : 4'b0;

    // -------------------------------------------------------------------------
    // Accelerator forwarding
    // Config writes go through cfg_*. Digest reads use addr[4:2] to pick a word.
    // -------------------------------------------------------------------------
    assign accel_cfg_wen   = cpu_wen && sel_accel;
    assign accel_cfg_addr  = cpu_addr[3:0];
    assign accel_cfg_wdata = cpu_wdata;

    // Digest read mux: 8 words from the 256-bit digest
    reg [31:0] accel_rdata;
    always @(*) begin
        case (cpu_addr[4:2])
            3'd0: accel_rdata = accel_digest[ 31:  0];
            3'd1: accel_rdata = accel_digest[ 63: 32];
            3'd2: accel_rdata = accel_digest[ 95: 64];
            3'd3: accel_rdata = accel_digest[127: 96];
            3'd4: accel_rdata = accel_digest[159:128];
            3'd5: accel_rdata = accel_digest[191:160];
            3'd6: accel_rdata = accel_digest[223:192];
            3'd7: accel_rdata = accel_digest[255:224];
        endcase
    end

    // -------------------------------------------------------------------------
    // UART forwarding
    // -------------------------------------------------------------------------
    assign uart_wen   = cpu_wen && sel_uart;
    assign uart_ren   = cpu_ren && sel_uart;
    assign uart_addr  = cpu_addr[3:0];
    assign uart_wdata = cpu_wdata;

    // -------------------------------------------------------------------------
    // GPIO forwarding
    // -------------------------------------------------------------------------
    assign gpio_wen   = cpu_wen && sel_gpio;
    assign gpio_ren   = cpu_ren && sel_gpio;
    assign gpio_addr  = cpu_addr[3:0];
    assign gpio_wdata = cpu_wdata;

    // -------------------------------------------------------------------------
    // Combinational MMIO read mux (selected MEM1-cycle data)
    // -------------------------------------------------------------------------
    reg [31:0] mmio_rdata_comb;
    always @(*) begin
        case (1'b1)
            sel_accel: mmio_rdata_comb = accel_rdata;
            sel_uart:  mmio_rdata_comb = uart_rdata;
            sel_gpio:  mmio_rdata_comb = gpio_rdata;
            default:   mmio_rdata_comb = 32'b0;
        endcase
    end

    // Was this cycle's load targeting MMIO (not BRAM)?
    wire mmio_load_now = cpu_ren && (sel_accel || sel_uart || sel_gpio);

    // -------------------------------------------------------------------------
    // 2-cycle delay shift register for MMIO read data
    // Pipes MMIO data through stage1 -> stage2 to match BRAM's 2-cycle latency
    // -------------------------------------------------------------------------
    reg [31:0] mmio_rdata_stage1;
    reg [31:0] mmio_rdata_stage2;
    reg        mmio_valid_stage1;
    reg        mmio_valid_stage2;

    always @(posedge clk) begin
        if (rst) begin
            mmio_rdata_stage1 <= 32'b0;
            mmio_rdata_stage2 <= 32'b0;
            mmio_valid_stage1 <= 1'b0;
            mmio_valid_stage2 <= 1'b0;
        end else begin
            // Stage 1: capture this cycle's MMIO read result
            mmio_rdata_stage1 <= mmio_rdata_comb;
            mmio_valid_stage1 <= mmio_load_now;

            // Stage 2: hold for one more cycle so it surfaces alongside BRAM data
            mmio_rdata_stage2 <= mmio_rdata_stage1;
            mmio_valid_stage2 <= mmio_valid_stage1;
        end
    end

    // -------------------------------------------------------------------------
    // Final read mux to CPU
    // BRAM data arrives 2 cycles after the address was issued; MMIO data
    // arrives via the shift register on the same cycle. Pick whichever was
    // latched as valid by the pipeline.
    // -------------------------------------------------------------------------
    assign cpu_rdata = mmio_valid_stage2 ? mmio_rdata_stage2 : bram_dout;

endmodule