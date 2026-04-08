`timescale 1ns/1ps

module tb_multicycle_mul;

    reg clk;
    reg rst;
    reg start;
    reg [31:0] A, B;

    wire [63:0] result;
    wire done;
    wire busy;

    //----------------------------------------
    // DUT
    //----------------------------------------
    multicycle_mul uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .A(A),
        .B(B),
        .result(result),
        .done(done),
        .busy(busy)
    );

    //----------------------------------------
    // Clock generation (100 MHz)
    //----------------------------------------
    always #5 clk = ~clk;

    //----------------------------------------
    // Task to run one multiplication
    //----------------------------------------
    task run_mul;
        input [31:0] a_in;
        input [31:0] b_in;

        reg [63:0] expected;
        integer cycle_count;

        begin
            @(posedge clk);
            A <= a_in;
            B <= b_in;
            start <= 1;

            @(posedge clk);
            start <= 0;

            expected = a_in * b_in;

            cycle_count = 0;

            // Wait for done
            while (!done) begin
                @(posedge clk);
                cycle_count = cycle_count + 1;

                // Safety timeout
                if (cycle_count > 40) begin
                    $display("ERROR: Timeout for A=%d B=%d", a_in, b_in);
                    $finish;
                end
            end

            // Check result
            if (result !== expected) begin
                $display("FAIL: A=%d B=%d | Got=%d Expected=%d",
                         a_in, b_in, result, expected);
                $finish;
            end else begin
                $display("PASS: A=%d B=%d | Result=%d | Cycles=%0d",
                         a_in, b_in, result, cycle_count);
            end

            // Wait one cycle before next op
            @(posedge clk);
        end
    endtask

    //----------------------------------------
    // Test sequence
    //----------------------------------------
    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        A = 0;
        B = 0;

        // Reset
        repeat (5) @(posedge clk);
        rst = 0;

        //------------------------------------
        // Basic tests
        //------------------------------------
        run_mul(0, 0);
        run_mul(0, 12345);
        run_mul(1, 1);
        run_mul(3, 5);
        run_mul(7, 9);

        //------------------------------------
        // Edge cases
        //------------------------------------
        run_mul(32'hFFFFFFFF, 1);
        run_mul(32'hFFFFFFFF, 2);
        run_mul(32'h80000000, 2);
        run_mul(32'h7FFFFFFF, 2);

        //------------------------------------
        // Powers of 2
        //------------------------------------
        run_mul(1 << 10, 1 << 5);
        run_mul(1 << 20, 3);

        //------------------------------------
        // Random tests
        //------------------------------------
        repeat (10) begin
            run_mul($random, $random);
        end

        $display("ALL TESTS PASSED");
        $finish;
    end

endmodule
