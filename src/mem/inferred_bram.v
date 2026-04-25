module inferred_bram #(
    // You can override this parameter from the top module if you want!
    parameter MEM_FILE = "program.hex" 
)(
    input  wire        clk,
    input  wire        we,
    input  wire        re,
    input  wire [31:0] addr,
    input  wire [31:0] wdata,
    output reg  [31:0] rdata
);

    // 1024 x 32-bit array (4KB total)
    reg [31:0] ram [0:1023];

    // Load the hex file during synthesis and simulation
    initial begin
        $readmemh(MEM_FILE, ram);
    end

    // Synchronous Read/Write (This forces Vivado to map it to physical BRAM)
    always @(posedge clk) begin
        if (we) begin
            // Address [11:2] safely converts a byte address to a word index
            ram[addr[11:2]] <= wdata;
        end
        
        if (re) begin
            rdata <= ram[addr[11:2]];
        end
    end

endmodule
