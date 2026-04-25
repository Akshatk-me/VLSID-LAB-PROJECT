`timescale 1ns / 1ps

module bram_observe_tb;

    // -------------------------------------------------------------------------
    // Signals
    // -------------------------------------------------------------------------
    reg [12:0] BRAM_PORTA_0_addr;
    reg        BRAM_PORTA_0_clk;
    reg [31:0] BRAM_PORTA_0_din;
    reg        BRAM_PORTA_0_en;
    reg [3:0]  BRAM_PORTA_0_we;
    
    wire [31:0] BRAM_PORTA_0_dout;

    // -------------------------------------------------------------------------
    // Instantiate your inferred BRAM
    // -------------------------------------------------------------------------
    // Ensure the module name matches your Verilog file
    bram dut (
        .clk   (BRAM_PORTA_0_clk),
        .en    (BRAM_PORTA_0_en),
        .wea   (BRAM_PORTA_0_we),
        .addra ({19'b0, BRAM_PORTA_0_addr}), // Padding to 32-bit as per your req
        .dina  (BRAM_PORTA_0_din),
        .douta (BRAM_PORTA_0_dout)
    );

    // -------------------------------------------------------------------------
    // 10ns Clock (100MHz)
    // -------------------------------------------------------------------------
    initial BRAM_PORTA_0_clk = 0;
    always #5 BRAM_PORTA_0_clk = ~BRAM_PORTA_0_clk;

    // -------------------------------------------------------------------------
    // Stimulus
    // -------------------------------------------------------------------------
    initial begin
        $display("=== BRAM 2-Cycle Latency & Byte-Write Test Started ===");
        
        // Initialize signals
        BRAM_PORTA_0_addr = 13'd0;
        BRAM_PORTA_0_din  = 32'd0;
        BRAM_PORTA_0_en   = 1'b0;
        BRAM_PORTA_0_we   = 4'b0000;

        #100;
        @(posedge BRAM_PORTA_0_clk);
        #1; // Non-blocking alignment

        // =====================================================================
        // TEST 1: READ LATENCY VERIFICATION (Expected 2 Cycles)
        // =====================================================================
        $display("[%0t ns] --- Starting Read Latency Test ---", $time);
        BRAM_PORTA_0_en = 1'b1;
        
        // Cycle 0: Request Addr 0
        BRAM_PORTA_0_addr = 13'h0000; 
        $display("[%0t ns] T0: Requested Addr 0", $time);
        @(posedge BRAM_PORTA_0_clk); #1; 
        
        // Cycle 1: Request Addr 1
        BRAM_PORTA_0_addr = 13'h0001;
        $display("[%0t ns] T1: Requested Addr 1 (Data from Addr 0 should NOT be here yet)", $time);
        @(posedge BRAM_PORTA_0_clk); #1; 
        
        // Cycle 2: Request Addr 2
        BRAM_PORTA_0_addr = 13'h0002;
        $display("[%0t ns] T2: Requested Addr 2 (Data from Addr 0 should appear NOW)", $time);
        @(posedge BRAM_PORTA_0_clk); #1; 

        // Let pipeline finish
        repeat(2) @(posedge BRAM_PORTA_0_clk);
        BRAM_PORTA_0_en = 1'b0;
        #20;

        // =====================================================================
        // TEST 2: BYTE-WRITE ENABLE (wea[3:0])
        // =====================================================================
        $display("[%0t ns] --- Starting Byte-Write Test ---", $time);
        BRAM_PORTA_0_en = 1'b1;

        // 1. Write full 32-bit word to Addr 10
        BRAM_PORTA_0_we   = 4'b1111;
        BRAM_PORTA_0_addr = 13'd10;
        BRAM_PORTA_0_din  = 32'hAABBCCDD;
        @(posedge BRAM_PORTA_0_clk); #1;

        // 2. Modify ONLY the top byte (MSB) at Addr 10
        BRAM_PORTA_0_we   = 4'b1000; // Only wea[3]
        BRAM_PORTA_0_din  = 32'hFF000000; // Attempt to change AA to FF
        @(posedge BRAM_PORTA_0_clk); #1;

        // 3. Read back Addr 10
        BRAM_PORTA_0_we   = 4'b0000;
        BRAM_PORTA_0_addr = 13'd10;
        // Wait 2 cycles for data to exit the pipeline
        repeat(2) @(posedge BRAM_PORTA_0_clk); #1;
        
        if (BRAM_PORTA_0_dout == 32'hFFBBCCDD)
            $display("[%0t ns] SUCCESS: Byte-write confirmed FFBBCCDD", $time);
        else
            $display("[%0t ns] ERROR: Byte-write failed. Got: %h", $time, BRAM_PORTA_0_dout);

        // =====================================================================
        // TEST 3: COMMON ENABLE BLOCKAGE
        // =====================================================================
        // If EN drops, the data should stop moving through the pipeline
        $display("[%0t ns] --- Testing Pipeline Freeze (Common EN) ---", $time);
        BRAM_PORTA_0_en   = 1'b1;
        BRAM_PORTA_0_addr = 13'd5; // Request Addr 5
        @(posedge BRAM_PORTA_0_clk); #1;
        BRAM_PORTA_0_en   = 1'b0; // Drop EN immediately
        $display("[%0t ns] EN dropped. Data from Addr 5 should be trapped in Stage 1.", $time);
        
        repeat(3) @(posedge BRAM_PORTA_0_clk);
        
        $display("=== Testbench Finished ===");
        $finish;
    end

    // Monitor for clarity
    always @(posedge BRAM_PORTA_0_clk) begin
        $display("[%0t ns] CLK Edge | Addr: %h | EN: %b | WE: %b | DOUT: %h", 
                 $time, BRAM_PORTA_0_addr, BRAM_PORTA_0_en, BRAM_PORTA_0_we, BRAM_PORTA_0_dout);
    end

endmodule