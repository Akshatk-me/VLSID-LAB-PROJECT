module uart_rx #(
    parameter CLK_FREQ = 100_000_000
)(
    input  wire        clk,
    input  wire        rst,

    input  wire        rx,            // async input
    input  wire [31:0] baud_div,      // cycles per bit = (clock / baud rate)
    input wire clear_irq,

    output reg  [7:0]  data_out,
    output reg         valid,         // 1-cycle pulse
    output reg         irq            // interrupt (latched)
);

    //----------------------------------------
    // 1. CDC Synchronizer
    //----------------------------------------
    reg rx_sync1, rx_sync2;

    always @(posedge clk) begin
        rx_sync1 <= rx;
        rx_sync2 <= rx_sync1;
    end

    wire rx_s = rx_sync2; // rx_s is the safe version of rx inside my clock domain

    //----------------------------------------
    // 2. State machine
    //----------------------------------------
    localparam IDLE  = 0;
    localparam START = 1;
    localparam DATA  = 2;
    localparam STOP  = 3;

    reg [1:0] state;
    reg [31:0] counter;
    reg [2:0] bit_index;
    reg [7:0] shift_reg;

    //----------------------------------------
    // 3. Main logic
    //----------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state     <= IDLE;
            counter   <= 0;
            bit_index <= 0;
            shift_reg <= 0;
            data_out  <= 0;
            valid     <= 0;
            irq       <= 0;
        end else begin
            valid <= 0; // pulse

	    if (clear_irq)
		    irq <= 0;
	    
            case (state)

            //----------------------------------
            // IDLE: wait for start bit
            //----------------------------------
            IDLE: begin
                counter <= 0;
                if (rx_s == 0) begin  // start bit detected
                    state   <= START;
                    counter <= baud_div >> 1; // half bit delay (i.e. sample at middle of start bit)
                end
            end

            //----------------------------------
            // START: align to middle of bit
            //----------------------------------
            START: begin
                if (counter == 0) begin
                    if (rx_s == 0) begin
                        state     <= DATA;
                        counter   <= baud_div - 1;
                        bit_index <= 0;
                    end else begin
                        state <= IDLE; // false start
                    end
                end else begin
                    counter <= counter - 1;
                end
            end

            //----------------------------------
            // DATA: receive 8 bits
            //----------------------------------
            DATA: begin
                if (counter == 0) begin
                    shift_reg <= {rx_s, shift_reg[7:1]};
                    counter   <= baud_div - 1;

                    if (bit_index == 7) begin
                        state <= STOP;
			counter <= baud_div - 1;
                    end else begin
                        bit_index <= bit_index + 1;
                    end
                end else begin
                    counter <= counter - 1;
                end
            end

            //----------------------------------
            // STOP bit
            //----------------------------------
            STOP: begin
                if (counter == 0) begin
		    if (rx_s == 1) begin
			    data_out <= shift_reg;
			    valid    <= 1;
			    irq      <= 1;  // latch interrupt
		    end
		    state    <= IDLE;
                end else begin
                    counter <= counter - 1;
                end
            end

            endcase
        end
    end

endmodule


module uart_tx (
    input  wire        clk,
    input  wire        rst,

    input  wire        start,
    input  wire [7:0]  data_in,
    input  wire [31:0] baud_div,

    output reg         tx,
    output reg         busy
);

    reg [31:0] counter;
    reg [3:0]  bit_index;
    reg [9:0]  shift_reg; // start + data + stop

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx        <= 1;
            busy      <= 0;
            counter   <= 0;
            bit_index <= 0;
        end else begin

            if (start && !busy) begin
                shift_reg <= {1'b1, data_in, 1'b0}; // stop, data, start
                busy      <= 1;
                counter   <= baud_div - 1;
                bit_index <= 0;
            end

            else if (busy) begin
                if (counter == 0) begin
                    tx <= shift_reg[0];
                    shift_reg <= shift_reg >> 1;
                    counter <= baud_div - 1;

                    if (bit_index == 9) begin
                        busy <= 0;
                        tx   <= 1;
                    end else begin
                        bit_index <= bit_index + 1;
                    end
                end else begin
                    counter <= counter - 1;
                end
            end
        end
    end

endmodule
