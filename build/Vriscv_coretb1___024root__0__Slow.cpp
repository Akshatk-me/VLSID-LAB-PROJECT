// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vriscv_coretb1.h for the primary calling header

#include "Vriscv_coretb1__pch.h"

VL_ATTR_COLD void Vriscv_coretb1___024root___eval_static__TOP(Vriscv_coretb1___024root* vlSelf);

VL_ATTR_COLD void Vriscv_coretb1___024root___eval_static(Vriscv_coretb1___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___eval_static\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vriscv_coretb1___024root___eval_static__TOP(vlSelf);
    vlSelfRef.__Vtrigprevexpr___TOP__riscv_coretb1__DOT__clk__0 = 0U;
    do {
        vlSelfRef.__VactTriggeredAcc[vlSelfRef.__Vi] 
            = vlSelfRef.__VactTriggered[vlSelfRef.__Vi];
        vlSelfRef.__Vi = ((IData)(1U) + vlSelfRef.__Vi);
    } while ((0U >= vlSelfRef.__Vi));
}

VL_ATTR_COLD void Vriscv_coretb1___024root___eval_static__TOP(Vriscv_coretb1___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___eval_static__TOP\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.riscv_coretb1__DOT__clk = 0U;
    vlSelfRef.riscv_coretb1__DOT__rst = 1U;
}

VL_ATTR_COLD void Vriscv_coretb1___024root___eval_initial__TOP(Vriscv_coretb1___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___eval_initial__TOP\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSymsp->_vm_contextp__->dumpfile("waveform.vcd"s);
    vlSymsp->_traceDumpOpen();
    VL_WRITEF_NX("Starting VCD dump...\n",0);
    VL_READMEM_N(true, 32, 1024, 0, "program.hex"s,  &(vlSelfRef.riscv_coretb1__DOT__u_bram__DOT__mem)
                 , 0, ~0ULL);
}

