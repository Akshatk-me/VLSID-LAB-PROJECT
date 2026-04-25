// --- Instruction Memory Interface (MMIO) ---
interface instr_bus_intf;
    logic [31:0] addr;
    logic        req_valid;  // IF is requesting data
    logic [31:0] rdata;
    logic        rdata_valid;  // MMIO bridge says "Here is your multicycle data"

    modport master(output addr, req_valid, input rdata, rdata_valid);

    // The MMIO/Memory acts as the slave
    modport slave(input addr, req_valid, output rdata, rdata_valid);
endinterface
