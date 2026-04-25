// =============================================================================
// csr_mcause.v
// mcause CSR (machine trap cause).
// CSR address 0x342.
//
// Behavior:
//   - Hardware-written on trap entry with the cause code from the interrupt
//     controller (or exception logic when added).
//   - Software-writable via CSR write port.
//   - Synchronous reset clears to 0.
//
// For interrupts, the RISC-V spec sets bit 31 of mcause to 1 and the low
// bits to the cause ID. For simplicity in this embedded core, we store the
// 3-bit source ID in the low bits and set bit 31 to mark it as an interrupt.
//
// Priority: trap_entry > csr_write > hold
// =============================================================================

module csr_mcause (
    input  wire        clk,
    input  wire        rst,

    // Hardware trap capture
    input  wire        trap_entry,
    input  wire [2:0]  trap_cause_id,   // from interrupt controller (0..4)

    // CSR write port (software)
    input  wire        wen,
    input  wire [31:0] wdata,

    // CSR read port (combinational)
    output wire [31:0] rdata
);

    reg [31:0] mcause;

    always @(posedge clk) begin
        if (rst) begin
            mcause <= 32'b0;
        end else if (trap_entry) begin
            // Bit 31 = 1 marks this as an interrupt (per RISC-V spec);
            // low bits hold the source ID.
            mcause <= {1'b1, 28'b0, trap_cause_id};
        end else if (wen) begin
            mcause <= wdata;
        end
    end

    assign rdata = mcause;

endmodule