VL_ATTR_COLD void Vriscv_coretb1___024root___eval_final(Vriscv_coretb1___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___eval_final\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vriscv_coretb1___024root___dump_triggers__stl(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vriscv_coretb1___024root___eval_phase__stl(Vriscv_coretb1___024root* vlSelf);

VL_ATTR_COLD void Vriscv_coretb1___024root___eval_settle(Vriscv_coretb1___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___eval_settle\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __VstlIterCount;
    // Body
    __VstlIterCount = 0U;
    vlSelfRef.__VstlFirstIteration = 1U;
    do {
        if (VL_UNLIKELY(((0x00000064U < __VstlIterCount)))) {
#ifdef VL_DEBUG
            Vriscv_coretb1___024root___dump_triggers__stl(vlSelfRef.__VstlTriggered, "stl"s);
#endif
            VL_FATAL_MT("sim/riscv_coretb1.sv", 1, "", "DIDNOTCONVERGE: Settle region did not converge after '--converge-limit' of 100 tries");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        vlSelfRef.__VstlPhaseResult = Vriscv_coretb1___024root___eval_phase__stl(vlSelf);
        vlSelfRef.__VstlFirstIteration = 0U;
    } while (vlSelfRef.__VstlPhaseResult);
}

VL_ATTR_COLD void Vriscv_coretb1___024root___eval_triggers_vec__stl(Vriscv_coretb1___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___eval_triggers_vec__stl\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VstlTriggered[0U] = ((0xfffffffffffffffeULL 
                                      & vlSelfRef.__VstlTriggered[0U]) 
                                     | (IData)((IData)(vlSelfRef.__VstlFirstIteration)));
}

VL_ATTR_COLD bool Vriscv_coretb1___024root___trigger_anySet__stl(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vriscv_coretb1___024root___dump_triggers__stl(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(Vriscv_coretb1___024root___trigger_anySet__stl(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD bool Vriscv_coretb1___024root___trigger_anySet__stl(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___trigger_anySet__stl\n"); );
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

VL_ATTR_COLD void Vriscv_coretb1___024root___stl_sequent__TOP__0(Vriscv_coretb1___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___stl_sequent__TOP__0\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    VlWide<3>/*95:0*/ __Vtemp_2;
    VlWide<3>/*95:0*/ __Vtemp_3;
    // Body
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
    __Vtemp_2[0U] = (IData)((0x00000001ffffffffULL 
                             & (((QData)((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[1U])) 
                                 << 0x00000020U) | (QData)((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U])))));
    __Vtemp_2[1U] = (((((vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[2U] 
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
    __Vtemp_2[2U] = ((((vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[2U] 
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
    VL_SHIFTRS_WWI(65,65,32, __Vtemp_3, __Vtemp_2, 2U);
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P_next[0U] 
        = __Vtemp_3[0U];
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P_next[1U] 
        = __Vtemp_3[1U];
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P_next[2U] 
        = (1U & __Vtemp_3[2U]);
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
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT____VdfgRegularize_h20fff292_0_0 
        = (IData)((3U == (3U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])));
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_mem__DOT__is_mem_op 
        = (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] 
           & (0U != (6U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U])));
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
    vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__ex_stall 
        = ((2U != (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state)) 
           & (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT____VdfgRegularize_h20fff292_0_0));
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

VL_ATTR_COLD void Vriscv_coretb1___024root____Vm_traceActivitySetAll(Vriscv_coretb1___024root* vlSelf);
void Vriscv_coretb1_cpu_bus_intf___nba_sequent__TOP__riscv_coretb1__DOT__bram_bus__0(Vriscv_coretb1_cpu_bus_intf* vlSelf);
void Vriscv_coretb1_cpu_bus_intf___nba_sequent__TOP__riscv_coretb1__DOT__instr_bus__0(Vriscv_coretb1_cpu_bus_intf* vlSelf);
void Vriscv_coretb1_cpu_bus_intf___nba_sequent__TOP__riscv_coretb1__DOT__data_bus__0(Vriscv_coretb1_cpu_bus_intf* vlSelf);
void Vriscv_coretb1___024root___nba_sequent__TOP__1(Vriscv_coretb1___024root* vlSelf);
void Vriscv_coretb1_cpu_bus_intf___nba_sequent__TOP__riscv_coretb1__DOT__instr_bus__1(Vriscv_coretb1_cpu_bus_intf* vlSelf);
void Vriscv_coretb1___024root___nba_sequent__TOP__2(Vriscv_coretb1___024root* vlSelf);

VL_ATTR_COLD void Vriscv_coretb1___024root___eval_stl(Vriscv_coretb1___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___eval_stl\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VstlTriggered[0U])) {
        Vriscv_coretb1___024root___stl_sequent__TOP__0(vlSelf);
        Vriscv_coretb1___024root____Vm_traceActivitySetAll(vlSelf);
        Vriscv_coretb1_cpu_bus_intf___nba_sequent__TOP__riscv_coretb1__DOT__bram_bus__0((&vlSymsp->TOP__riscv_coretb1__DOT__bram_bus));
        Vriscv_coretb1_cpu_bus_intf___nba_sequent__TOP__riscv_coretb1__DOT__instr_bus__0((&vlSymsp->TOP__riscv_coretb1__DOT__instr_bus));
        Vriscv_coretb1_cpu_bus_intf___nba_sequent__TOP__riscv_coretb1__DOT__data_bus__0((&vlSymsp->TOP__riscv_coretb1__DOT__data_bus));
        Vriscv_coretb1___024root___nba_sequent__TOP__1(vlSelf);
        Vriscv_coretb1_cpu_bus_intf___nba_sequent__TOP__riscv_coretb1__DOT__instr_bus__1((&vlSymsp->TOP__riscv_coretb1__DOT__instr_bus));
        Vriscv_coretb1___024root___nba_sequent__TOP__2(vlSelf);
    }
}

VL_ATTR_COLD bool Vriscv_coretb1___024root___eval_phase__stl(Vriscv_coretb1___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___eval_phase__stl\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VstlExecute;
    // Body
    Vriscv_coretb1___024root___eval_triggers_vec__stl(vlSelf);
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vriscv_coretb1___024root___dump_triggers__stl(vlSelfRef.__VstlTriggered, "stl"s);
    }
#endif
    __VstlExecute = Vriscv_coretb1___024root___trigger_anySet__stl(vlSelfRef.__VstlTriggered);
    if (__VstlExecute) {
        Vriscv_coretb1___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

bool Vriscv_coretb1___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vriscv_coretb1___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(Vriscv_coretb1___024root___trigger_anySet__act(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: @(posedge riscv_coretb1.clk)\n");
    }
    if ((1U & (IData)((triggers[0U] >> 1U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 1 is active: @([true] __VdlySched.awaitingCurrentTime())\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vriscv_coretb1___024root____Vm_traceActivitySetAll(Vriscv_coretb1___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root____Vm_traceActivitySetAll\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vm_traceActivity[0U] = 1U;
    vlSelfRef.__Vm_traceActivity[1U] = 1U;
}

VL_ATTR_COLD void Vriscv_coretb1___024root___ctor_var_reset(Vriscv_coretb1___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root___ctor_var_reset\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->vlNamep);
    vlSelf->riscv_coretb1__DOT__uut__DOT__if_id_out = VL_SCOPED_RAND_RESET_Q(33, __VscopeHash, 334983151194322556ull);
    VL_SCOPED_RAND_RESET_W(155, vlSelf->riscv_coretb1__DOT__uut__DOT__id_ex_in, __VscopeHash, 11719634739684104522ull);
    VL_SCOPED_RAND_RESET_W(155, vlSelf->riscv_coretb1__DOT__uut__DOT__id_ex_out, __VscopeHash, 7238961462148254587ull);
    VL_SCOPED_RAND_RESET_W(73, vlSelf->riscv_coretb1__DOT__uut__DOT__ex_mem_out, __VscopeHash, 10955286179905084691ull);
    VL_SCOPED_RAND_RESET_W(72, vlSelf->riscv_coretb1__DOT__uut__DOT__mem_wb_out, __VscopeHash, 2534057554622435091ull);
    vlSelf->riscv_coretb1__DOT__uut__DOT__pc_current = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 17231582764907243978ull);
    vlSelf->riscv_coretb1__DOT__uut__DOT__pc_next = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 714259155969322206ull);
    vlSelf->riscv_coretb1__DOT__uut__DOT__branch_taken = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 3030198533580998483ull);
    vlSelf->riscv_coretb1__DOT__uut__DOT__id_ex_flush = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 10303470968673599527ull);
    vlSelf->riscv_coretb1__DOT__uut__DOT__forward_a = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 12842843624530248645ull);
    vlSelf->riscv_coretb1__DOT__uut__DOT__forward_b = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 17912300145716692734ull);
    vlSelf->riscv_coretb1__DOT__uut__DOT__u_if__DOT__request_pending = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 18192045957996977444ull);
    vlSelf->riscv_coretb1__DOT__uut__DOT__u_id__DOT__wb_reg_we = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 12659590321052157050ull);
    vlSelf->riscv_coretb1__DOT__uut__DOT__u_id__DOT__wb_rd_data = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 4488932293369301063ull);
    vlSelf->riscv_coretb1__DOT__uut__DOT__u_id__DOT__imm_ext = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 18034322475142157832ull);
    for (int __Vi0 = 0; __Vi0 < 32; ++__Vi0) {
        vlSelf->riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[__Vi0] = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 10156052827120895860ull);
    }
    vlSelf->riscv_coretb1__DOT__uut__DOT__u_ex__DOT__alu_operand_b = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 7179830122485783197ull);
    vlSelf->riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_result_64 = VL_SCOPED_RAND_RESET_Q(64, __VscopeHash, 4153743673002278884ull);
    vlSelf->riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_active = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 1175175824081212008ull);
    vlSelf->riscv_coretb1__DOT__uut__DOT__u_ex__DOT____VdfgRegularize_h20fff292_0_0 = 0;
    vlSelf->riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplicand = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 3200420337705466250ull);
    vlSelf->riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplier = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 3255081833054570669ull);
    vlSelf->riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 14282429477138675501ull);
    vlSelf->riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__count = VL_SCOPED_RAND_RESET_I(5, __VscopeHash, 17503533863054824229ull);
    VL_SCOPED_RAND_RESET_W(65, vlSelf->riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P, __VscopeHash, 17489584356829440829ull);
    vlSelf->riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__A = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 7026815410646782272ull);
    VL_SCOPED_RAND_RESET_W(65, vlSelf->riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P_next, __VscopeHash, 5733276149547538052ull);
    vlSelf->riscv_coretb1__DOT__uut__DOT__u_mem__DOT__request_pending = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 5915570361449587198ull);
    vlSelf->riscv_coretb1__DOT__uut__DOT__u_mem__DOT__is_mem_op = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 10618311630737743330ull);
    vlSelf->riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__if_stall = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 15743749846180116279ull);
    vlSelf->riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__ex_stall = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 1853838828200604382ull);
    vlSelf->riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__mem_stall = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 10410471294159409246ull);
    vlSelf->riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__pc_stall = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 13288605502455005842ull);
    vlSelf->riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__id_ex_stall = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 6176537609200462345ull);
    vlSelf->riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__backend_stall = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 7625217026810328761ull);
    vlSelf->riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__load_use_hazard = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 13966792586276137906ull);
    vlSelf->riscv_coretb1__DOT__u_interconnect__DOT__state = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 4250360790629905610ull);
    vlSelf->riscv_coretb1__DOT__u_interconnect__DOT__latched_target = VL_SCOPED_RAND_RESET_I(3, __VscopeHash, 17651659894026325025ull);
    vlSelf->riscv_coretb1__DOT__u_interconnect__DOT__owner = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 4229523977235300488ull);
    vlSelf->riscv_coretb1__DOT__u_interconnect__DOT__latched_addr = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 12003602558860212335ull);
    vlSelf->riscv_coretb1__DOT__u_interconnect__DOT__latched_wdata = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 15683842947295346006ull);
    vlSelf->riscv_coretb1__DOT__u_interconnect__DOT__latched_we = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 4083876550394466380ull);
    vlSelf->riscv_coretb1__DOT__u_interconnect__DOT__latched_be = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 9534723403007169375ull);
    vlSelf->riscv_coretb1__DOT__u_interconnect__DOT__saved_rdata = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 1724932053159599553ull);
    vlSelf->riscv_coretb1__DOT__u_interconnect__DOT__p_valid = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 1901091735872165123ull);
    vlSelf->riscv_coretb1__DOT__u_interconnect__DOT__p_data = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 3989598151022181502ull);
    vlSelf->riscv_coretb1__DOT__u_interconnect__DOT__grant_mem = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 2323548590915255241ull);
    vlSelf->riscv_coretb1__DOT__u_interconnect__DOT__grant_if = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 16742007733240729408ull);
    for (int __Vi0 = 0; __Vi0 < 1024; ++__Vi0) {
        vlSelf->riscv_coretb1__DOT__u_bram__DOT__mem[__Vi0] = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 6753035293355554686ull);
    }
    vlSelf->riscv_coretb1__DOT__u_bram__DOT__state = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 6602919715814081808ull);
    vlSelf->riscv_coretb1__DOT__u_bram__DOT__saved_rdata = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 11792952834525078355ull);
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VstlTriggered[__Vi0] = 0;
    }
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VactTriggered[__Vi0] = 0;
    }
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VactTriggeredAcc[__Vi0] = 0;
    }
    vlSelf->__Vtrigprevexpr___TOP__riscv_coretb1__DOT__clk__0 = 0;
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VnbaTriggered[__Vi0] = 0;
    }
    vlSelf->__Vi = 0;
    for (int __Vi0 = 0; __Vi0 < 2; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = 0;
    }
}
