// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vriscv_coretb1.h for the primary calling header

#include "Vriscv_coretb1__pch.h"

VL_ATTR_COLD void Vriscv_coretb1___024root___eval_initial__TOP(Vriscv_coretb1___024root* vlSelf);
VlCoroutine Vriscv_coretb1___024root___eval_initial__TOP__Vtiming__0(Vriscv_coretb1___024root* vlSelf);
VlCoroutine Vriscv_coretb1___024root___eval_initial__TOP__Vtiming__1(Vriscv_coretb1___024root* vlSelf);

void Vriscv_coretb1___024root___eval_initial(Vriscv_coretb1___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___eval_initial\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vriscv_coretb1___024root___eval_initial__TOP(vlSelf);
    Vriscv_coretb1___024root___eval_initial__TOP__Vtiming__0(vlSelf);
    Vriscv_coretb1___024root___eval_initial__TOP__Vtiming__1(vlSelf);
}

VlCoroutine Vriscv_coretb1___024root___eval_initial__TOP__Vtiming__0(Vriscv_coretb1___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___eval_initial__TOP__Vtiming__0\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    co_await vlSelfRef.__VdlySched.delay(0x000000000000000aULL, 
                                         nullptr, "sim/riscv_coretb1.sv", 
                                         60);
    vlSelfRef.riscv_coretb1__DOT__rst = 0U;
    co_await vlSelfRef.__VdlySched.delay(0x0000000000002710ULL, 
                                         nullptr, "sim/riscv_coretb1.sv", 
                                         61);
    VL_FINISH_MT("sim/riscv_coretb1.sv", 62, "");
    co_return;
}

VlCoroutine Vriscv_coretb1___024root___eval_initial__TOP__Vtiming__1(Vriscv_coretb1___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___eval_initial__TOP__Vtiming__1\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    while (VL_LIKELY(!vlSymsp->_vm_contextp__->gotFinish())) {
        co_await vlSelfRef.__VdlySched.delay(5ULL, 
                                             nullptr, 
                                             "sim/riscv_coretb1.sv", 
                                             5);
        vlSelfRef.riscv_coretb1__DOT__clk = (1U & (~ (IData)(vlSelfRef.riscv_coretb1__DOT__clk)));
    }
    co_return;
}

void Vriscv_coretb1___024root___eval_triggers_vec__act(Vriscv_coretb1___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___eval_triggers_vec__act\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VactTriggered[0U] = (QData)((IData)(
                                                    ((vlSelfRef.__VdlySched.awaitingCurrentTime() 
                                                      << 1U) 
                                                     | ((IData)(vlSelfRef.riscv_coretb1__DOT__clk) 
                                                        & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__riscv_coretb1__DOT__clk__0))))));
    vlSelfRef.__Vtrigprevexpr___TOP__riscv_coretb1__DOT__clk__0 
        = vlSelfRef.riscv_coretb1__DOT__clk;
}

bool Vriscv_coretb1___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___trigger_anySet__act\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        if (in[n]) {
            return (1U);
        }
        n = ((IData)(1U) + n);
    } while ((1U > n));
    return (0U);
}

