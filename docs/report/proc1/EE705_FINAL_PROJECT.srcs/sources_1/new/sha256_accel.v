// =============================================================================
// sha256_accel.v
// Functional SHA-256 accelerator stub.
// Combinational placeholder hash + manual ACCEL_CYCLE_DELAY for compute time.
//
// Simple semantics: once started, runs to completion uninterrupted.
// No pause/resume. Main pipeline is expected to stall (via accel_busy) for
// the entire duration.
//
// Memory-mapped registers (config interface):
//   cfg_addr 0x0 : control  (bit 0 = start; auto-clears on READ transition)
//   cfg_addr 0x4 : address  (base address of source data in BRAM)
//   cfg_addr 0x8 : length   (number of bytes; max 64)
// =============================================================================

module sha256_accel #(
    parameter ACCEL_CYCLE_DELAY = 16
) (
    input  wire         clk,
    input  wire         rst,

    // Config write port (from MMIO bridge)
    input  wire         cfg_wen,
    input  wire [3:0]   cfg_addr,
    input  wire [31:0]  cfg_wdata,

    // Memory request port
    output wire [31:0]  accel_mem_addr,
    input  wire [31:0]  accel_mem_data,

    // Hazard interface
    output wire         accel_busy,

    // Digest output
    output wire [255:0] digest_out
);

    // -------------------------------------------------------------------------
    // Config registers
    // -------------------------------------------------------------------------
    reg [31:0] ctrl_reg;
    reg [31:0] addr_reg;
    reg [31:0] length_reg;

    wire start = ctrl_reg[0];

    // -------------------------------------------------------------------------
    // Storage
    // -------------------------------------------------------------------------
    reg [511:0] input_buf;
    reg [255:0] digest_reg;

    assign digest_out = digest_reg;

    // -------------------------------------------------------------------------
    // FSM
    // -------------------------------------------------------------------------
    localparam [1:0] S_IDLE    = 2'b00;
    localparam [1:0] S_READ    = 2'b01;
    localparam [1:0] S_COMPUTE = 2'b10;
    localparam [1:0] S_DONE    = 2'b11;

    reg [1:0]  state;
    reg [3:0]  word_idx;
    reg [3:0]  wb_idx;
    reg [3:0]  reads_issued;
    reg [3:0]  reads_total;
    reg [7:0]  compute_count;

    // Memory request address: base + (word_idx * 4)
    assign accel_mem_addr = addr_reg + {26'b0, word_idx, 2'b00};

    // Busy in READ, COMPUTE, DONE
    assign accel_busy = (state != S_IDLE);

    // -------------------------------------------------------------------------
    // Combinational placeholder hash: XOR-fold
    // -------------------------------------------------------------------------
    wire [255:0] hash_combinational = input_buf[511:256] ^ input_buf[255:0];

    // -------------------------------------------------------------------------
    // Read pipe valid shift register
    // -------------------------------------------------------------------------
    reg [1:0] read_pipe_valid;

    // -------------------------------------------------------------------------
    // Main FSM
    // -------------------------------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            state           <= S_IDLE;
            ctrl_reg        <= 32'b0;
            addr_reg        <= 32'b0;
            length_reg      <= 32'b0;
            input_buf       <= 512'b0;
            digest_reg      <= 256'b0;
            word_idx        <= 4'b0;
            wb_idx          <= 4'b0;
            reads_issued    <= 4'b0;
            reads_total     <= 4'b0;
            compute_count   <= 8'b0;
            read_pipe_valid <= 2'b0;
        end else begin
            // Config writes always allowed
            if (cfg_wen) begin
                case (cfg_addr)
                    4'h0: ctrl_reg   <= cfg_wdata;
                    4'h4: addr_reg   <= cfg_wdata;
                    4'h8: length_reg <= cfg_wdata;
                    default: ;
                endcase
            end

            case (state)
                // -----------------------------------------------------
                S_IDLE: begin
                    if (start) begin
                        reads_total     <= length_reg[5:2] + (|length_reg[1:0] ? 4'd1 : 4'd0);
                        word_idx        <= 4'b0;
                        wb_idx          <= 4'b0;
                        reads_issued    <= 4'b0;
                        input_buf       <= 512'b0;
                        read_pipe_valid <= 2'b0;
                        ctrl_reg[0]     <= 1'b0;  // auto-clear start
                        state           <= S_READ;
                    end
                end

                // -----------------------------------------------------
                S_READ: begin
                    if (reads_issued < reads_total) begin
                        word_idx        <= word_idx + 4'd1;
                        reads_issued    <= reads_issued + 4'd1;
                        read_pipe_valid <= {read_pipe_valid[0], 1'b1};
                    end else begin
                        read_pipe_valid <= {read_pipe_valid[0], 1'b0};
                    end

                    if (read_pipe_valid[1]) begin
                        case (wb_idx)
                            4'd0:  input_buf[ 31:  0] <= accel_mem_data;
                            4'd1:  input_buf[ 63: 32] <= accel_mem_data;
                            4'd2:  input_buf[ 95: 64] <= accel_mem_data;
                            4'd3:  input_buf[127: 96] <= accel_mem_data;
                            4'd4:  input_buf[159:128] <= accel_mem_data;
                            4'd5:  input_buf[191:160] <= accel_mem_data;
                            4'd6:  input_buf[223:192] <= accel_mem_data;
                            4'd7:  input_buf[255:224] <= accel_mem_data;
                            4'd8:  input_buf[287:256] <= accel_mem_data;
                            4'd9:  input_buf[319:288] <= accel_mem_data;
                            4'd10: input_buf[351:320] <= accel_mem_data;
                            4'd11: input_buf[383:352] <= accel_mem_data;
                            4'd12: input_buf[415:384] <= accel_mem_data;
                            4'd13: input_buf[447:416] <= accel_mem_data;
                            4'd14: input_buf[479:448] <= accel_mem_data;
                            4'd15: input_buf[511:480] <= accel_mem_data;
                        endcase
                        wb_idx <= wb_idx + 4'd1;

                        if (wb_idx + 4'd1 == reads_total) begin
                            compute_count <= ACCEL_CYCLE_DELAY[7:0];
                            state         <= S_COMPUTE;
                        end
                    end
                end

                // -----------------------------------------------------
                S_COMPUTE: begin
                    if (compute_count == 8'd0) begin
                        digest_reg <= hash_combinational;
                        state      <= S_DONE;
                    end else begin
                        compute_count <= compute_count - 8'd1;
                    end
                end

                // -----------------------------------------------------
                S_DONE: begin
                    state <= S_IDLE;
                end

                default: state <= S_IDLE;
            endcase
        end
    end

endmodule