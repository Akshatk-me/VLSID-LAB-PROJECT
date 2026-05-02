module bram_wrapper #(
    parameter int    DEPTH     = 1024,          // 1024 words = 4KB of memory
    parameter string INIT_FILE = "program.hex"  // Used to load your Assembly code
) (
    input logic              clk,
    input logic              rst,
          cpu_bus_intf.slave bus
);

    // The actual memory array
    logic [31:0] mem[0:DEPTH-1];

    // Load initial program into memory if a file is provided
    initial begin
        if (INIT_FILE != "") begin
            $readmemh(INIT_FILE, mem);
        end
    end

    // --- State Machine ---
    typedef enum logic [1:0] {
        IDLE,
        RESPOND
    } state_t;
    state_t                     state;

    logic   [             31:0] saved_rdata;

    // RISC-V uses Byte Addressing (0, 4, 8...), but our array is Word Addressed (0, 1, 2...)
    // So we divide the address by 4 by slicing off the bottom 2 bits.
    wire    [$clog2(DEPTH)-1:0] word_addr = bus.addr[$clog2(DEPTH)+1 : 2];

    // Grant logic: strict 1-cycle combinational pulse
    assign bus.grant = (state == IDLE) && bus.req_valid;

    always_ff @(posedge clk) begin
        if (rst) begin
            state       <= IDLE;
            saved_rdata <= 32'd0;
        end else begin
            case (state)
                IDLE: begin
                    if (bus.grant) begin
                        if (bus.we) begin
                            // WRITE OPERATION
                            // (Note: Skipping byte-enables 'bus.be' logic for this simple dummy wrapper)
                            mem[word_addr] <= bus.wdata;
                            saved_rdata    <= 32'd0; // Dummy ACK data
                        end else begin
                            // READ OPERATION
                            saved_rdata <= mem[word_addr];
                        end
                        state <= RESPOND;
                    end
                end

                RESPOND: begin
                    // Hold here until the CPU/Interconnect is actually ready to consume
                    if (bus.ready) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    // Output routing
    assign bus.rdata       = saved_rdata;
    assign bus.rdata_valid = (state == RESPOND);

endmodule
