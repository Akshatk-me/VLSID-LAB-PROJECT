// =============================================================================
// csr_file.v
// CSR register file wrapper.
// Instantiates: csr_mcycle, csr_minstret, csr_mstatus, csr_mtvec, csr_mepc,
//               csr_mcause, csr_int_en_reg
//
// Supported CSR addresses:
//   0x300 mstatus
//   0x305 mtvec
//   0x341 mepc
//   0x342 mcause
//   0xB00 mcycle
//   0xB02 minstret
//   0x7C0 int_en (custom)
// =============================================================================

module csr_file (
    input  wire        clk,
    input  wire        rst,

    // --------- Software interface ---------
    input  wire [11:0] csr_addr,
    input  wire        csr_wen,
    input  wire [31:0] csr_wdata,
    output reg  [31:0] csr_rdata,

    // --------- Hardware interface ---------
    // Always-visible read outputs
    output wire [31:0] hw_mtvec,
    output wire [31:0] hw_mepc,
    output wire [31:0] hw_mcause,
    output wire        hw_mstatus_mie,
    output wire [4:0]  hw_int_en,

    // Hardware write inputs
    input  wire        commit_valid,
    input  wire        trap_entry,
    input  wire [31:0] trap_pc,
    input  wire [2:0]  trap_cause_id,
    input  wire        mret
);

    // -------------------------------------------------------------------------
    // CSR address constants
    // -------------------------------------------------------------------------
    localparam [11:0] CSR_MSTATUS  = 12'h300;
    localparam [11:0] CSR_MTVEC    = 12'h305;
    localparam [11:0] CSR_MEPC     = 12'h341;
    localparam [11:0] CSR_MCAUSE   = 12'h342;
    localparam [11:0] CSR_MCYCLE   = 12'hB00;
    localparam [11:0] CSR_MINSTRET = 12'hB02;
    localparam [11:0] CSR_INT_EN   = 12'h7C0;

    // -------------------------------------------------------------------------
    // Per-CSR write enables
    // -------------------------------------------------------------------------
    wire wen_mstatus  = csr_wen && (csr_addr == CSR_MSTATUS);
    wire wen_mtvec    = csr_wen && (csr_addr == CSR_MTVEC);
    wire wen_mepc     = csr_wen && (csr_addr == CSR_MEPC);
    wire wen_mcause   = csr_wen && (csr_addr == CSR_MCAUSE);
    wire wen_mcycle   = csr_wen && (csr_addr == CSR_MCYCLE);
    wire wen_minstret = csr_wen && (csr_addr == CSR_MINSTRET);
    wire wen_int_en   = csr_wen && (csr_addr == CSR_INT_EN);

    // -------------------------------------------------------------------------
    // Per-CSR read data
    // -------------------------------------------------------------------------
    wire [31:0] rdata_mstatus;
    wire [31:0] rdata_mtvec;
    wire [31:0] rdata_mepc;
    wire [31:0] rdata_mcause;
    wire [31:0] rdata_mcycle;
    wire [31:0] rdata_minstret;
    wire [31:0] rdata_int_en;

    // -------------------------------------------------------------------------
    // Instances
    // -------------------------------------------------------------------------
    csr_mstatus u_csr_mstatus (
        .clk        (clk),
        .rst        (rst),
        .trap_entry (trap_entry),
        .mret       (mret),
        .wen        (wen_mstatus),
        .wdata      (csr_wdata),
        .rdata      (rdata_mstatus)
    );

    csr_mtvec u_csr_mtvec (
        .clk   (clk),
        .rst   (rst),
        .wen   (wen_mtvec),
        .wdata (csr_wdata),
        .rdata (rdata_mtvec)
    );

    csr_mepc u_csr_mepc (
        .clk        (clk),
        .rst        (rst),
        .trap_entry (trap_entry),
        .trap_pc    (trap_pc),
        .wen        (wen_mepc),
        .wdata      (csr_wdata),
        .rdata      (rdata_mepc)
    );

    csr_mcause u_csr_mcause (
        .clk           (clk),
        .rst           (rst),
        .trap_entry    (trap_entry),
        .trap_cause_id (trap_cause_id),
        .wen           (wen_mcause),
        .wdata         (csr_wdata),
        .rdata         (rdata_mcause)
    );

    csr_mcycle u_csr_mcycle (
        .clk   (clk),
        .rst   (rst),
        .wen   (wen_mcycle),
        .wdata (csr_wdata),
        .rdata (rdata_mcycle)
    );

    csr_minstret u_csr_minstret (
        .clk          (clk),
        .rst          (rst),
        .commit_valid (commit_valid),
        .wen          (wen_minstret),
        .wdata        (csr_wdata),
        .rdata        (rdata_minstret)
    );

    csr_int_en_reg u_csr_int_en (
        .clk   (clk),
        .rst   (rst),
        .wen   (wen_int_en),
        .wdata (csr_wdata),
        .rdata (rdata_int_en)
    );

    // -------------------------------------------------------------------------
    // Software read mux
    // -------------------------------------------------------------------------
    always @(*) begin
        case (csr_addr)
            CSR_MSTATUS:  csr_rdata = rdata_mstatus;
            CSR_MTVEC:    csr_rdata = rdata_mtvec;
            CSR_MEPC:     csr_rdata = rdata_mepc;
            CSR_MCAUSE:   csr_rdata = rdata_mcause;
            CSR_MCYCLE:   csr_rdata = rdata_mcycle;
            CSR_MINSTRET: csr_rdata = rdata_minstret;
            CSR_INT_EN:   csr_rdata = rdata_int_en;
            default:      csr_rdata = 32'b0;
        endcase
    end

    // -------------------------------------------------------------------------
    // Hardware interface outputs
    // -------------------------------------------------------------------------
    assign hw_mtvec       = rdata_mtvec;
    assign hw_mepc        = rdata_mepc;
    assign hw_mcause      = rdata_mcause;
    assign hw_mstatus_mie = rdata_mstatus[3];
    assign hw_int_en      = rdata_int_en[4:0];

endmodule