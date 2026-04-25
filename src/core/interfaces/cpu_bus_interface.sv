interface cpu_bus_intf;

    // ============================================================
    // Request Channel (CPU → Interconnect / Peripheral)
    // ============================================================

    logic        req_valid;  // CPU: "I want to start a transaction"
    logic        grant;  // Interconnect: "Request accepted this cycle"

    logic [31:0] addr;  // Address
    logic        we;  // Write enable (1 = write, 0 = read)
    logic [ 3:0] be;  // Byte enable
    logic [31:0] wdata;  // Write data

    // ============================================================
    // Response Channel (Interconnect / Peripheral → CPU)
    // ============================================================

    logic [31:0] rdata;  // Read data (or undefined for writes)
    logic        rdata_valid;  // "Response is available"
    logic        ready;  // CPU: "I can accept response this cycle"

    // ============================================================
    // MASTER (CPU side: IF / MEM stages)
    // ============================================================

    modport master(
        // Requests
        output req_valid,
        input grant,

        output addr,
        output we,
        output be,
        output wdata,

        // Responses
        input rdata,
        input rdata_valid,
        output ready
    );

    // ============================================================
    // SLAVE (Interconnect side when connected to CPU)
    // ============================================================

    modport slave(
        // Requests
        input req_valid,
        output grant,

        input addr,
        input we,
        input be,
        input wdata,

        // Responses
        output rdata,
        output rdata_valid,
        input ready
    );

    // ============================================================
    // PERIPHERAL SIDE (Interconnect → Peripheral)
    // (No grant here, interconnect already arbitrates)
    // ============================================================

    modport peripheral(
        // Requests from interconnect
        input req_valid,
        input addr,
        input we,
        input be,
        input wdata,

        // Response back to interconnect
        output rdata,
        output rdata_valid,
        input ready
    );

endinterface
