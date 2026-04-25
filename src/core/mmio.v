module mmio_bus (
    input  wire        clk,
    input  wire        rst,

    // CPU side
    input  wire [31:0] addr,
    input  wire [31:0] wdata,
    input  wire        we,
    input  wire        re,
    output reg  [31:0] rdata,
    output wire        cpu_irq,    // NEW: Single interrupt line to the CPU

    // SHA
    output wire        sha_we,
    output wire        sha_re,
    input  wire [31:0] sha_rdata,
    input  wire        sha_irq,    // NEW: IRQ from SHA wrapper

    // UART
    output wire        uart_we,
    output wire        uart_re,
    input  wire [31:0] uart_rdata,
    input  wire        uart_irq,   // NEW: IRQ from UART RX

    // GPIO
    output wire        gpio_we,
    output wire        gpio_re,
    input  wire [31:0] gpio_rdata,
    input  wire        gpio_irq    // NEW: IRQ from GPIO
);

    // --------------------------------------------------------
    // Address decoding
    // --------------------------------------------------------
    wire sha_sel  = (addr[31:12] == 20'h80000); // 0x8000_0000
    wire uart_sel = (addr[31:12] == 20'h80001); // 0x8000_1000
    wire gpio_sel = (addr[31:12] == 20'h80002); // 0x8000_2000

    // --------------------------------------------------------
    // Generate control signals
    // --------------------------------------------------------
    assign sha_we  = we && sha_sel;
    assign sha_re  = re && sha_sel;

    assign uart_we = we && uart_sel;
    assign uart_re = re && uart_sel;

    assign gpio_we = we && gpio_sel;
    assign gpio_re = re && gpio_sel;

    // --------------------------------------------------------
    // Read mux
    // --------------------------------------------------------
    always @(*) begin
        case (1'b1)
            sha_sel:  rdata = sha_rdata;
            uart_sel: rdata = uart_rdata;
            gpio_sel: rdata = gpio_rdata;
            default:  rdata = 32'b0;
        endcase
    end

    assign cpu_irq = sha_irq | uart_irq | gpio_irq;

endmodule
