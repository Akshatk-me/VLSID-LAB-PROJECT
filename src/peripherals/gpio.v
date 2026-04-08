// ---------------------------------------------
// GPIO Register Map
// ---------------------------------------------
`define GPIO_DIRECTION  8'h00
`define GPIO_INPUT      8'h04
`define GPIO_OUTPUT     8'h08

module gpio
(
    input          clk_i,
    input          rst_i,

    // Simplified AXI-lite style bus
    input          bus_awvalid_i,
    input  [31:0]  bus_awaddr_i,
    input          bus_wvalid_i,
    input  [31:0]  bus_wdata_i,
    input  [3:0]   bus_wstrb_i,
    input          bus_bready_i,

    input          bus_arvalid_i,
    input  [31:0]  bus_araddr_i,
    input          bus_rready_i,

    // GPIO pins
    input  [31:0]  gpio_input_i,

    // Bus outputs
    output         bus_awready_o,
    output         bus_wready_o,
    output         bus_bvalid_o,
    output [1:0]   bus_bresp_o,

    output         bus_arready_o,
    output         bus_rvalid_o,
    output [31:0]  bus_rdata_o,
    output [1:0]   bus_rresp_o,

    // GPIO outputs
    output [31:0]  gpio_output_o,
    output [31:0]  gpio_output_enable_o
);

// ---------------------------------------------
// Write handshake (FIXED)
// ---------------------------------------------
wire write_en_w = bus_awvalid_i & bus_wvalid_i & bus_awready_o;
assign bus_awready_o = ~bus_bvalid_o;
assign bus_wready_o  = bus_awready_o;

// ---------------------------------------------
// Read handshake
// ---------------------------------------------
wire read_en_w = bus_arvalid_i & bus_arready_o;
assign bus_arready_o = ~bus_rvalid_o;

// ---------------------------------------------
// Registers
// ---------------------------------------------
reg [31:0] gpio_direction_q;
reg [31:0] gpio_output_q;

// Write decoding
wire write_dir_w = write_en_w && (bus_awaddr_i[7:0] == `GPIO_DIRECTION);
wire write_out_w = write_en_w && (bus_awaddr_i[7:0] == `GPIO_OUTPUT);

// ---------------------------------------------
// Direction register
// ---------------------------------------------
always @(posedge clk_i or posedge rst_i)
if (rst_i)
    gpio_direction_q <= 32'b0;
else if (write_dir_w) begin
    if (bus_wstrb_i[0]) gpio_direction_q[7:0]   <= bus_wdata_i[7:0];
    if (bus_wstrb_i[1]) gpio_direction_q[15:8]  <= bus_wdata_i[15:8];
    if (bus_wstrb_i[2]) gpio_direction_q[23:16] <= bus_wdata_i[23:16];
    if (bus_wstrb_i[3]) gpio_direction_q[31:24] <= bus_wdata_i[31:24];
end

// ---------------------------------------------
// Output register
// ---------------------------------------------
always @(posedge clk_i or posedge rst_i)
if (rst_i)
    gpio_output_q <= 32'b0;
else if (write_out_w) begin
    if (bus_wstrb_i[0]) gpio_output_q[7:0]   <= bus_wdata_i[7:0];
    if (bus_wstrb_i[1]) gpio_output_q[15:8]  <= bus_wdata_i[15:8];
    if (bus_wstrb_i[2]) gpio_output_q[23:16] <= bus_wdata_i[23:16];
    if (bus_wstrb_i[3]) gpio_output_q[31:24] <= bus_wdata_i[31:24];
end

// ---------------------------------------------
// Input synchronizer (CDC SAFE)
// ---------------------------------------------
reg [31:0] input_ms;
reg [31:0] input_q;

always @(posedge clk_i or posedge rst_i)
if (rst_i) begin
    input_ms <= 32'b0;
    input_q  <= 32'b0;
end else begin
    input_ms <= gpio_input_i;
    input_q  <= input_ms;
end

// ---------------------------------------------
// Output mapping
// ---------------------------------------------
assign gpio_output_o        = gpio_output_q;
assign gpio_output_enable_o = gpio_direction_q;

// ---------------------------------------------
// Read mux
// ---------------------------------------------
reg [31:0] data_r;

always @(*) begin
    case (bus_araddr_i[7:0])
        `GPIO_DIRECTION: data_r = gpio_direction_q;
        `GPIO_INPUT:     data_r = input_q;
        `GPIO_OUTPUT:    data_r = gpio_output_q;
        default:         data_r = 32'b0;
    endcase
end

// ---------------------------------------------
// Read response
// ---------------------------------------------
reg rvalid_q;

always @(posedge clk_i or posedge rst_i)
if (rst_i)
    rvalid_q <= 1'b0;
else if (read_en_w)
    rvalid_q <= 1'b1;
else if (bus_rready_i)
    rvalid_q <= 1'b0;

assign bus_rvalid_o = rvalid_q;

reg [31:0] rd_data_q;

always @(posedge clk_i or posedge rst_i)
if (rst_i)
    rd_data_q <= 32'b0;
else if (!bus_rvalid_o || bus_rready_i)
    rd_data_q <= data_r;

assign bus_rdata_o = rd_data_q;
assign bus_rresp_o = 2'b00;

// ---------------------------------------------
// Write response
// ---------------------------------------------
reg bvalid_q;

always @(posedge clk_i or posedge rst_i)
if (rst_i)
    bvalid_q <= 1'b0;
else if (write_en_w)
    bvalid_q <= 1'b1;
else if (bus_bready_i)
    bvalid_q <= 1'b0;

assign bus_bvalid_o = bvalid_q;
assign bus_bresp_o  = 2'b00;

endmodule
