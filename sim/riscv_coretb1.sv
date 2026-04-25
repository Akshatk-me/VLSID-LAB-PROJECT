module riscv_coretb1;
    logic clk = 0;
    logic rst = 1;

    always #5 clk = ~clk;

    cpu_bus_intf instr_bus ();
    cpu_bus_intf data_bus ();

    // 2. Declare the interconnect's peripheral buses
    cpu_bus_intf bram_bus ();
    cpu_bus_intf uart_bus ();  // Leave disconnected for now
    cpu_bus_intf sha_bus ();  // Leave disconnected for now
    cpu_bus_intf gpio_bus ();  // Leave disconnected for now

    // 3. Instantiate the CPU
    riscv_core uut (
        .clk      (clk),
        .rst      (rst),
        .instr_bus(instr_bus),
        .data_bus (data_bus)
    );

    // 4. Instantiate the Interconnect
    mmio_interconnect u_interconnect (
        .clk      (clk),
        .rst      (rst),
        .instr_bus(instr_bus),
        .data_bus (data_bus),
        .bram_bus (bram_bus),
        .uart_bus (uart_bus),
        .sha_bus  (sha_bus),
        .gpio_bus (gpio_bus)
    );

    // 5. Instantiate the BRAM!
    bram_wrapper #(
        .DEPTH    (1024),
        .INIT_FILE("program.hex")  // Path depends on where you run 'make' from
    ) u_bram (
        .clk(clk),
        .rst(rst),
        .bus(bram_bus)
    );

    // ========== ADD VCD DUMPING HERE ==========
    initial begin
        // Set the VCD output file name
        $dumpfile("waveform.vcd");

        // Dump all variables in the design
        $dumpvars(0, riscv_coretb1);

        // Optional: Print a message confirming VCD dumping
        $display("Starting VCD dump...");
    end

    // Generate reset and run simulation
    initial begin
        #10 rst = 0;  // Release reset after 10ns
        #10000;  // Run for 10us (adjust as needed)
        $finish;
    end

endmodule