void Vriscv_coretb1___024root___nba_sequent__TOP__0(Vriscv_coretb1___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___nba_sequent__TOP__0\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*2:0*/ __Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__0__Vfuncout;
    __Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__0__Vfuncout = 0;
    IData/*31:0*/ __Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__0__a;
    __Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__0__a = 0;
    CData/*2:0*/ __Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__1__Vfuncout;
    __Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__1__Vfuncout = 0;
    IData/*31:0*/ __Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__1__a;
    __Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__1__a = 0;
    IData/*31:0*/ __Vdly__riscv_coretb1__DOT__uut__DOT__pc_current;
    __Vdly__riscv_coretb1__DOT__uut__DOT__pc_current = 0;
    CData/*0:0*/ __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_active;
    __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_active = 0;
    CData/*1:0*/ __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state;
    __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state = 0;
    CData/*4:0*/ __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__count;
    __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__count = 0;
    VlWide<3>/*64:0*/ __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P;
    VL_ZERO_W(65, __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P);
    CData/*1:0*/ __Vdly__riscv_coretb1__DOT__u_interconnect__DOT__state;
    __Vdly__riscv_coretb1__DOT__u_interconnect__DOT__state = 0;
    CData/*0:0*/ __Vdly__riscv_coretb1__DOT__u_interconnect__DOT__owner;
    __Vdly__riscv_coretb1__DOT__u_interconnect__DOT__owner = 0;
    CData/*1:0*/ __Vdly__riscv_coretb1__DOT__u_bram__DOT__state;
    __Vdly__riscv_coretb1__DOT__u_bram__DOT__state = 0;
    CData/*0:0*/ __VdlySet__riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers__v0;
    __VdlySet__riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers__v0 = 0;
    IData/*31:0*/ __VdlyVal__riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers__v31;
    __VdlyVal__riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers__v31 = 0;
    CData/*4:0*/ __VdlyDim0__riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers__v31;
    __VdlyDim0__riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers__v31 = 0;
    CData/*0:0*/ __VdlySet__riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers__v31;
    __VdlySet__riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers__v31 = 0;
    IData/*31:0*/ __VdlyVal__riscv_coretb1__DOT__u_bram__DOT__mem__v0;
    __VdlyVal__riscv_coretb1__DOT__u_bram__DOT__mem__v0 = 0;
    SData/*9:0*/ __VdlyDim0__riscv_coretb1__DOT__u_bram__DOT__mem__v0;
    __VdlyDim0__riscv_coretb1__DOT__u_bram__DOT__mem__v0 = 0;
    CData/*0:0*/ __VdlySet__riscv_coretb1__DOT__u_bram__DOT__mem__v0;
    __VdlySet__riscv_coretb1__DOT__u_bram__DOT__mem__v0 = 0;
    VlWide<3>/*95:0*/ __Vtemp_4;
    VlWide<3>/*95:0*/ __Vtemp_5;
    // Body
    __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__count 
        = vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__count;
    __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U] 
        = vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U];
    __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[1U] 
        = vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[1U];
    __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[2U] 
        = vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[2U];
    __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state 
        = vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state;
    __Vdly__riscv_coretb1__DOT__uut__DOT__pc_current 
        = vlSelfRef.riscv_coretb1__DOT__uut__DOT__pc_current;
    __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_active 
        = vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_active;
    __Vdly__riscv_coretb1__DOT__u_interconnect__DOT__owner 
        = vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__owner;
    __Vdly__riscv_coretb1__DOT__u_interconnect__DOT__state 
        = vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__state;
    __VdlySet__riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers__v0 = 0U;
    __VdlySet__riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers__v31 = 0U;
    __VdlySet__riscv_coretb1__DOT__u_bram__DOT__mem__v0 = 0U;
    __Vdly__riscv_coretb1__DOT__u_bram__DOT__state 
        = vlSelfRef.riscv_coretb1__DOT__u_bram__DOT__state;
    if (((IData)(vlSelfRef.riscv_coretb1__DOT__rst) 
         | (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__branch_taken))) {
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out = 0ULL;
    } else if ((1U & (~ (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__pc_stall)))) {
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
            = (((QData)((IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__saved_rdata)) 
                << 1U) | (QData)((IData)(((~ (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__if_stall)) 
                                          & (IData)(vlSymsp->TOP__riscv_coretb1__DOT__instr_bus.rdata_valid)))));
    }
    if (vlSelfRef.riscv_coretb1__DOT__rst) {
        __Vdly__riscv_coretb1__DOT__uut__DOT__pc_current = 0U;
        __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_active = 0U;
        __VdlySet__riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers__v0 = 1U;
    } else {
        if ((1U & (~ (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__pc_stall)))) {
            __Vdly__riscv_coretb1__DOT__uut__DOT__pc_current 
                = ((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__branch_taken)
                    ? ((1U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                        ? (((vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[4U] 
                             << 5U) | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[3U] 
                                       >> 0x0000001bU)) 
                           + ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[1U] 
                               << 5U) | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
                                         >> 0x0000001bU)))
                        : 0U) : ((IData)(4U) + vlSelfRef.riscv_coretb1__DOT__uut__DOT__pc_current));
        }
        if ((IData)(((3U == (3U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])) 
                     & (~ (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_active))))) {
            __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_active = 1U;
        } else if ((2U == (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state))) {
            __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_active = 0U;
        }
        if (((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__wb_reg_we) 
             & (0U != (0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__mem_wb_out[0U] 
                                      >> 3U))))) {
            __VdlyVal__riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers__v31 
                = vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__wb_rd_data;
            __VdlyDim0__riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers__v31 
                = (0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__mem_wb_out[0U] 
                                  >> 3U));
            __VdlySet__riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers__v31 = 1U;
        }
    }
    if (__VdlySet__riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers__v0) {
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[1U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[2U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[3U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[4U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[5U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[6U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[7U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[8U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[9U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[10U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[11U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[12U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[13U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[14U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[15U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[16U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[17U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[18U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[19U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[20U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[21U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[22U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[23U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[24U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[25U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[26U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[27U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[28U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[29U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[30U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[31U] = 0U;
    }
    if (__VdlySet__riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers__v31) {
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[__VdlyDim0__riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers__v31] 
            = __VdlyVal__riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers__v31;
    }
    if (vlSelfRef.riscv_coretb1__DOT__rst) {
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_if__DOT__request_pending = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_mem__DOT__request_pending = 0U;
        __Vdly__riscv_coretb1__DOT__u_bram__DOT__state = 0U;
        vlSelfRef.riscv_coretb1__DOT__u_bram__DOT__saved_rdata = 0U;
    } else {
        if (vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__grant_if) {
            vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_if__DOT__request_pending = 1U;
        } else if (((IData)(vlSymsp->TOP__riscv_coretb1__DOT__instr_bus.rdata_valid) 
                    & (~ (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__if_stall)))) {
            vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_if__DOT__request_pending = 0U;
        }
        if (vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__grant_mem) {
            vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_mem__DOT__request_pending = 1U;
        } else if (((IData)(vlSymsp->TOP__riscv_coretb1__DOT__data_bus.rdata_valid) 
                    & (~ (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__mem_stall)))) {
            vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_mem__DOT__request_pending = 0U;
        }
        if ((0U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_bram__DOT__state))) {
            if (vlSymsp->TOP__riscv_coretb1__DOT__bram_bus.grant) {
                if (vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_we) {
                    __VdlyVal__riscv_coretb1__DOT__u_bram__DOT__mem__v0 
                        = vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_wdata;
                    __VdlyDim0__riscv_coretb1__DOT__u_bram__DOT__mem__v0 
                        = (0x000003ffU & (vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_addr 
                                          >> 2U));
                    __VdlySet__riscv_coretb1__DOT__u_bram__DOT__mem__v0 = 1U;
                    vlSelfRef.riscv_coretb1__DOT__u_bram__DOT__saved_rdata = 0U;
                } else {
                    vlSelfRef.riscv_coretb1__DOT__u_bram__DOT__saved_rdata 
                        = vlSelfRef.riscv_coretb1__DOT__u_bram__DOT__mem
                        [(0x000003ffU & (vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_addr 
                                         >> 2U))];
                }
                __Vdly__riscv_coretb1__DOT__u_bram__DOT__state = 1U;
            }
        } else if ((1U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_bram__DOT__state))) {
            if (vlSymsp->TOP__riscv_coretb1__DOT__bram_bus.ready) {
                __Vdly__riscv_coretb1__DOT__u_bram__DOT__state = 0U;
            }
        }
    }
    if (__VdlySet__riscv_coretb1__DOT__u_bram__DOT__mem__v0) {
        vlSelfRef.riscv_coretb1__DOT__u_bram__DOT__mem[__VdlyDim0__riscv_coretb1__DOT__u_bram__DOT__mem__v0] 
            = __VdlyVal__riscv_coretb1__DOT__u_bram__DOT__mem__v0;
    }
    vlSelfRef.riscv_coretb1__DOT__u_bram__DOT__state 
        = __Vdly__riscv_coretb1__DOT__u_bram__DOT__state;
    if (vlSelfRef.riscv_coretb1__DOT__rst) {
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__mem_wb_out[0U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__mem_wb_out[1U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__mem_wb_out[2U] = 0U;
    } else {
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__mem_wb_out[0U] 
            = (((IData)((((QData)((IData)(((vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[2U] 
                                            << 0x00000017U) 
                                           | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[1U] 
                                              >> 9U)))) 
                          << 0x00000020U) | (QData)((IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__saved_rdata)))) 
                << 8U) | ((0x000000f8U & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] 
                                          >> 1U)) | 
                          ((6U & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] 
                                  >> 1U)) | (1U & (
                                                   (~ (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__mem_stall)) 
                                                   & vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U])))));
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__mem_wb_out[1U] 
            = (((IData)((((QData)((IData)(((vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[2U] 
                                            << 0x00000017U) 
                                           | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[1U] 
                                              >> 9U)))) 
                          << 0x00000020U) | (QData)((IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__saved_rdata)))) 
                >> 0x00000018U) | ((IData)(((((QData)((IData)(
                                                              ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[2U] 
                                                                << 0x00000017U) 
                                                               | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[1U] 
                                                                  >> 9U)))) 
                                              << 0x00000020U) 
                                             | (QData)((IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__saved_rdata))) 
                                            >> 0x00000020U)) 
                                   << 8U));
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__mem_wb_out[2U] 
            = ((IData)(((((QData)((IData)(((vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[2U] 
                                            << 0x00000017U) 
                                           | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[1U] 
                                              >> 9U)))) 
                          << 0x00000020U) | (QData)((IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__saved_rdata))) 
                        >> 0x00000020U)) >> 0x00000018U);
    }
    if ((1U & (~ VL_ONEHOT_I((((0x13U == (0x0000007fU 
                                          & (IData)(
                                                    (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                     >> 1U)))) 
                               << 1U) | (0x33U == (0x0000007fU 
                                                   & (IData)(
                                                             (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                              >> 1U))))))))) {
        if ((0U != (((0x13U == (0x0000007fU & (IData)(
                                                      (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                       >> 1U)))) 
                     << 1U) | (0x33U == (0x0000007fU 
                                         & (IData)(
                                                   (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                    >> 1U))))))) {
            if (VL_UNLIKELY((vlSymsp->_vm_contextp__->assertOn()))) {
                VL_WRITEF_NX("[%0t] %%Error: ID.sv:109: Assertion failed in %Nriscv_coretb1.uut.u_id: unique case, but multiple matches found for '7'h%x'\n",0,
                             64,VL_TIME_UNITED_Q(1),
                             -12,vlSymsp->name(),7,
                             (0x0000007fU & (IData)(
                                                    (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                     >> 1U))));
                VL_STOP_MT("src/core/ID.sv", 109, "");
            }
        }
    }
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__imm_ext 
        = ((1U & (IData)((vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                          >> 7U))) ? ((1U & (IData)(
                                                    (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                     >> 6U)))
                                       ? ((1U & (IData)(
                                                        (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                         >> 5U)))
                                           ? 0U : (
                                                   (1U 
                                                    & (IData)(
                                                              (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                               >> 4U)))
                                                    ? 0U
                                                    : 
                                                   ((1U 
                                                     & (IData)(
                                                               (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                                >> 3U)))
                                                     ? 0U
                                                     : 
                                                    ((1U 
                                                      & (IData)(
                                                                (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                                 >> 2U)))
                                                      ? 
                                                     ((1U 
                                                       & (IData)(
                                                                 (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                                  >> 1U)))
                                                       ? 
                                                      (((- (IData)(
                                                                   (1U 
                                                                    & (IData)(
                                                                              (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                                               >> 0x00000020U))))) 
                                                        << 0x0000000cU) 
                                                       | ((0x00000800U 
                                                           & ((IData)(
                                                                      (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                                       >> 8U)) 
                                                              << 0x0000000bU)) 
                                                          | ((0x000007e0U 
                                                              & ((IData)(
                                                                         (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                                          >> 0x0000001aU)) 
                                                                 << 5U)) 
                                                             | (0x0000001eU 
                                                                & ((IData)(
                                                                           (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                                            >> 9U)) 
                                                                   << 1U)))))
                                                       : 0U)
                                                      : 0U))))
                                       : 0U) : ((1U 
                                                 & (IData)(
                                                           (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                            >> 6U)))
                                                 ? 
                                                ((1U 
                                                  & (IData)(
                                                            (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                             >> 5U)))
                                                  ? 0U
                                                  : 
                                                 ((1U 
                                                   & (IData)(
                                                             (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                              >> 4U)))
                                                   ? 0U
                                                   : 
                                                  ((1U 
                                                    & (IData)(
                                                              (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                               >> 3U)))
                                                    ? 0U
                                                    : 
                                                   ((1U 
                                                     & (IData)(
                                                               (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                                >> 2U)))
                                                     ? 
                                                    ((1U 
                                                      & (IData)(
                                                                (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                                 >> 1U)))
                                                      ? 
                                                     (((- (IData)(
                                                                  (1U 
                                                                   & (IData)(
                                                                             (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                                              >> 0x00000020U))))) 
                                                       << 0x0000000cU) 
                                                      | ((0x00000fe0U 
                                                          & ((IData)(
                                                                     (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                                      >> 0x0000001aU)) 
                                                             << 5U)) 
                                                         | (0x0000001fU 
                                                            & (IData)(
                                                                      (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                                       >> 8U)))))
                                                      : 0U)
                                                     : 0U))))
                                                 : 
                                                ((1U 
                                                  & (IData)(
                                                            (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                             >> 4U)))
                                                  ? 0U
                                                  : 
                                                 ((1U 
                                                   & (IData)(
                                                             (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                              >> 3U)))
                                                   ? 0U
                                                   : 
                                                  ((1U 
                                                    & (IData)(
                                                              (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                               >> 2U)))
                                                    ? 
                                                   ((1U 
                                                     & (IData)(
                                                               (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                                >> 1U)))
                                                     ? 
                                                    (((- (IData)(
                                                                 (1U 
                                                                  & (IData)(
                                                                            (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                                             >> 0x00000020U))))) 
                                                      << 0x0000000cU) 
                                                     | (0x00000fffU 
                                                        & (IData)(
                                                                  (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                                   >> 0x00000015U))))
                                                     : 0U)
                                                    : 0U)))));
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__wb_rd_data 
        = ((2U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__mem_wb_out[0U])
            ? ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__mem_wb_out[1U] 
                << 0x00000018U) | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__mem_wb_out[0U] 
                                   >> 8U)) : ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__mem_wb_out[2U] 
                                               << 0x00000018U) 
                                              | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__mem_wb_out[1U] 
                                                 >> 8U)));
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__wb_reg_we 
        = (IData)((5U == (5U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__mem_wb_out[0U])));
    if (vlSelfRef.riscv_coretb1__DOT__rst) {
        __Vdly__riscv_coretb1__DOT__u_interconnect__DOT__state = 0U;
        __Vdly__riscv_coretb1__DOT__u_interconnect__DOT__owner = 0U;
    } else if ((0U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__state))) {
        if (vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__grant_mem) {
            __Vdly__riscv_coretb1__DOT__u_interconnect__DOT__owner = 1U;
            vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_addr 
                = ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[2U] 
                    << 0x00000017U) | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[1U] 
                                       >> 9U));
            vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_wdata 
                = ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[1U] 
                    << 0x00000017U) | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] 
                                       >> 9U));
            vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_we 
                = (1U & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] 
                         >> 1U));
            vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_be = 0x0fU;
            __Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__0__a 
                = ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[2U] 
                    << 0x00000017U) | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[1U] 
                                       >> 9U));
            {
                if ((0U == (__Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__0__a 
                            >> 0x10U))) {
                    __Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__0__Vfuncout = 1U;
                    goto __Vlabel0;
                }
                if ((8U == (__Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__0__a 
                            >> 0x1cU))) {
                    if ((0U == (0x0000000fU & (__Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__0__a 
                                               >> 0x0cU)))) {
                        __Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__0__Vfuncout = 2U;
                        goto __Vlabel0;
                    } else if ((1U == (0x0000000fU 
                                       & (__Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__0__a 
                                          >> 0x0cU)))) {
                        __Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__0__Vfuncout = 3U;
                        goto __Vlabel0;
                    } else if ((2U == (0x0000000fU 
                                       & (__Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__0__a 
                                          >> 0x0cU)))) {
                        __Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__0__Vfuncout = 4U;
                        goto __Vlabel0;
                    } else {
                        __Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__0__Vfuncout = 5U;
                        goto __Vlabel0;
                    }
                }
                __Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__0__Vfuncout = 5U;
                __Vlabel0: ;
            }
            vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_target 
                = __Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__0__Vfuncout;
            __Vdly__riscv_coretb1__DOT__u_interconnect__DOT__state = 1U;
        } else if (vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__grant_if) {
            __Vdly__riscv_coretb1__DOT__u_interconnect__DOT__owner = 0U;
            vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_addr 
                = vlSelfRef.riscv_coretb1__DOT__uut__DOT__pc_current;
            vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_wdata = 0U;
            vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_we = 0U;
            vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_be = 0x0fU;
            __Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__1__a 
                = vlSelfRef.riscv_coretb1__DOT__uut__DOT__pc_current;
            {
                if ((0U == (__Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__1__a 
                            >> 0x10U))) {
                    __Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__1__Vfuncout = 1U;
                    goto __Vlabel1;
                }
                if ((8U == (__Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__1__a 
                            >> 0x1cU))) {
                    if ((0U == (0x0000000fU & (__Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__1__a 
                                               >> 0x0cU)))) {
                        __Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__1__Vfuncout = 2U;
                        goto __Vlabel1;
                    } else if ((1U == (0x0000000fU 
                                       & (__Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__1__a 
                                          >> 0x0cU)))) {
                        __Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__1__Vfuncout = 3U;
                        goto __Vlabel1;
                    } else if ((2U == (0x0000000fU 
                                       & (__Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__1__a 
                                          >> 0x0cU)))) {
                        __Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__1__Vfuncout = 4U;
                        goto __Vlabel1;
                    } else {
                        __Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__1__Vfuncout = 5U;
                        goto __Vlabel1;
                    }
                }
                __Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__1__Vfuncout = 5U;
                __Vlabel1: ;
            }
            vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_target 
                = __Vfunc_riscv_coretb1__DOT__u_interconnect__DOT__decode_addr__1__Vfuncout;
            __Vdly__riscv_coretb1__DOT__u_interconnect__DOT__state = 1U;
        }
    } else if ((1U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__state))) {
        if (vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__p_valid) {
            vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__saved_rdata 
                = vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__p_data;
            __Vdly__riscv_coretb1__DOT__u_interconnect__DOT__state = 2U;
        }
    } else if ((2U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__state))) {
        if (((IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__owner) 
             & (~ (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__mem_stall)))) {
            __Vdly__riscv_coretb1__DOT__u_interconnect__DOT__state = 0U;
        } else if ((1U & ((~ (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__owner)) 
                          & (~ (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__if_stall))))) {
            __Vdly__riscv_coretb1__DOT__u_interconnect__DOT__state = 0U;
        }
    }
    if (vlSelfRef.riscv_coretb1__DOT__rst) {
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[1U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[2U] = 0U;
        __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state = 0U;
        __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__count = 0U;
        __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U] = 0U;
        __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[1U] = 0U;
        __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[2U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__A = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_result_64 = 0ULL;
    } else {
        if ((1U & (~ (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__mem_stall)))) {
            vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] 
                = ((0xfffffe00U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U]) 
                   | ((0x000001f0U & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
                                      >> 0x00000012U)) 
                      | ((0x0000000eU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
                                         >> 7U)) | 
                         (1U & ((~ (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__ex_stall)) 
                                & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])))));
            vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] 
                = ((0x000001ffU & vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U]) 
                   | (0xfffffe00U & ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[2U] 
                                      << 0x0000000eU) 
                                     | (0x00003e00U 
                                        & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[1U] 
                                           >> 0x00000012U)))));
            vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[1U] 
                = ((0xfffffe00U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[1U]) 
                   | (0x000001ffU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[2U] 
                                     >> 0x00000012U)));
            vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[1U] 
                = ((0x000001ffU & vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[1U]) 
                   | (((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_active)
                        ? ((2U == (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state))
                            ? (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_result_64)
                            : 0U) : ((1U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                      ? ((0x00000080U 
                                          & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                          ? 0U : ((0x00000040U 
                                                   & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                   ? 
                                                  ((0x00000020U 
                                                    & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                    ? 0U
                                                    : 
                                                   ((0x00000010U 
                                                     & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                     ? 0U
                                                     : 
                                                    (vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplicand 
                                                     ^ vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__alu_operand_b)))
                                                   : 
                                                  ((0x00000020U 
                                                    & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                    ? 
                                                   ((0x00000010U 
                                                     & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                     ? 
                                                    (vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplicand 
                                                     | vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__alu_operand_b)
                                                     : 
                                                    (vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplicand 
                                                     & vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__alu_operand_b))
                                                    : 
                                                   ((0x00000010U 
                                                     & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                     ? 
                                                    (vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplicand 
                                                     - vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__alu_operand_b)
                                                     : 
                                                    (vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplicand 
                                                     + vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__alu_operand_b)))))
                                      : 0U)) << 9U));
            vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[2U] 
                = (((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_active)
                     ? ((2U == (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state))
                         ? (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_result_64)
                         : 0U) : ((1U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                   ? ((0x00000080U 
                                       & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                       ? 0U : ((0x00000040U 
                                                & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                ? (
                                                   (0x00000020U 
                                                    & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                    ? 0U
                                                    : 
                                                   ((0x00000010U 
                                                     & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                     ? 0U
                                                     : 
                                                    (vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplicand 
                                                     ^ vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__alu_operand_b)))
                                                : (
                                                   (0x00000020U 
                                                    & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                    ? 
                                                   ((0x00000010U 
                                                     & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                     ? 
                                                    (vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplicand 
                                                     | vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__alu_operand_b)
                                                     : 
                                                    (vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplicand 
                                                     & vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__alu_operand_b))
                                                    : 
                                                   ((0x00000010U 
                                                     & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                     ? 
                                                    (vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplicand 
                                                     - vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__alu_operand_b)
                                                     : 
                                                    (vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplicand 
                                                     + vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__alu_operand_b)))))
                                   : 0U)) >> 0x00000017U);
        }
        if ((0U == (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state))) {
            if (((~ (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_active)) 
                 & (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT____VdfgRegularize_h20fff292_0_0))) {
                __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U] 
                    = ((IData)((QData)((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplier))) 
                       << 1U);
                __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[1U] 
                    = (((IData)((QData)((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplier))) 
                        >> 0x0000001fU) | ((IData)(
                                                   ((QData)((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplier)) 
                                                    >> 0x00000020U)) 
                                           << 1U));
                __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[2U] 
                    = ((IData)(((QData)((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplier)) 
                                >> 0x00000020U)) >> 0x0000001fU);
                vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__A 
                    = vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplicand;
                __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__count = 0x10U;
                __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state = 1U;
            }
        } else if ((1U == (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state))) {
            __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__count 
                = (0x0000001fU & ((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__count) 
                                  - (IData)(1U)));
            __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U] 
                = vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P_next[0U];
            __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[1U] 
                = vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P_next[1U];
            __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[2U] 
                = vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P_next[2U];
            if ((1U == (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__count))) {
                __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state = 2U;
            }
        } else if ((2U == (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state))) {
            vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_result_64 
                = (((QData)((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[2U])) 
                    << 0x0000003fU) | (((QData)((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[1U])) 
                                        << 0x0000001fU) 
                                       | ((QData)((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U])) 
                                          >> 1U)));
            __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state = 0U;
        }
    }
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__pc_current 
        = __Vdly__riscv_coretb1__DOT__uut__DOT__pc_current;
    vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__owner 
        = __Vdly__riscv_coretb1__DOT__u_interconnect__DOT__owner;
    vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__state 
        = __Vdly__riscv_coretb1__DOT__u_interconnect__DOT__state;
    vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__p_valid = 0U;
    vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__p_data = 0U;
    if ((1U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__state))) {
        if ((4U & (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_target))) {
            vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__p_valid 
                = ((1U & (~ ((IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_target) 
                             >> 1U))) && ((1U & (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_target)) 
                                          || (IData)(vlSymsp->TOP__riscv_coretb1__DOT__gpio_bus.rdata_valid)));
            vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__p_data 
                = ((2U & (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_target))
                    ? 0U : ((1U & (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_target))
                             ? 0xdeadbeefU : vlSymsp->TOP__riscv_coretb1__DOT__gpio_bus.rdata));
        } else if ((2U & (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_target))) {
            if ((1U & (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_target))) {
                vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__p_valid 
                    = vlSymsp->TOP__riscv_coretb1__DOT__sha_bus.rdata_valid;
                vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__p_data 
                    = vlSymsp->TOP__riscv_coretb1__DOT__sha_bus.rdata;
            } else {
                vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__p_valid 
                    = vlSymsp->TOP__riscv_coretb1__DOT__uart_bus.rdata_valid;
                vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__p_data 
                    = vlSymsp->TOP__riscv_coretb1__DOT__uart_bus.rdata;
            }
        } else {
            vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__p_valid 
                = ((1U & (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_target)) 
                   && (1U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_bram__DOT__state)));
            vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__p_data 
                = ((1U & (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_target))
                    ? vlSelfRef.riscv_coretb1__DOT__u_bram__DOT__saved_rdata
                    : 0U);
        }
    }
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_mem__DOT__is_mem_op 
        = (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] 
           & (0U != (6U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U])));
    if (((IData)(vlSelfRef.riscv_coretb1__DOT__rst) 
         | (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_flush))) {
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[1U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[2U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[3U] = 0U;
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[4U] = 0U;
    } else if ((1U & (~ (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__id_ex_stall)))) {
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
            = vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U];
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[1U] 
            = vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[1U];
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[2U] 
            = vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[2U];
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[3U] 
            = vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[3U];
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[4U] 
            = vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[4U];
    }
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__count 
        = __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__count;
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_active 
        = __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_active;
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U] 
        = __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U];
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[1U] 
        = __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[1U];
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[2U] 
        = __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[2U];
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state 
        = __Vdly__riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state;
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U] 
        = ((0xfffffffeU & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U]) 
           | (1U & (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out)));
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U] 
        = ((0xf8000fffU & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U]) 
           | (((0x00007c00U & ((IData)((vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                        >> 8U)) << 0x0000000aU)) 
               | ((0x000003e0U & ((IData)((vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                           >> 0x00000010U)) 
                                  << 5U)) | (0x0000001fU 
                                             & (IData)(
                                                       (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                        >> 0x00000015U))))) 
              << 0x0000000cU));
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U] 
        = ((0x07ffffffU & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U]) 
           | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__imm_ext 
              << 0x0000001bU));
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[1U] 
        = ((0xf8000000U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[1U]) 
           | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__imm_ext 
              >> 5U));
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[1U] 
        = ((0x07ffffffU & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[1U]) 
           | (((0U == (0x0000001fU & (IData)((vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                              >> 0x00000015U))))
                ? 0U : vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers
               [(0x0000001fU & (IData)((vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                        >> 0x00000015U)))]) 
              << 0x0000001bU));
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[2U] 
        = ((0xf8000000U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[2U]) 
           | (((0U == (0x0000001fU & (IData)((vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                              >> 0x00000015U))))
                ? 0U : vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers
               [(0x0000001fU & (IData)((vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                        >> 0x00000015U)))]) 
              >> 5U));
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[2U] 
        = ((0x07ffffffU & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[2U]) 
           | (((0U == (0x0000001fU & (IData)((vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                              >> 0x00000010U))))
                ? 0U : vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers
               [(0x0000001fU & (IData)((vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                        >> 0x00000010U)))]) 
              << 0x0000001bU));
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[3U] 
        = ((0xf8000000U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[3U]) 
           | (((0U == (0x0000001fU & (IData)((vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                              >> 0x00000010U))))
                ? 0U : vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers
               [(0x0000001fU & (IData)((vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                        >> 0x00000010U)))]) 
              >> 5U));
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U] 
        = (0xfffff8ffU & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U]);
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U] 
        = (0xfffffff1U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U]);
    if ((0x33U == (0x0000007fU & (IData)((vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                          >> 1U))))) {
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U] 
            = (0x00000400U | vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U]);
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U] 
            = (0xfffffff7U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U]);
        if ((1U == (0x0000007fU & (IData)((vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                           >> 0x0000001aU))))) {
            vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U] 
                = ((1U & (IData)((vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                  >> 0x0000000fU)))
                    ? (0xfffffffeU & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U])
                    : (2U | vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U]));
        }
    } else if ((0x13U == (0x0000007fU & (IData)((vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                 >> 1U))))) {
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U] 
            = (0x00000400U | vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U]);
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U] 
            = (8U | vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U]);
    }
    __Vtemp_4[0U] = (IData)((0x00000001ffffffffULL 
                             & (((QData)((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[1U])) 
                                 << 0x00000020U) | (QData)((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U])))));
    __Vtemp_4[1U] = (((((vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[2U] 
                         << 0x0000001fU) | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[1U] 
                                            >> 1U)) 
                       + ((4U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U])
                           ? ((2U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U])
                               ? ((1U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U])
                                   ? 0U : (- vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__A))
                               : ((1U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U])
                                   ? (- vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__A)
                                   : VL_SHIFTL_III(32,32,32, 
                                                   (- vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__A), 1U)))
                           : ((2U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U])
                               ? ((1U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U])
                                   ? VL_SHIFTL_III(32,32,32, vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__A, 1U)
                                   : vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__A)
                               : ((1U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U])
                                   ? vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__A
                                   : 0U)))) << 1U) 
                     | (IData)(((0x00000001ffffffffULL 
                                 & (((QData)((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[1U])) 
                                     << 0x00000020U) 
                                    | (QData)((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U])))) 
                                >> 0x00000020U)));
    __Vtemp_4[2U] = ((((vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[2U] 
                        << 0x0000001fU) | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[1U] 
                                           >> 1U)) 
                      + ((4U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U])
                          ? ((2U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U])
                              ? ((1U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U])
                                  ? 0U : (- vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__A))
                              : ((1U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U])
                                  ? (- vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__A)
                                  : VL_SHIFTL_III(32,32,32, 
                                                  (- vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__A), 1U)))
                          : ((2U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U])
                              ? ((1U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U])
                                  ? VL_SHIFTL_III(32,32,32, vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__A, 1U)
                                  : vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__A)
                              : ((1U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U])
                                  ? vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__A
                                  : 0U)))) >> 0x0000001fU);
    VL_SHIFTRS_WWI(65,65,32, __Vtemp_5, __Vtemp_4, 2U);
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P_next[0U] 
        = __Vtemp_5[0U];
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P_next[1U] 
        = __Vtemp_5[1U];
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P_next[2U] 
        = (1U & __Vtemp_5[2U]);
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__load_use_hazard = 0U;
    if (((vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
          >> 9U) & (0U != (0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
                                          >> 0x00000016U))))) {
        if ((((0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
                              >> 0x00000016U)) == (0x0000001fU 
                                                   & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U] 
                                                      >> 0x00000011U))) 
             | ((0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
                                >> 0x00000016U)) == 
                (0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U] 
                                >> 0x0000000cU))))) {
            vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__load_use_hazard = 1U;
        }
    }
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__forward_a = 0U;
    if ((((vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] 
           >> 3U) & (0U != (0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] 
                                           >> 4U)))) 
         & ((0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] 
                            >> 4U)) == (0x0000001fU 
                                        & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
                                           >> 0x00000011U))))) {
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__forward_a = 1U;
    } else if ((((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__wb_reg_we) 
                 & (0U != (0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__mem_wb_out[0U] 
                                          >> 3U)))) 
                & ((0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__mem_wb_out[0U] 
                                   >> 3U)) == (0x0000001fU 
                                               & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
                                                  >> 0x00000011U))))) {
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__forward_a = 2U;
    }
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__forward_b = 0U;
    if ((((vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] 
           >> 3U) & (0U != (0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] 
                                           >> 4U)))) 
         & ((0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] 
                            >> 4U)) == (0x0000001fU 
                                        & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
                                           >> 0x0000000cU))))) {
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__forward_b = 1U;
    } else if ((((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__wb_reg_we) 
                 & (0U != (0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__mem_wb_out[0U] 
                                          >> 3U)))) 
                & ((0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__mem_wb_out[0U] 
                                   >> 3U)) == (0x0000001fU 
                                               & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
                                                  >> 0x0000000cU))))) {
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__forward_b = 2U;
    }
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT____VdfgRegularize_h20fff292_0_0 
        = (IData)((3U == (3U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])));
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplicand 
        = ((1U == (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__forward_a))
            ? ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[2U] 
                << 0x00000017U) | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[1U] 
                                   >> 9U)) : ((2U == (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__forward_a))
                                               ? vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__wb_rd_data
                                               : ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[3U] 
                                                   << 5U) 
                                                  | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[2U] 
                                                     >> 0x0000001bU))));
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplier 
        = ((1U == (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__forward_b))
            ? ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[2U] 
                << 0x00000017U) | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[1U] 
                                   >> 9U)) : ((2U == (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__forward_b))
                                               ? vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__wb_rd_data
                                               : ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[2U] 
                                                   << 5U) 
                                                  | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[1U] 
                                                     >> 0x0000001bU))));
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__ex_stall 
        = ((2U != (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state)) 
           & (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT____VdfgRegularize_h20fff292_0_0));
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__alu_operand_b 
        = ((8U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
            ? ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[1U] 
                << 5U) | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
                          >> 0x0000001bU)) : vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplier);
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__branch_taken = 0U;
    if ((1U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])) {
        if ((0x00000800U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])) {
            vlSelfRef.riscv_coretb1__DOT__uut__DOT__branch_taken = 1U;
        } else if ((4U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])) {
            if ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplicand 
                 == vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__alu_operand_b)) {
                vlSelfRef.riscv_coretb1__DOT__uut__DOT__branch_taken = 1U;
            }
        }
    }
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_flush = 0U;
    if (vlSelfRef.riscv_coretb1__DOT__uut__DOT__branch_taken) {
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_flush = 1U;
    } else if (vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__load_use_hazard) {
        vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_flush = 1U;
    }
}

