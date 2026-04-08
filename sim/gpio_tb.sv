`timescale 1ns/1ps

module gpio_tb;
    // Clock / reset
    reg clk_i;
    reg rst_i;

    // Bus interface
    reg         bus_awvalid_i;
    reg [31:0]  bus_awaddr_i;
    reg         bus_wvalid_i;
    reg [31:0]  bus_wdata_i;
    reg [3:0]   bus_wstrb_i;
    reg         bus_bready_i;
    reg         bus_arvalid_i;
    reg [31:0]  bus_araddr_i;
    reg         bus_rready_i;

    // GPIO pins
    reg  [31:0] gpio_input_i;
    wire [31:0] gpio_output_o;
    wire [31:0] gpio_output_enable_o;

    // DUT responses
    wire        bus_awready_o;
    wire        bus_wready_o;
    wire        bus_bvalid_o;
    wire [1:0]  bus_bresp_o;
    wire        bus_arready_o;
    wire        bus_rvalid_o;
    wire [31:0] bus_rdata_o;
    wire [1:0]  bus_rresp_o;

    // Instantiate DUT
    gpio dut (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .bus_awvalid_i(bus_awvalid_i),
        .bus_awaddr_i(bus_awaddr_i),
        .bus_wvalid_i(bus_wvalid_i),
        .bus_wdata_i(bus_wdata_i),
        .bus_wstrb_i(bus_wstrb_i),
        .bus_bready_i(bus_bready_i),
        .bus_arvalid_i(bus_arvalid_i),
        .bus_araddr_i(bus_araddr_i),
        .bus_rready_i(bus_rready_i),
        .gpio_input_i(gpio_input_i),
        .bus_awready_o(bus_awready_o),
        .bus_wready_o(bus_wready_o),
        .bus_bvalid_o(bus_bvalid_o),
        .bus_bresp_o(bus_bresp_o),
        .bus_arready_o(bus_arready_o),
        .bus_rvalid_o(bus_rvalid_o),
        .bus_rdata_o(bus_rdata_o),
        .bus_rresp_o(bus_rresp_o),
        .gpio_output_o(gpio_output_o),
        .gpio_output_enable_o(gpio_output_enable_o)
    );

    // Local address map (matches gpio.v)
    localparam [7:0] GPIO_DIRECTION = 8'h00;
    localparam [7:0] GPIO_INPUT     = 8'h04;
    localparam [7:0] GPIO_OUTPUT    = 8'h08;

    // Clock generation: 100 MHz
    initial clk_i = 1'b0;
    always #5 clk_i = ~clk_i;

    task fail(input [1023:0] msg);
        begin
            $display("FAIL: %0s", msg);
            $finish;
        end
    endtask

    // Simple bus helpers (single outstanding read or write, matching DUT behavior)
    task write_reg(input [7:0] addr, input [31:0] data);
        begin
            // Present request
            bus_awaddr_i  <= {24'b0, addr};
            bus_wdata_i   <= data;
            bus_awvalid_i <= 1'b1;
            bus_wvalid_i  <= 1'b1;

            // Wait for acceptance (AW channel)
            while (!bus_awready_o)
                @(posedge clk_i);
            @(posedge clk_i);

            // Deassert valids after handshake
            bus_awvalid_i <= 1'b0;
            bus_wvalid_i  <= 1'b0;

            // Wait for response
            while (!bus_bvalid_o)
                @(posedge clk_i);

            // Accept response
            bus_bready_i <= 1'b1;
            @(posedge clk_i);
            bus_bready_i <= 1'b0;
        end
    endtask

    task read_reg(input [7:0] addr, output [31:0] data);
        begin
            bus_araddr_i  <= {24'b0, addr};
            bus_arvalid_i <= 1'b1;

            // Wait for acceptance (AR channel)
            while (!bus_arready_o)
                @(posedge clk_i);
            @(posedge clk_i);

            // Deassert after handshake
            bus_arvalid_i <= 1'b0;

            // Wait for response, then sample
            while (!bus_rvalid_o)
                @(posedge clk_i);
            data = bus_rdata_o;

            // Accept response
            bus_rready_i <= 1'b1;
            @(posedge clk_i);
            bus_rready_i <= 1'b0;
        end
    endtask

    // Expected 2-FF synchronized input model
    reg [31:0] exp_input_ms;
    reg [31:0] exp_input_q;

    // Track expected synchronizer state in lockstep with DUT
    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            exp_input_ms <= 32'b0;
            exp_input_q  <= 32'b0;
        end else begin
            exp_input_q  <= exp_input_ms;
            exp_input_ms <= gpio_input_i;
        end
    end

    // Test sequence
    integer i;
    reg [31:0] rdata;
    reg [31:0] exp_snap;

    initial begin
        // Defaults
        rst_i         = 1'b1;
        bus_awvalid_i = 1'b0;
        bus_awaddr_i  = 32'b0;
        bus_wvalid_i  = 1'b0;
        bus_wdata_i   = 32'b0;
        bus_wstrb_i   = 4'hF;
        bus_bready_i  = 1'b0;
        bus_arvalid_i = 1'b0;
        bus_araddr_i  = 32'b0;
        bus_rready_i  = 1'b0;
        gpio_input_i  = 32'b0;

        // Reset
        repeat (5) @(posedge clk_i);
        rst_i = 1'b0;
        repeat (2) @(posedge clk_i);

        // Check reset defaults
        if (gpio_output_enable_o !== 32'h0000_0000) begin
            fail("gpio_output_enable_o reset mismatch");
        end
        if (gpio_output_o !== 32'h0000_0000) begin
            fail("gpio_output_o reset mismatch");
        end

        // Write direction and check enable mirrors it
        write_reg(GPIO_DIRECTION, 32'hFFFF_FFFF);
        @(posedge clk_i);
        if (gpio_output_enable_o !== 32'hFFFF_FFFF) begin
            fail("gpio_output_enable_o mismatch after dir write");
        end

        // Write output and check it updates
        write_reg(GPIO_OUTPUT, 32'hA5A5_5A5A);
        @(posedge clk_i);
        if (gpio_output_o !== 32'hA5A5_5A5A) begin
            fail("gpio_output_o mismatch after output write");
        end

        // Read back direction/output
        read_reg(GPIO_DIRECTION, rdata);
        if (rdata !== 32'hFFFF_FFFF) begin
            fail("readback direction mismatch");
        end

        read_reg(GPIO_OUTPUT, rdata);
        if (rdata !== 32'hA5A5_5A5A) begin
            fail("readback output mismatch");
        end

        // Exercise input synchronizer and readback
        for (i = 0; i < 20; i = i + 1) begin
            @(posedge clk_i);
            gpio_input_i <= (32'h1 << (i % 32)) ^ (i[0] ? 32'hDEAD_BEEF : 32'h1234_5678);

            // Occasionally read input and compare to expected 2-FF output
            if ((i % 4) == 3) begin
                // Snapshot after posedge NBAs settle, then issue read before next posedge
                @(negedge clk_i);
                exp_snap = exp_input_q;
                read_reg(GPIO_INPUT, rdata);
                if (rdata !== exp_snap) begin
                    $display("ERROR: input readback mismatch at i=%0d: got=%h exp=%h", i, rdata, exp_snap);
                    fail("input readback mismatch");
                end
            end
        end

        $display("PASS: gpio core TB completed successfully.");
        $finish;
    end

endmodule

