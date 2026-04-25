`timescale 1ns / 1ps

module pynq_top (
    input wire sysclk, // PYNQ-Z2 125 MHz clock (H16)
    input wire btn0    // PYNQ-Z2 Button 0 for Reset (D19)
);

    // Synchronize reset to active-high for your design
    reg rst_sync;
    always @(posedge sysclk) rst_sync <= btn0;

    // --------------------------------------------------------
    // VIO Signals (Acting as the CPU)
    // --------------------------------------------------------
    wire [31:0] vio_addr;
    wire [31:0] vio_wdata;
    wire        vio_we;
    wire        vio_re;
    wire [31:0] bus_rdata;
    wire        bus_irq;

    // --------------------------------------------------------
    // Instantiate Your System
    // --------------------------------------------------------
    wire sha_we, sha_re, sha_irq;
    wire uart_we, uart_re, uart_irq;
    wire gpio_we, gpio_re, gpio_irq;
    wire [31:0] sha_rdata, uart_rdata, gpio_rdata;

    mmio_bus u_bus (
        .clk(sysclk), .rst(rst_sync),
        .addr(vio_addr), .wdata(vio_wdata), .we(vio_we), .re(vio_re),
        .rdata(bus_rdata), .cpu_irq(bus_irq),
        
        .sha_we(sha_we), .sha_re(sha_re), .sha_rdata(sha_rdata), .sha_irq(sha_irq),
        .uart_we(uart_we), .uart_re(uart_re), .uart_rdata(uart_rdata), .uart_irq(uart_irq),
        .gpio_we(gpio_we), .gpio_re(gpio_re), .gpio_rdata(gpio_rdata), .gpio_irq(gpio_irq)
    );

    sha256_mmio_wrapper u_sha (
        .clk(sysclk), .rst(rst_sync), .addr(vio_addr), .wdata(vio_wdata),
        .we(sha_we), .re(sha_re), .rdata(sha_rdata)
    );

    // Dummy wires for unused physical pins in this pure-VIO test
    wire tx_dummy;
    uart_mmio_wrapper u_uart (
        .clk(sysclk), .rst(rst_sync), .addr(vio_addr), .wdata(vio_wdata),
        .we(uart_we), .re(uart_re), .rdata(uart_rdata),
        .irq(uart_irq), .rx(tx_dummy), .tx(tx_dummy) // Internal loopback
    );

    gpio u_gpio (
        .clk_i(sysclk), .rst_i(rst_sync), .addr(vio_addr), .wdata(vio_wdata),
        .we(gpio_we), .re(gpio_re), .rdata(gpio_rdata),
        .gpio_irq(gpio_irq), .gpio_input_i(32'b0),
        .gpio_output_o(), .gpio_output_enable_o()
    );

    // --------------------------------------------------------
    // VIO IP (Virtual CPU)
    // --------------------------------------------------------
    vio_0 u_vio (
        .clk(sysclk),
        .probe_in0(bus_rdata),   // 32-bit: Read data back from bus
        .probe_in1(bus_irq),     // 1-bit:  System interrupt
        .probe_out0(vio_addr),   // 32-bit: Address to write/read
        .probe_out1(vio_wdata),  // 32-bit: Data to write
        .probe_out2(vio_we),     // 1-bit:  Write Enable
        .probe_out3(vio_re)      // 1-bit:  Read Enable
    );

    // --------------------------------------------------------
    // ILA IP (Logic Analyzer)
    // --------------------------------------------------------
    ila_0 u_ila (
        .clk(sysclk),
        .probe0(vio_addr),       // 32-bit
        .probe1(vio_wdata),      // 32-bit
        .probe2(bus_rdata),      // 32-bit
        .probe3(vio_we),         // 1-bit
        .probe4(bus_irq)         // 1-bit
    );

endmodule