void Vriscv_coretb1___024root___nba_sequent__TOP__1(Vriscv_coretb1___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___nba_sequent__TOP__1\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__grant_mem 
        = ((0U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__state)) 
           & (IData)(vlSymsp->TOP__riscv_coretb1__DOT__data_bus.req_valid));
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__mem_stall 
        = ((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_mem__DOT__is_mem_op) 
           & (((~ (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__grant_mem)) 
               & (IData)(vlSymsp->TOP__riscv_coretb1__DOT__data_bus.req_valid)) 
              | ((~ (IData)(vlSymsp->TOP__riscv_coretb1__DOT__data_bus.rdata_valid)) 
                 & (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_mem__DOT__request_pending))));
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__backend_stall 
        = ((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__ex_stall) 
           | (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__mem_stall));
}

void Vriscv_coretb1___024root___nba_sequent__TOP__2(Vriscv_coretb1___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___nba_sequent__TOP__2\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__grant_if 
        = ((0U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__state)) 
           & ((~ (IData)(vlSymsp->TOP__riscv_coretb1__DOT__data_bus.req_valid)) 
              & (IData)(vlSymsp->TOP__riscv_coretb1__DOT__instr_bus.req_valid)));
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__if_stall 
        = (((~ (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__grant_if)) 
            & (IData)(vlSymsp->TOP__riscv_coretb1__DOT__instr_bus.req_valid)) 
           | ((~ (IData)(vlSymsp->TOP__riscv_coretb1__DOT__instr_bus.rdata_valid)) 
              & (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_if__DOT__request_pending)));
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__id_ex_stall 
        = ((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__if_stall) 
           | (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__backend_stall));
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__pc_stall 
        = ((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__id_ex_stall) 
           | (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__load_use_hazard));
}

