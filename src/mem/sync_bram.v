module sync_bram (
    input  wire        clk,
    input  wire        we,
    input  wire        re,
    input  wire [31:0] addr,
    input  wire [31:0] wdata,
    output reg  [31:0] rdata
);
    // 1024 x 32-bit memory (4KB)
    reg [31:0] ram [0:1023];

    // Initialize memory with a hex file for simulation
    initial begin
        $readmemh("program.hex", ram);
    end

    always @(posedge clk) begin
        if (we) begin
            // Divide addr by 4 because PC is byte-addressable, but RAM array is word-addressable
            ram[addr >> 2] <= wdata; 
        end
        if (re) begin
            rdata <= ram[addr >> 2];
        end
    end
endmodule
