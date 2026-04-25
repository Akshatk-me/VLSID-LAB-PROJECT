module mmio_interconnect (
    input logic clk,
    input logic rst,

    // CPU-side ports (two requesters)
    cpu_bus_intf.slave instr_bus,
    cpu_bus_intf.slave data_bus,

    // Peripheral-side ports
    cpu_bus_intf.master bram_bus,
    cpu_bus_intf.master uart_bus,
    cpu_bus_intf.master sha_bus,
    cpu_bus_intf.master gpio_bus
);

    // ============================================================
    // 1. FSM State Definition
    // ============================================================
    typedef enum logic [1:0] {
        IDLE,
        WAIT_PERIPHERAL,
        WAIT_CONSUMER
    } state_t;

    state_t state;

    // ============================================================
    // 2. Target Encoding (latched decode)
    // ============================================================
    typedef enum logic [2:0] {
        TGT_NONE,
        TGT_BRAM,
        TGT_UART,
        TGT_SHA,
        TGT_GPIO,
        TGT_MISS
    } target_t;

    target_t latched_target;

    // ============================================================
    // 3. Decode Function (used ONLY at grant time)
    // ============================================================
    function target_t decode_addr(input logic [31:0] a);
        if (a[31:16] == 16'h0000) return TGT_BRAM;

        if (a[31:28] == 4'h8) begin
            case (a[15:12])
                4'h0: return TGT_UART;
                4'h1: return TGT_SHA;
                4'h2: return TGT_GPIO;
                default: return TGT_MISS;
            endcase
        end

        return TGT_MISS;
    endfunction

    // ============================================================
    // 4. Transaction Tracking
    // ============================================================

    logic        owner;  // 0 = IF, 1 = MEM

    // Latched request (captured at grant)
    logic [31:0] latched_addr;
    logic [31:0] latched_wdata;
    logic        latched_we;
    logic [ 3:0] latched_be;

    // Response holding register
    logic [31:0] saved_rdata;

    // Peripheral response mux outputs
    logic        p_valid;
    logic [31:0] p_data;

    // ============================================================
    // 5. Arbitration (MEM has priority)
    // ============================================================

    logic grant_mem, grant_if;

    assign grant_mem = (state == IDLE) && data_bus.req_valid;
    assign grant_if = (state == IDLE) && !data_bus.req_valid && instr_bus.req_valid;

    assign data_bus.grant = grant_mem;
    assign instr_bus.grant = grant_if;

    // ============================================================
    // 6. FSM + Latching Logic
    // ============================================================

    always_ff @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            owner <= 1'b0;
        end else begin
            case (state)

                // --------------------------------------------
                // IDLE: Accept a new request
                // --------------------------------------------
                IDLE: begin
                    if (grant_mem) begin
                        owner          <= 1'b1;
                        latched_addr   <= data_bus.addr;
                        latched_wdata  <= data_bus.wdata;
                        latched_we     <= data_bus.we;
                        latched_be     <= data_bus.be;
                        latched_target <= decode_addr(data_bus.addr);
                        state          <= WAIT_PERIPHERAL;

                    end else if (grant_if) begin
                        owner          <= 1'b0;
                        latched_addr   <= instr_bus.addr;
                        latched_wdata  <= instr_bus.wdata;
                        latched_we     <= instr_bus.we;
                        latched_be     <= instr_bus.be;
                        latched_target <= decode_addr(instr_bus.addr);
                        state          <= WAIT_PERIPHERAL;
                    end
                end

                // --------------------------------------------
                // WAIT_PERIPHERAL: Wait for device response
                // --------------------------------------------
                WAIT_PERIPHERAL: begin
                    if (p_valid) begin
                        saved_rdata <= p_data;
                        state       <= WAIT_CONSUMER;
                    end
                end

                // --------------------------------------------
                // WAIT_CONSUMER: Hold data until CPU accepts
                // --------------------------------------------
                WAIT_CONSUMER: begin
                    if (owner && data_bus.ready) state <= IDLE;
                    else if (!owner && instr_bus.ready) state <= IDLE;
                end

            endcase
        end
    end

    // ============================================================
    // 7. Peripheral Request Routing (Demux)
    // ============================================================

    logic is_waiting;
    assign is_waiting         = (state == WAIT_PERIPHERAL);

    // Only the selected peripheral sees req_valid = 1
    assign bram_bus.req_valid = is_waiting && (latched_target == TGT_BRAM);
    assign uart_bus.req_valid = is_waiting && (latched_target == TGT_UART);
    assign sha_bus.req_valid  = is_waiting && (latched_target == TGT_SHA);
    assign gpio_bus.req_valid = is_waiting && (latched_target == TGT_GPIO);

    // Broadcast request data (req_valid acts as enable)
    assign bram_bus.addr      = latched_addr;
    assign bram_bus.wdata     = latched_wdata;
    assign bram_bus.we        = latched_we;
    assign bram_bus.be        = latched_be;

    assign uart_bus.addr      = latched_addr;
    assign uart_bus.wdata     = latched_wdata;
    assign uart_bus.we        = latched_we;
    assign uart_bus.be        = latched_be;

    assign sha_bus.addr       = latched_addr;
    assign sha_bus.wdata      = latched_wdata;
    assign sha_bus.we         = latched_we;
    assign sha_bus.be         = latched_be;

    assign gpio_bus.addr      = latched_addr;
    assign gpio_bus.wdata     = latched_wdata;
    assign gpio_bus.we        = latched_we;
    assign gpio_bus.be        = latched_be;

    // ============================================================
    // 8. Peripheral Response Mux (uses latched_target ONLY)
    // ============================================================

    always_comb begin
        p_valid = 1'b0;
        p_data  = 32'd0;

        if (state == WAIT_PERIPHERAL) begin
            case (latched_target)

                TGT_BRAM: begin
                    p_valid = bram_bus.rdata_valid;
                    p_data  = bram_bus.rdata;
                end

                TGT_UART: begin
                    p_valid = uart_bus.rdata_valid;
                    p_data  = uart_bus.rdata;
                end

                TGT_SHA: begin
                    p_valid = sha_bus.rdata_valid;
                    p_data  = sha_bus.rdata;
                end

                TGT_GPIO: begin
                    p_valid = gpio_bus.rdata_valid;
                    p_data  = gpio_bus.rdata;
                end

                // Decode miss → auto-ack
                TGT_MISS: begin
                    p_valid = 1'b1;
                    p_data  = 32'hDEADBEEF;
                end

                default: begin
                    p_valid = 1'b0;
                    p_data  = 32'd0;
                end
            endcase
        end
    end

    // ============================================================
    // 9. Response back to CPU
    // ============================================================

    assign data_bus.rdata_valid = (state == WAIT_CONSUMER) && (owner == 1'b1);
    assign instr_bus.rdata_valid = (state == WAIT_CONSUMER) && (owner == 1'b0);

    assign data_bus.rdata = saved_rdata;
    assign instr_bus.rdata = saved_rdata;

endmodule
