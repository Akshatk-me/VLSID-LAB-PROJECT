(* ram_style = "block" *)
module bram (
    input clk, en,
    input [3:0] wea,
    input [31:0] addra, dina,
    output [31:0] douta
);
    reg [31:0] ram [0:8191];
    reg [31:0] pipe1 = 0; // Ensures valid data at Time 0
    reg [31:0] pipe2 = 0; // Ensures valid data at Time 0

    integer i;
    initial begin
        // 1. Holistic Zeroing: Sets ALL 8192 locations to 0
        for (i = 0; i < 8192; i = i + 1) begin
            ram[i] = 32'h13;
        end
        
        // 2. Overwrite: Only modifies the addresses found in your file
        $readmemh("init_data.mem", ram);
    end

    wire [12:0] addr = addra[12:0];

    always @(posedge clk) begin
        if (en) begin
            if (wea[0]) ram[addr][7:0]   <= dina[7:0];
            if (wea[1]) ram[addr][15:8]  <= dina[15:8];
            if (wea[2]) ram[addr][23:16] <= dina[23:16];
            if (wea[3]) ram[addr][31:24] <= dina[31:24];
            
            pipe1 <= ram[addr];
        end
    end

    always @(posedge clk) begin
        if (en) pipe2 <= pipe1;
    end

    assign douta = pipe2;
endmodule