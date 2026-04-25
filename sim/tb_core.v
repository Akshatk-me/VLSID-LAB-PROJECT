module top_sim (
    input wire clk,
    input wire rst
);
    wire [31:0] mem_addr, mem_wdata, mem_rdata;
    wire mem_we, mem_re;

    // Your CPU Core
    rv32i_core cpu (
        .clk(clk),
        .rst(rst),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_we(mem_we),
        .mem_re(mem_re),
        .mem_rdata(mem_rdata)
    );

    // Xilinx BRAM IP Instantiation
    // Note: BRAM IP usually takes a bit-address, but expects to read standard widths.
    // Address [31:2] strips the bottom 2 bits to convert byte-address to word-address.
    blk_mem_gen_0 bram_inst (
        .clka(clk),
        .wea(mem_we),
        .addra(mem_addr[11:2]), // Word address for a 1024-depth RAM
        .dina(mem_wdata),
        .douta(mem_rdata)
    );
endmodule
