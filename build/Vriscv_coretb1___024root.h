// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vriscv_coretb1.h for the primary calling header

#ifndef VERILATED_VRISCV_CORETB1___024ROOT_H_
#define VERILATED_VRISCV_CORETB1___024ROOT_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"
class Vriscv_coretb1_cpu_bus_intf;


class Vriscv_coretb1__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vriscv_coretb1___024root final {
  public:
    // CELLS
    Vriscv_coretb1_cpu_bus_intf* __PVT__riscv_coretb1__DOT__instr_bus;
    Vriscv_coretb1_cpu_bus_intf* __PVT__riscv_coretb1__DOT__data_bus;
    Vriscv_coretb1_cpu_bus_intf* __PVT__riscv_coretb1__DOT__bram_bus;
    Vriscv_coretb1_cpu_bus_intf* __PVT__riscv_coretb1__DOT__uart_bus;
    Vriscv_coretb1_cpu_bus_intf* __PVT__riscv_coretb1__DOT__sha_bus;
    Vriscv_coretb1_cpu_bus_intf* __PVT__riscv_coretb1__DOT__gpio_bus;

    // DESIGN SPECIFIC STATE
    // Anonymous structures to workaround compiler member-count bugs
    struct {
        CData/*0:0*/ riscv_coretb1__DOT__clk;
        CData/*0:0*/ riscv_coretb1__DOT__rst;
        CData/*0:0*/ riscv_coretb1__DOT__uut__DOT__branch_taken;
        CData/*0:0*/ riscv_coretb1__DOT__uut__DOT__id_ex_flush;
        CData/*1:0*/ riscv_coretb1__DOT__uut__DOT__forward_a;
        CData/*1:0*/ riscv_coretb1__DOT__uut__DOT__forward_b;
        CData/*0:0*/ riscv_coretb1__DOT__uut__DOT__u_if__DOT__request_pending;
        CData/*0:0*/ riscv_coretb1__DOT__uut__DOT__u_id__DOT__wb_reg_we;
        CData/*0:0*/ riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_active;
        CData/*0:0*/ riscv_coretb1__DOT__uut__DOT__u_ex__DOT____VdfgRegularize_h20fff292_0_0;
        CData/*1:0*/ riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state;
        CData/*4:0*/ riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__count;
        CData/*0:0*/ riscv_coretb1__DOT__uut__DOT__u_mem__DOT__request_pending;
        CData/*0:0*/ riscv_coretb1__DOT__uut__DOT__u_mem__DOT__is_mem_op;
        CData/*0:0*/ riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__if_stall;
        CData/*0:0*/ riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__ex_stall;
        CData/*0:0*/ riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__mem_stall;
        CData/*0:0*/ riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__pc_stall;
        CData/*0:0*/ riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__id_ex_stall;
        CData/*0:0*/ riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__backend_stall;
        CData/*0:0*/ riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__load_use_hazard;
        CData/*1:0*/ riscv_coretb1__DOT__u_interconnect__DOT__state;
        CData/*2:0*/ riscv_coretb1__DOT__u_interconnect__DOT__latched_target;
        CData/*0:0*/ riscv_coretb1__DOT__u_interconnect__DOT__owner;
        CData/*0:0*/ riscv_coretb1__DOT__u_interconnect__DOT__latched_we;
        CData/*3:0*/ riscv_coretb1__DOT__u_interconnect__DOT__latched_be;
        CData/*0:0*/ riscv_coretb1__DOT__u_interconnect__DOT__p_valid;
        CData/*0:0*/ riscv_coretb1__DOT__u_interconnect__DOT__grant_mem;
        CData/*0:0*/ riscv_coretb1__DOT__u_interconnect__DOT__grant_if;
        CData/*1:0*/ riscv_coretb1__DOT__u_bram__DOT__state;
        CData/*0:0*/ __VstlFirstIteration;
        CData/*0:0*/ __VstlPhaseResult;
        CData/*0:0*/ __Vtrigprevexpr___TOP__riscv_coretb1__DOT__clk__0;
        CData/*0:0*/ __VactPhaseResult;
        CData/*0:0*/ __VinactPhaseResult;
        CData/*0:0*/ __VnbaPhaseResult;
        IData/*31:0*/ riscv_coretb1__DOT__uut__DOT__pc_current;
        IData/*31:0*/ riscv_coretb1__DOT__uut__DOT__pc_next;
        IData/*31:0*/ riscv_coretb1__DOT__uut__DOT__u_id__DOT__wb_rd_data;
        IData/*31:0*/ riscv_coretb1__DOT__uut__DOT__u_id__DOT__imm_ext;
        IData/*31:0*/ riscv_coretb1__DOT__uut__DOT__u_ex__DOT__alu_operand_b;
        IData/*31:0*/ riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplicand;
        IData/*31:0*/ riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplier;
        VlWide<3>/*64:0*/ riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P;
        IData/*31:0*/ riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__A;
        VlWide<3>/*64:0*/ riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P_next;
        IData/*31:0*/ riscv_coretb1__DOT__u_interconnect__DOT__latched_addr;
        IData/*31:0*/ riscv_coretb1__DOT__u_interconnect__DOT__latched_wdata;
        IData/*31:0*/ riscv_coretb1__DOT__u_interconnect__DOT__saved_rdata;
        IData/*31:0*/ riscv_coretb1__DOT__u_interconnect__DOT__p_data;
        IData/*31:0*/ riscv_coretb1__DOT__u_bram__DOT__saved_rdata;
        IData/*31:0*/ __VactIterCount;
        IData/*31:0*/ __VinactIterCount;
        IData/*31:0*/ __Vi;
        QData/*32:0*/ riscv_coretb1__DOT__uut__DOT__if_id_out;
        VlWide<5>/*154:0*/ riscv_coretb1__DOT__uut__DOT__id_ex_in;
        VlWide<5>/*154:0*/ riscv_coretb1__DOT__uut__DOT__id_ex_out;
        VlWide<3>/*72:0*/ riscv_coretb1__DOT__uut__DOT__ex_mem_out;
        VlWide<3>/*71:0*/ riscv_coretb1__DOT__uut__DOT__mem_wb_out;
        QData/*63:0*/ riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_result_64;
        VlUnpacked<IData/*31:0*/, 32> riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers;
        VlUnpacked<IData/*31:0*/, 1024> riscv_coretb1__DOT__u_bram__DOT__mem;
        VlUnpacked<QData/*63:0*/, 1> __VstlTriggered;
        VlUnpacked<QData/*63:0*/, 1> __VactTriggered;
    };
    struct {
        VlUnpacked<QData/*63:0*/, 1> __VactTriggeredAcc;
        VlUnpacked<QData/*63:0*/, 1> __VnbaTriggered;
        VlUnpacked<CData/*0:0*/, 2> __Vm_traceActivity;
    };
    VlDelayScheduler __VdlySched;

    // INTERNAL VARIABLES
    Vriscv_coretb1__Syms* vlSymsp;
    const char* vlNamep;

    // CONSTRUCTORS
    Vriscv_coretb1___024root(Vriscv_coretb1__Syms* symsp, const char* namep);
    ~Vriscv_coretb1___024root();
    VL_UNCOPYABLE(Vriscv_coretb1___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
