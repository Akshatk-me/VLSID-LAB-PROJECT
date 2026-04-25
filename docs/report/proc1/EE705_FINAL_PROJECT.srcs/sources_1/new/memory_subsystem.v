`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2026 04:13:10 PM
// Design Name: 
// Module Name: memory_subsystem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// =============================================================================
// memory_subsystem.v
// Wraps BRAM, memory arbiter, MMIO bridge, UART, GPIO, and SHA-256 accelerator.
//
// Single 32-bit BRAM port shared between:
//   - CPU fetch unit (instructions)
//   - CPU MEM stage (loads/stores via MMIO bridge)
//   - SHA-256 accelerator (its own memory reads)
//
// MMIO bridge decodes CPU memory requests:
//   - BRAM range:        forwarded to the arbiter's MEM port
//   - Accelerator range: routed to accelerator config + digest read
//   - UART range:        routed to uart_dummy
//   - GPIO range:        routed to gpio_dummy
// =============================================================================

module memory_subsystem (
    input  wire        clk,
    input  wire        rst,

    // ----- Front end (fetch) interface -----
    input  wire [31:0] fetch_addr,
    output wire [31:0] fetch_data,

    // ----- Datapath (MEM stage) interface -----
    input  wire [31:0] cpu_addr,
    input  wire [31:0] cpu_wdata,
    input  wire [3:0]  cpu_wen,
    input  wire        cpu_mem_read,
    input  wire        cpu_mem_write,
    output wire [31:0] cpu_rdata,

    // ----- Hazard interface -----
    output wire        accel_busy,


    // ----- Interrupt controller interface -----
    output wire [4:0]  irq_lines,    // {gpio[3], gpio[2], gpio[1], gpio[0], uart}

    // ----- External testbench events -----
    input  wire        uart_rx_event,
    input  wire [7:0]  uart_rx_event_data,
    input  wire [3:0]  gpio_pin_event,
    input  wire [3:0]  gpio_pin_state
);

    // -------------------------------------------------------------------------
    // MMIO bridge - decodes cpu_addr and routes
    // -------------------------------------------------------------------------
    wire [31:0] bridge_bram_addr;
    wire [31:0] bridge_bram_wdata;
    wire [3:0]  bridge_bram_wen;
    wire [31:0] bram_dout;

    wire        bridge_accel_cfg_wen;
    wire [3:0]  bridge_accel_cfg_addr;
    wire [31:0] bridge_accel_cfg_wdata;
    wire [255:0] accel_digest;

    wire        bridge_uart_wen;
    wire        bridge_uart_ren;
    wire [3:0]  bridge_uart_addr;
    wire [31:0] bridge_uart_wdata;
    wire [31:0] uart_rdata;

    wire        bridge_gpio_wen;
    wire        bridge_gpio_ren;
    wire [3:0]  bridge_gpio_addr;
    wire [31:0] bridge_gpio_wdata;
    wire [31:0] gpio_rdata;

    mmio_bridge u_mmio_bridge (
        .clk             (clk),
        .rst             (rst),

        .cpu_addr        (cpu_addr),
        .cpu_wdata       (cpu_wdata),
        .cpu_wen         (cpu_mem_write),
        .cpu_ren         (cpu_mem_read),
        .cpu_byte_en     (cpu_wen),
        .cpu_rdata       (cpu_rdata),

        .bram_addr       (bridge_bram_addr),
        .bram_wdata      (bridge_bram_wdata),
        .bram_wen        (bridge_bram_wen),
        .bram_dout       (bram_dout),

        .accel_cfg_wen   (bridge_accel_cfg_wen),
        .accel_cfg_addr  (bridge_accel_cfg_addr),
        .accel_cfg_wdata (bridge_accel_cfg_wdata),
        .accel_digest    (accel_digest),

        .uart_wen        (bridge_uart_wen),
        .uart_ren        (bridge_uart_ren),
        .uart_addr       (bridge_uart_addr),
        .uart_wdata      (bridge_uart_wdata),
        .uart_rdata      (uart_rdata),

        .gpio_wen        (bridge_gpio_wen),
        .gpio_ren        (bridge_gpio_ren),
        .gpio_addr       (bridge_gpio_addr),
        .gpio_wdata      (bridge_gpio_wdata),
        .gpio_rdata      (gpio_rdata)
    );

    // -------------------------------------------------------------------------
    // Memory arbiter
    // CPU MEM "side" is the bridge's BRAM interface (only fires when targeting BRAM)
    // -------------------------------------------------------------------------
    wire [31:0] accel_mem_addr;
    wire [31:0] arbiter_bram_addr;
    wire [31:0] arbiter_bram_wdata;
    wire [3:0]  arbiter_bram_wen;
    wire [1:0]  owner_id_issue;
    wire [1:0]  owner_id_resp;

    // MEM-side request to arbiter is asserted when bridge is doing a BRAM access
    wire mem_req_to_arbiter = (cpu_mem_read || cpu_mem_write) && (cpu_addr[31:28] == 4'h0);
    // Accel-side request: accelerator drives an address whenever it's reading
    wire accel_req_to_arbiter = accel_busy;
    mem_arbiter u_mem_arbiter (
        .clk            (clk),
        .rst            (rst),

        .fetch_addr     (fetch_addr),
        .fetch_req      (1'b1),       // fetch always wants the port; arbiter decides
        .mem_addr       (bridge_bram_addr),
        .mem_wdata      (bridge_bram_wdata),
        .mem_wen        (bridge_bram_wen),
        .mem_req        (mem_req_to_arbiter),
        .accel_addr     (accel_mem_addr),
        .accel_req      (accel_req_to_arbiter),

        .bram_addr      (arbiter_bram_addr),
        .bram_wdata     (arbiter_bram_wdata),
        .bram_wen       (arbiter_bram_wen),

        .owner_id_issue (owner_id_issue),
        .owner_id_resp  (owner_id_resp)
    );

    // -------------------------------------------------------------------------
    // BRAM (single port, en tied to 1)
    // -------------------------------------------------------------------------
    bram u_bram (
        .clk   (clk),
        .en    (1'b1),
        .wea   (arbiter_bram_wen),
        .addra ({2'b00, arbiter_bram_addr[13:2]}),  // byte addr -> word index (shift right by 2)
        .dina  (arbiter_bram_wdata),
        .douta (bram_dout)
    );  

    // -------------------------------------------------------------------------
    // SHA-256 accelerator
    // -------------------------------------------------------------------------
    sha256_accel u_sha256_accel (
        .clk            (clk),
        .rst            (rst),
    
        .cfg_wen        (bridge_accel_cfg_wen),
        .cfg_addr       (bridge_accel_cfg_addr),
        .cfg_wdata      (bridge_accel_cfg_wdata),
    
        .accel_mem_addr (accel_mem_addr),
        .accel_mem_data (bram_dout),
    
        .accel_busy     (accel_busy),
    
        .digest_out     (accel_digest)
    );

    // -------------------------------------------------------------------------
    // UART dummy
    // -------------------------------------------------------------------------
    wire irq_uart;

    uart_dummy u_uart_dummy (
        .clk            (clk),
        .rst            (rst),

        .mmio_wen       (bridge_uart_wen),
        .mmio_addr      (bridge_uart_addr),
        .mmio_wdata     (bridge_uart_wdata),
        .mmio_ren       (bridge_uart_ren),
        .mmio_rdata     (uart_rdata),

        .rx_event       (uart_rx_event),
        .rx_event_data  (uart_rx_event_data),

        .irq_uart       (irq_uart)
    );

    // -------------------------------------------------------------------------
    // GPIO dummy
    // -------------------------------------------------------------------------
    wire [3:0] irq_gpio;

    gpio_dummy u_gpio_dummy (
        .clk        (clk),
        .rst        (rst),

        .mmio_wen   (bridge_gpio_wen),
        .mmio_addr  (bridge_gpio_addr),
        .mmio_wdata (bridge_gpio_wdata),
        .mmio_ren   (bridge_gpio_ren),
        .mmio_rdata (gpio_rdata),

        .pin_event  (gpio_pin_event),
        .pin_state  (gpio_pin_state),

        .irq_gpio   (irq_gpio)
    );

    // -------------------------------------------------------------------------
    // Compose interrupt lines: {gpio[3], gpio[2], gpio[1], gpio[0], uart}
    // (UART = bit 0 = highest priority per interrupt_controller convention)
    // -------------------------------------------------------------------------
    assign irq_lines = {irq_gpio[3], irq_gpio[2], irq_gpio[1], irq_gpio[0], irq_uart};

    // -------------------------------------------------------------------------
    // Fetch data: BRAM response goes directly to the fetch unit
    // (Fetch tracks its own valid bits; if bram_dout corresponds to a different
    // owner this cycle, fetch's v_p1 is 0 and it drops the data.)
    // -------------------------------------------------------------------------
    assign fetch_data = bram_dout;

endmodule
