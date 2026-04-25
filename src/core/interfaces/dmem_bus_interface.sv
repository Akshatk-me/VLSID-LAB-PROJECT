interface data_bus_intf;
    logic [31:0] addr;
    logic        req_valid;  // High for both reads and writes
    logic        we;  // 1 = Write, 0 = Read
    logic [ 3:0] be;  // Byte enables (e.g., 4'b1111 for Word, 4'b0001 for Byte)
    logic [31:0] wdata;

    logic [31:0] rdata;  // Comes from BRAM
    logic        rdata_valid;

    modport master(output addr, req_valid, we, be, wdata, input rdata, rdata_valid);

    modport slave(input addr, req_valid, we, be, wdata, output rdata, rdata_valid);
endinterface
