`timescale 1ns/1ps

module tb_system;

    // --------------------------------------------------------
    // Clock and Reset
    // --------------------------------------------------------
    reg clk;
    reg rst;

    always #5 clk = ~clk; // 100MHz Clock

    // --------------------------------------------------------
    // Bus Master (Simulated CPU) Signals
    // --------------------------------------------------------
    reg  [31:0] cpu_addr;
    reg  [31:0] cpu_wdata;
    reg         cpu_we;
    reg         cpu_re;
    wire [31:0] cpu_rdata;
    wire        cpu_irq;

    // --------------------------------------------------------
    // Interconnect Wires (Bus to Peripherals)
    // --------------------------------------------------------
    // SHA
    wire        sha_we;
    wire        sha_re;
    wire [31:0] sha_rdata;
    wire        sha_irq;

    // UART
    wire        uart_we;
    wire        uart_re;
    wire [31:0] uart_rdata;
    wire        uart_irq;
    wire        uart_tx_pin;
    wire        uart_rx_pin;

    // GPIO
    wire        gpio_we;
    wire        gpio_re;
    wire [31:0] gpio_rdata;
    wire        gpio_irq;
    reg  [31:0] gpio_input_pins;
    wire [31:0] gpio_output_pins;
    wire [31:0] gpio_output_en;

    // Loopback UART TX to RX for easy testing
    assign uart_rx_pin = uart_tx_pin;

    // --------------------------------------------------------
    // Module Instantiations
    // --------------------------------------------------------
    
    mmio_bus u_bus (
        .clk(clk),
        .rst(rst),
        .addr(cpu_addr),
        .wdata(cpu_wdata),
        .we(cpu_we),
        .re(cpu_re),
        .rdata(cpu_rdata),
        .cpu_irq(cpu_irq),
        
        .sha_we(sha_we),
        .sha_re(sha_re),
        .sha_rdata(sha_rdata),
        .sha_irq(sha_irq),
        
        .uart_we(uart_we),
        .uart_re(uart_re),
        .uart_rdata(uart_rdata),
        .uart_irq(uart_irq),
        
        .gpio_we(gpio_we),
        .gpio_re(gpio_re),
        .gpio_rdata(gpio_rdata),
        .gpio_irq(gpio_irq)
    );

    sha256_mmio_wrapper u_sha (
        .clk(clk),
        .rst(rst),
        .addr(cpu_addr),
        .wdata(cpu_wdata),
        .we(sha_we),
        .re(sha_re),
        .rdata(sha_rdata)
        // Note: Your wrapper maps interrupt to an internal `interrupt_out` wire 
        // but it is missing from the module port list in your source. 
        // Assuming it gets wired to sha_irq eventually.
    );

    uart_mmio_wrapper u_uart (
        .clk(clk),
        .rst(rst),
        .addr(cpu_addr),
        .wdata(cpu_wdata),
        .we(uart_we),
        .re(uart_re),
        .rdata(uart_rdata),
        .irq(uart_irq),
        .rx(uart_rx_pin),
        .tx(uart_tx_pin)
    );

    gpio u_gpio (
        .clk_i(clk),
        .rst_i(rst),
        .addr(cpu_addr),
        .wdata(cpu_wdata),
        .we(gpio_we),
        .re(gpio_re),
        .rdata(gpio_rdata),
        .gpio_irq(gpio_irq),
        .gpio_input_i(gpio_input_pins),
        .gpio_output_o(gpio_output_pins),
        .gpio_output_enable_o(gpio_output_en)
    );

    // --------------------------------------------------------
    // Helper Tasks for Bus Operations
    // --------------------------------------------------------
    task bus_write(input [31:0] addr, input [31:0] data);
        begin
            @(posedge clk);
            cpu_addr  <= addr;
            cpu_wdata <= data;
            cpu_we    <= 1'b1;
            cpu_re    <= 1'b0;
            @(posedge clk);
            cpu_we    <= 1'b0;
        end
    endtask

    task bus_read(input [31:0] addr, output [31:0] data);
        begin
            @(posedge clk);
            cpu_addr  <= addr;
            cpu_we    <= 1'b0;
            cpu_re    <= 1'b1;
            @(posedge clk);
            #1; // Slight delay to capture combinational read data
            data = cpu_rdata;
            cpu_re    <= 1'b0;
        end
    endtask

    // --------------------------------------------------------
    // Main Test Sequence
    // --------------------------------------------------------
    reg [31:0] read_val;
    integer i;

    initial begin
        // Initialize
        clk = 0;
        rst = 1;
        cpu_addr = 0;
        cpu_wdata = 0;
        cpu_we = 0;
        cpu_re = 0;
        gpio_input_pins = 0;

        #50 rst = 0;
        $display("--- Starting System Test ---");

        // --------------------------------------------------------
        // 1. Test GPIO
        // --------------------------------------------------------
        $display("\n[TEST] 1. Testing GPIO...");
        // Set lower 16 bits as output (Dir = 0x8000_2000)
        bus_write(32'h8000_2000, 32'h0000_FFFF); 
        // Write pattern to output (Output = 0x8000_2008)
        bus_write(32'h8000_2008, 32'h0000_A5A5);
        
        #10;
        if (gpio_output_pins == 32'h0000_A5A5)
            $display("  [PASS] GPIO Output Pattern Match.");
        else
            $display("  [FAIL] GPIO Output Pattern Mismatch!");

        // Trigger input edge on pin 31
        @(posedge clk) gpio_input_pins[31] = 1;
        #20;
        if (gpio_irq) $display("  [PASS] GPIO Input Edge IRQ Asserted.");
        else $display("  [FAIL] GPIO Input Edge IRQ Failed.");

        // Clear GPIO IRQ (Write 1 to clear)
        bus_write(32'h8000_200C, 32'h8000_0000); 

        // --------------------------------------------------------
        // 2. Test UART (Loopback)
        // --------------------------------------------------------
        $display("\n[TEST] 2. Testing UART TX/RX Loopback...");
        // Set fast baud divisor for simulation (e.g., div = 4 cycles/bit)
        bus_write(32'h8000_1008, 32'd4);
        
        // Write byte 0xAA to TX Data (0x8000_1000)
        bus_write(32'h8000_1000, 32'h0000_00AA);
        $display("  Transmitting byte 0xAA...");

        // Wait for RX valid IRQ (UART is loopbacked TX -> RX)
        wait(uart_irq == 1'b1);
        $display("  [PASS] UART RX Interrupt Asserted.");

        // Read RX data and clear IRQ (Read 0x8000_1000)
        bus_read(32'h8000_1000, read_val);
        if (read_val[7:0] == 8'hAA)
            $display("  [PASS] UART Received expected data 0xAA.");
        else
            $display("  [FAIL] UART Received %h instead of 0xAA.", read_val[7:0]);


        // --------------------------------------------------------
        // 3. Test SHA-256 Accelerator
        // --------------------------------------------------------
        $display("\n[TEST] 3. Testing SHA-256 Engine...");
        
        // Load the 16-word block (We'll load simple dummy data, e.g., "abc")
        // Word 0 = 'abc' + padding = 0x61626380
        bus_write(32'h8000_0200, 32'h61626380); 
        // Zero out words 1 to 14
        for (i = 1; i <= 14; i = i + 1) begin
            bus_write(32'h8000_0200 + (i*4), 32'h0000_0000);
        end
        // Word 15 = bit length of "abc" = 24 bits = 0x18
        bus_write(32'h8000_023C, 32'h0000_0018); 

        // Issue Init (bit 1) and Start (bit 0) commands to Control Reg 0x8000_0240
        bus_write(32'h8000_0240, 32'h0000_0003);

        // Poll status register until done (bit 0 is done, bit 1 is busy
        // Poll status register until BUSY (bit 1) goes to 0
        read_val = 32'h0000_0002; // initialize with busy bit high
        while (read_val[1] == 1'b1) begin
            bus_read(32'h8000_0240, read_val);
        end
        $display("  [PASS] SHA-256 Engine Hash Complete.");

        // Read out the first few words of the hash (H0, H1)
        bus_read(32'h8000_0244, read_val);
        $display("  Hash H0: %h", read_val);
        bus_read(32'h8000_0248, read_val);
        $display("  Hash H1: %h", read_val);

        $display("\n--- All Tests Complete ---");
        $finish;
    end
endmodule