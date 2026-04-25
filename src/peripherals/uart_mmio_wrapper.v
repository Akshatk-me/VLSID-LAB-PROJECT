module uart_mmio_wrapper (
    input  wire        clk,
    input  wire        rst,

    // MMIO Interface
    input  wire [31:0] addr,
    input  wire [31:0] wdata,
    input  wire        we,
    input  wire        re,
    output reg  [31:0] rdata,
    output wire        irq,

    // Physical Pins
    input  wire        rx,
    output wire        tx
);

    // --------------------------------------------------------
    // Registers & Wires
    // --------------------------------------------------------
    reg  [31:0] baud_div_reg;
    wire [7:0]  rx_data;
    wire        rx_valid;
    wire        tx_busy;
    
    // Address Decoding (Offset from 0x8000_1000)
    wire we_tx_data = we && (addr[11:0] == 12'h000);
    wire we_baud    = we && (addr[11:0] == 12'h008);
    
    // Clear RX IRQ when CPU reads the RX Data register
    wire clear_rx_irq = re && (addr[11:0] == 12'h000);

    // --------------------------------------------------------
    // Write Logic
    // --------------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            baud_div_reg <= 32'd868; // Default to 115200 @ 100MHz
        end else if (we_baud) begin
            baud_div_reg <= wdata;
        end
    end

    // --------------------------------------------------------
    // Read Logic
    // --------------------------------------------------------
    always @(*) begin
        rdata = 32'b0;
        if (re) begin
            case (addr[11:0])
                12'h000: rdata = {24'b0, rx_data};           // Read RX Data
                12'h004: rdata = {30'b0, rx_valid, tx_busy}; // Read Status
                12'h008: rdata = baud_div_reg;               // Read Baud Divisor
                default: rdata = 32'b0;
            endcase
        end
    end

    // --------------------------------------------------------
    // Module Instantiations
    // --------------------------------------------------------
    uart_tx u_tx (
        .clk(clk),
        .rst(rst),
        .start(we_tx_data),
        .data_in(wdata[7:0]),
        .baud_div(baud_div_reg),
        .tx(tx),
        .busy(tx_busy)
    );

    uart_rx u_rx (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .baud_div(baud_div_reg),
        .clear_irq(clear_rx_irq),
        .data_out(rx_data),
        .valid(rx_valid),
        .irq(irq)
    );

endmodule
