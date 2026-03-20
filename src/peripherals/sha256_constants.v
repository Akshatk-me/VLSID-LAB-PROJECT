module sha256_constants (
    input wire [5:0] round_idx, // 0 to 63
    output reg [31:0] k_out,    // Round constant K[i]
    output wire [31:0] h0, h1, h2, h3, h4, h5, h6, h7 // Initial Hash Values
);

    // Initial Hash Values (First 32 bits of the fractional parts of the square roots of the first 8 primes)
    assign h0 = 32'h6a09e667;
    assign h1 = 32'hbb67ae85;
    assign h2 = 32'h3c6ef372;
    assign h3 = 32'ha54ff53a;
    assign h4 = 32'h510e527f;
    assign h5 = 32'h9b05688c;
    assign h6 = 32'h1f83d9ab;
    assign h7 = 32'h5be0cd19;

    // Combinational ROM for the 64 round constants
    always @(*) begin
        case (round_idx)
            6'd00: k_out = 32'h428a2f98;
            6'd01: k_out = 32'h71374491;
            6'd02: k_out = 32'hb5c0fbcf;
            6'd03: k_out = 32'he9b5dba5;
            // ... Add the remaining 60 constants here ...
            6'd63: k_out = 32'hc67178f2;
            default: k_out = 32'h00000000;
        endcase
    end
endmodule
