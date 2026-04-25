`timescale 1ns/1ps

module mem_test1_tb;

    // ---------------------------------------------------------
    // 1. Signal Declarations & Zero-X Initialization
    // ---------------------------------------------------------
    reg clk_0   = 0;
    reg rst_0   = 1;
    reg stall_0 = 0;
    reg flush_0 = 0;

    reg [31:0] ex_pc_in_0         = 0;
    reg [31:0] ex_result_in_0     = 0;
    reg [31:0] ex_store_data_in_0 = 0;
    reg [4:0]  ex_rd_addr_in_0    = 0;
    reg        ex_mem_read_in_0   = 0;
    reg        ex_mem_write_in_0  = 0;
    reg [3:0]  ex_wen_in_0        = 0;
    reg        ex_is_branch_in_0  = 0;
    reg        ex_is_jump_in_0    = 0;
    reg [2:0]  ex_ld_select_in_0  = 0;
    reg        ex_reg_write_in_0  = 0;

    wire [31:0] wb_pc_0, wb_write_data_0;
    wire [4:0]  wb_rd_addr_0;
    wire        wb_reg_write_0, wb_valid_0;

    // Counters for Summary
    integer passed = 0;
    integer failed = 0;

    // ---------------------------------------------------------
    // 2. DUT Instance
    // ---------------------------------------------------------
    mem_test1 dut (
        .clk_0(clk_0), .rst_0(rst_0), .stall_0(stall_0), .flush_0(flush_0),
        .ex_pc_in_0(ex_pc_in_0), .ex_result_in_0(ex_result_in_0),
        .ex_store_data_in_0(ex_store_data_in_0), .ex_rd_addr_in_0(ex_rd_addr_in_0),
        .ex_mem_read_in_0(ex_mem_read_in_0), .ex_mem_write_in_0(ex_mem_write_in_0),
        .ex_wen_in_0(ex_wen_in_0), .ex_is_branch_in_0(ex_is_branch_in_0),
        .ex_is_jump_in_0(ex_is_jump_in_0), .ex_ld_select_in_0(ex_ld_select_in_0),
        .ex_reg_write_in_0(ex_reg_write_in_0),
        .wb_pc_0(wb_pc_0), .wb_rd_addr_0(wb_rd_addr_0), .wb_reg_write_0(wb_reg_write_0),
        .wb_valid_0(wb_valid_0), .wb_write_data_0(wb_write_data_0)
    );

    // 10ns Clock
    always #5 clk_0 = ~clk_0;

    // ---------------------------------------------------------
    // 3. TASK DEFINITIONS (Must be inside the module)
    // ---------------------------------------------------------
    task drive_idle;
        begin
            ex_mem_read_in_0  = 0; ex_mem_write_in_0 = 0;
            ex_reg_write_in_0 = 0; ex_wen_in_0 = 0;
            ex_result_in_0    = 0; ex_rd_addr_in_0 = 0;
        end
    endtask

    task drive_load;
        input [31:0] addr;
        input [4:0]  rd;
        begin
            ex_mem_read_in_0  = 1;
            ex_mem_write_in_0 = 0;
            ex_result_in_0    = addr;
            ex_rd_addr_in_0   = rd;
            ex_reg_write_in_0 = 1;
            ex_ld_select_in_0 = 3'b010; // LW
        end
    endtask

    task check;
        input [255:0] name;
        input [31:0]  expected;
        begin
            // Wait for non-blocking assignment update
            if (wb_write_data_0 === expected && wb_valid_0 === 1'b1) begin
                $display("[PASS] %0s | WB_DATA: %h", name, wb_write_data_0);
                passed = passed + 1;
            end else begin
                $display("[FAIL] %0s | GOT: %h (Valid:%b) | EXP: %h", 
                         name, wb_write_data_0, wb_valid_0, expected);
                failed = failed + 1;
            end
        end
    endtask

    // ---------------------------------------------------------
    // 4. Test Sequence (The Logic)
    // ---------------------------------------------------------
    initial begin
        $display("=== Starting Cycle-Exact Pipeline Test ===");
        
        // Reset Phase
        drive_idle();
        rst_0 = 1;
        repeat(10) @(posedge clk_0);
        @(negedge clk_0);
        rst_0 = 0;
        repeat(5) @(posedge clk_0);

        // --- Back-to-Back Pipelined Test ---
        // Latency: 4 Cycles (EX -> MEM1 -> BRAM_S1 -> BRAM_S2 -> WB)
        
        @(negedge clk_0);
        drive_load(32'd1, 5'd10); // T0: Issue Addr 1 (12345678)
        @(negedge clk_0);
        drive_load(32'd2, 5'd11); // T1: Issue Addr 2 (cafebabe)
        @(negedge clk_0);
        drive_load(32'd3, 5'd12); // T2: Issue Addr 3 (0badf00d)
        @(negedge clk_0);
        drive_idle();             // T3: Pipeline begins flushing

        // Cycle T4: Addr 1 reaches Writeback
        @(posedge clk_0); #1; 
        check("T4: Load Addr 1", 32'h12345678);

        // Cycle T5: Addr 2 reaches Writeback
        @(posedge clk_0); #1;
        check("T5: Load Addr 2", 32'hcafebabe);

        // Cycle T6: Addr 3 reaches Writeback
        @(posedge clk_0); #1;
        check("T6: Load Addr 3", 32'h0badf00d);

        $display("\n=== Summary: %0d Passed, %0d Failed ===", passed, failed);
        $finish;
    end

endmodule