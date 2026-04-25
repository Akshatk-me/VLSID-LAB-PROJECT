// ---------------------------------------------
// GPIO Register Map
// ---------------------------------------------
`define GPIO_DIRECTION  8'h00
`define GPIO_INPUT      8'h04
`define GPIO_OUTPUT     8'h08
`define GPIO_IRQ_STATUS 8'h0C  // NEW: Read to see which pin fired, Write 1 to clear

module gpio
(
    input  wire        clk_i,
    input  wire        rst_i,

    // Custom zero-wait-state MMIO bus
    input  wire [31:0] addr,
    input  wire [31:0] wdata,
    input  wire        we,
    input  wire        re,
    output reg  [31:0] rdata,

    output reg         gpio_irq, // NEW: Interrupt out to MMIO bus

    // GPIO pins
    input  wire [31:0] gpio_input_i,
    output wire [31:0] gpio_output_o,
    output wire [31:0] gpio_output_enable_o
);

// ---------------------------------------------
// Write decoding
// ---------------------------------------------
wire write_dir_w = we && (addr[7:0] == `GPIO_DIRECTION);
wire write_out_w = we && (addr[7:0] == `GPIO_OUTPUT);
wire write_irq_w = we && (addr[7:0] == `GPIO_IRQ_STATUS);

// ---------------------------------------------
// Registers
// ---------------------------------------------
reg [31:0] gpio_direction_q;
reg [31:0] gpio_output_q;
reg [31:0] irq_status_q;

// Direction register (1 = Output, 0 = Input)
always @(posedge clk_i or posedge rst_i) begin
    if (rst_i)
        gpio_direction_q <= 32'b0;
    else if (write_dir_w)
        gpio_direction_q <= wdata;
end

// Output register
always @(posedge clk_i or posedge rst_i) begin
    if (rst_i)
        gpio_output_q <= 32'b0;
    else if (write_out_w)
        gpio_output_q <= wdata;
end

// ---------------------------------------------
// Input synchronizer (CDC SAFE) & Edge Detection
// ---------------------------------------------
reg [31:0] input_ms;
reg [31:0] input_q;
reg [31:0] last_input_q;

always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        input_ms     <= 32'b0;
        input_q      <= 32'b0;
        last_input_q <= 32'b0;
        irq_status_q <= 32'b0;
        gpio_irq     <= 1'b0;
    end else begin
        // 2-stage synchronizer
        input_ms <= gpio_input_i;
        input_q  <= input_ms;
        
        // Delay by one cycle for edge detection
        last_input_q <= input_q;

        // Detect rising edge ONLY on pins configured as inputs
        // (input is 1 now, was 0 last cycle, and direction is 0)
	irq_status_q <= (irq_status_q & ~(write_irq_w ? wdata : 32'b0)) 
                      | (input_q & ~last_input_q & ~gpio_direction_q);
        

        // Assert the main IRQ line if ANY bit in the status register is high
        gpio_irq <= |irq_status_q; 
    end
end

// ---------------------------------------------
// Output mapping
// ---------------------------------------------
assign gpio_output_o        = gpio_output_q;
assign gpio_output_enable_o = gpio_direction_q;

// ---------------------------------------------
// Read mux
// ---------------------------------------------
always @(*) begin
    rdata = 32'b0; // Default to 0
    if (re) begin
        case (addr[7:0])
            `GPIO_DIRECTION:  rdata = gpio_direction_q;
            `GPIO_INPUT:      rdata = input_q;
            `GPIO_OUTPUT:     rdata = gpio_output_q;
            `GPIO_IRQ_STATUS: rdata = irq_status_q;
            default:          rdata = 32'b0;
        endcase
    end
end

endmodule