void Vriscv_coretb1_cpu_bus_intf___nba_sequent__TOP__riscv_coretb1__DOT__bram_bus__0(Vriscv_coretb1_cpu_bus_intf* vlSelf);
void Vriscv_coretb1_cpu_bus_intf___nba_sequent__TOP__riscv_coretb1__DOT__instr_bus__0(Vriscv_coretb1_cpu_bus_intf* vlSelf);
void Vriscv_coretb1_cpu_bus_intf___nba_sequent__TOP__riscv_coretb1__DOT__data_bus__0(Vriscv_coretb1_cpu_bus_intf* vlSelf);
void Vriscv_coretb1_cpu_bus_intf___nba_sequent__TOP__riscv_coretb1__DOT__instr_bus__1(Vriscv_coretb1_cpu_bus_intf* vlSelf);

void Vriscv_coretb1___024root___eval_nba(Vriscv_coretb1___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___eval_nba\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VnbaTriggered[0U])) {
        Vriscv_coretb1___024root___nba_sequent__TOP__0(vlSelf);
        vlSelfRef.__Vm_traceActivity[1U] = 1U;
        Vriscv_coretb1_cpu_bus_intf___nba_sequent__TOP__riscv_coretb1__DOT__bram_bus__0((&vlSymsp->TOP__riscv_coretb1__DOT__bram_bus));
        Vriscv_coretb1_cpu_bus_intf___nba_sequent__TOP__riscv_coretb1__DOT__instr_bus__0((&vlSymsp->TOP__riscv_coretb1__DOT__instr_bus));
        Vriscv_coretb1_cpu_bus_intf___nba_sequent__TOP__riscv_coretb1__DOT__data_bus__0((&vlSymsp->TOP__riscv_coretb1__DOT__data_bus));
        Vriscv_coretb1___024root___nba_sequent__TOP__1(vlSelf);
        Vriscv_coretb1_cpu_bus_intf___nba_sequent__TOP__riscv_coretb1__DOT__instr_bus__1((&vlSymsp->TOP__riscv_coretb1__DOT__instr_bus));
        Vriscv_coretb1___024root___nba_sequent__TOP__2(vlSelf);
    }
}

void Vriscv_coretb1___024root___timing_resume(Vriscv_coretb1___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___timing_resume\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((2ULL & vlSelfRef.__VactTriggered[0U])) {
        vlSelfRef.__VdlySched.resume();
    }
}

void Vriscv_coretb1___024root___trigger_orInto__act_vec_vec(VlUnpacked<QData/*63:0*/, 1> &out, const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___trigger_orInto__act_vec_vec\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = (out[n] | in[n]);
        n = ((IData)(1U) + n);
    } while ((0U >= n));
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vriscv_coretb1___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG

bool Vriscv_coretb1___024root___eval_phase__act(Vriscv_coretb1___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___eval_phase__act\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VactExecute;
    // Body
    Vriscv_coretb1___024root___eval_triggers_vec__act(vlSelf);
    Vriscv_coretb1___024root___trigger_orInto__act_vec_vec(vlSelfRef.__VactTriggered, vlSelfRef.__VactTriggeredAcc);
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vriscv_coretb1___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
    }
#endif
    Vriscv_coretb1___024root___trigger_orInto__act_vec_vec(vlSelfRef.__VnbaTriggered, vlSelfRef.__VactTriggered);
    __VactExecute = Vriscv_coretb1___024root___trigger_anySet__act(vlSelfRef.__VactTriggered);
    if (__VactExecute) {
        vlSelfRef.__VactTriggeredAcc.fill(0ULL);
        Vriscv_coretb1___024root___timing_resume(vlSelf);
    }
    return (__VactExecute);
}

bool Vriscv_coretb1___024root___eval_phase__inact(Vriscv_coretb1___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___eval_phase__inact\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VinactExecute;
    // Body
    __VinactExecute = vlSelfRef.__VdlySched.awaitingZeroDelay();
    if (__VinactExecute) {
        VL_FATAL_MT("sim/riscv_coretb1.sv", 1, "", "ZERODLY: Design Verilated with '--no-sched-zero-delay', but #0 delay executed at runtime");
    }
    return (__VinactExecute);
}

void Vriscv_coretb1___024root___trigger_clear__act(VlUnpacked<QData/*63:0*/, 1> &out) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___trigger_clear__act\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = 0ULL;
        n = ((IData)(1U) + n);
    } while ((1U > n));
}

bool Vriscv_coretb1___024root___eval_phase__nba(Vriscv_coretb1___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___eval_phase__nba\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = Vriscv_coretb1___024root___trigger_anySet__act(vlSelfRef.__VnbaTriggered);
    if (__VnbaExecute) {
        Vriscv_coretb1___024root___eval_nba(vlSelf);
        Vriscv_coretb1___024root___trigger_clear__act(vlSelfRef.__VnbaTriggered);
    }
    return (__VnbaExecute);
}

void Vriscv_coretb1___024root___eval(Vriscv_coretb1___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___eval\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __VnbaIterCount;
    // Body
    __VnbaIterCount = 0U;
    do {
        if (VL_UNLIKELY(((0x00000064U < __VnbaIterCount)))) {
#ifdef VL_DEBUG
            Vriscv_coretb1___024root___dump_triggers__act(vlSelfRef.__VnbaTriggered, "nba"s);
#endif
            VL_FATAL_MT("sim/riscv_coretb1.sv", 1, "", "DIDNOTCONVERGE: NBA region did not converge after '--converge-limit' of 100 tries");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        vlSelfRef.__VinactIterCount = 0U;
        do {
            if (VL_UNLIKELY(((0x00000064U < vlSelfRef.__VinactIterCount)))) {
                VL_FATAL_MT("sim/riscv_coretb1.sv", 1, "", "DIDNOTCONVERGE: Inactive region did not converge after '--converge-limit' of 100 tries");
            }
            vlSelfRef.__VinactIterCount = ((IData)(1U) 
                                           + vlSelfRef.__VinactIterCount);
            vlSelfRef.__VactIterCount = 0U;
            do {
                if (VL_UNLIKELY(((0x00000064U < vlSelfRef.__VactIterCount)))) {
#ifdef VL_DEBUG
                    Vriscv_coretb1___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
#endif
                    VL_FATAL_MT("sim/riscv_coretb1.sv", 1, "", "DIDNOTCONVERGE: Active region did not converge after '--converge-limit' of 100 tries");
                }
                vlSelfRef.__VactIterCount = ((IData)(1U) 
                                             + vlSelfRef.__VactIterCount);
                vlSelfRef.__VactPhaseResult = Vriscv_coretb1___024root___eval_phase__act(vlSelf);
            } while (vlSelfRef.__VactPhaseResult);
            vlSelfRef.__VinactPhaseResult = Vriscv_coretb1___024root___eval_phase__inact(vlSelf);
        } while (vlSelfRef.__VinactPhaseResult);
        vlSelfRef.__VnbaPhaseResult = Vriscv_coretb1___024root___eval_phase__nba(vlSelf);
    } while (vlSelfRef.__VnbaPhaseResult);
}

#ifdef VL_DEBUG
void Vriscv_coretb1___024root___eval_debug_assertions(Vriscv_coretb1___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___eval_debug_assertions\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}
#endif  // VL_DEBUG
