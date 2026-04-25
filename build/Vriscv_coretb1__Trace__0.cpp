// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals

#include "verilated_vcd_c.h"
#include "Vriscv_coretb1__Syms.h"


void Vriscv_coretb1___024root__trace_chg_0_sub_0(Vriscv_coretb1___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vriscv_coretb1___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root__trace_chg_0\n"); );
    // Body
    Vriscv_coretb1___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vriscv_coretb1___024root*>(voidSelf);
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    Vriscv_coretb1___024root__trace_chg_0_sub_0((&vlSymsp->TOP), bufp);
}

void Vriscv_coretb1___024root__trace_chg_0_sub_0(Vriscv_coretb1___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root__trace_chg_0_sub_0\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    VlWide<3>/*95:0*/ __Vtemp_1;
    VlWide<3>/*95:0*/ __Vtemp_2;
    VlWide<3>/*95:0*/ __Vtemp_4;
    VlWide<3>/*95:0*/ __Vtemp_5;
    VlWide<3>/*95:0*/ __Vtemp_6;
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 0);
    if (VL_UNLIKELY((vlSelfRef.__Vm_traceActivity[1U]))) {
        bufp->chgCData(oldp+0,(vlSelfRef.riscv_coretb1__DOT__u_bram__DOT__state),2);
        bufp->chgIData(oldp+1,(vlSelfRef.riscv_coretb1__DOT__u_bram__DOT__saved_rdata),32);
        bufp->chgSData(oldp+2,((0x000003ffU & (vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_addr 
                                               >> 2U))),10);
        bufp->chgCData(oldp+3,(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__state),2);
        bufp->chgCData(oldp+4,(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_target),3);
        bufp->chgBit(oldp+5,(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__owner));
        bufp->chgIData(oldp+6,(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_addr),32);
        bufp->chgIData(oldp+7,(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_wdata),32);
        bufp->chgBit(oldp+8,(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_we));
        bufp->chgCData(oldp+9,(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_be),4);
        bufp->chgIData(oldp+10,(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__saved_rdata),32);
        bufp->chgBit(oldp+11,(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__p_valid));
        bufp->chgIData(oldp+12,(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__p_data),32);
        bufp->chgBit(oldp+13,(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__grant_mem));
        bufp->chgBit(oldp+14,(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__grant_if));
        bufp->chgBit(oldp+15,((1U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__state))));
        bufp->chgQData(oldp+16,((((QData)((IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__saved_rdata)) 
                                  << 1U) | (QData)((IData)(
                                                           ((~ (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__if_stall)) 
                                                            & (IData)(vlSymsp->TOP__riscv_coretb1__DOT__instr_bus.rdata_valid)))))),33);
        bufp->chgQData(oldp+18,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out),33);
        bufp->chgWData(oldp+20,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in),155);
        bufp->chgWData(oldp+25,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out),155);
        __Vtemp_1[0U] = (((IData)((((QData)((IData)(
                                                    ((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_active)
                                                      ? 
                                                     ((2U 
                                                       == (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state))
                                                       ? (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_result_64)
                                                       : 0U)
                                                      : 
                                                     ((1U 
                                                       & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                       ? 
                                                      ((0x00000080U 
                                                        & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                        ? 0U
                                                        : 
                                                       ((0x00000040U 
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
                                                       : 0U)))) 
                                    << 0x00000020U) 
                                   | (QData)((IData)(
                                                     ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[2U] 
                                                       << 5U) 
                                                      | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[1U] 
                                                         >> 0x0000001bU)))))) 
                          << 9U) | ((0x000001f0U & 
                                     (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
                                      >> 0x00000012U)) 
                                    | ((0x0000000eU 
                                        & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
                                           >> 7U)) 
                                       | (1U & ((~ (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__ex_stall)) 
                                                & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])))));
        __Vtemp_1[1U] = (((IData)((((QData)((IData)(
                                                    ((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_active)
                                                      ? 
                                                     ((2U 
                                                       == (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state))
                                                       ? (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_result_64)
                                                       : 0U)
                                                      : 
                                                     ((1U 
                                                       & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                       ? 
                                                      ((0x00000080U 
                                                        & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                        ? 0U
                                                        : 
                                                       ((0x00000040U 
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
                                                       : 0U)))) 
                                    << 0x00000020U) 
                                   | (QData)((IData)(
                                                     ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[2U] 
                                                       << 5U) 
                                                      | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[1U] 
                                                         >> 0x0000001bU)))))) 
                          >> 0x00000017U) | ((IData)(
                                                     ((((QData)((IData)(
                                                                        ((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_active)
                                                                          ? 
                                                                         ((2U 
                                                                           == (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state))
                                                                           ? (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_result_64)
                                                                           : 0U)
                                                                          : 
                                                                         ((1U 
                                                                           & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                                           ? 
                                                                          ((0x00000080U 
                                                                            & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                                            ? 0U
                                                                            : 
                                                                           ((0x00000040U 
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
                                                                           : 0U)))) 
                                                        << 0x00000020U) 
                                                       | (QData)((IData)(
                                                                         ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[2U] 
                                                                           << 5U) 
                                                                          | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[1U] 
                                                                             >> 0x0000001bU))))) 
                                                      >> 0x00000020U)) 
                                             << 9U));
        __Vtemp_1[2U] = ((IData)(((((QData)((IData)(
                                                    ((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_active)
                                                      ? 
                                                     ((2U 
                                                       == (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state))
                                                       ? (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_result_64)
                                                       : 0U)
                                                      : 
                                                     ((1U 
                                                       & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                       ? 
                                                      ((0x00000080U 
                                                        & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                        ? 0U
                                                        : 
                                                       ((0x00000040U 
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
                                                       : 0U)))) 
                                    << 0x00000020U) 
                                   | (QData)((IData)(
                                                     ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[2U] 
                                                       << 5U) 
                                                      | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[1U] 
                                                         >> 0x0000001bU))))) 
                                  >> 0x00000020U)) 
                         >> 0x00000017U);
        bufp->chgWData(oldp+30,(__Vtemp_1),73);
        bufp->chgWData(oldp+33,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out),73);
        __Vtemp_2[0U] = (((IData)((((QData)((IData)(
                                                    ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[2U] 
                                                      << 0x00000017U) 
                                                     | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[1U] 
                                                        >> 9U)))) 
                                    << 0x00000020U) 
                                   | (QData)((IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__saved_rdata)))) 
                          << 8U) | ((0x000000f8U & 
                                     (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] 
                                      >> 1U)) | ((6U 
                                                  & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] 
                                                     >> 1U)) 
                                                 | (1U 
                                                    & ((~ (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__mem_stall)) 
                                                       & vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U])))));
        __Vtemp_2[1U] = (((IData)((((QData)((IData)(
                                                    ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[2U] 
                                                      << 0x00000017U) 
                                                     | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[1U] 
                                                        >> 9U)))) 
                                    << 0x00000020U) 
                                   | (QData)((IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__saved_rdata)))) 
                          >> 0x00000018U) | ((IData)(
                                                     ((((QData)((IData)(
                                                                        ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[2U] 
                                                                          << 0x00000017U) 
                                                                         | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[1U] 
                                                                            >> 9U)))) 
                                                        << 0x00000020U) 
                                                       | (QData)((IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__saved_rdata))) 
                                                      >> 0x00000020U)) 
                                             << 8U));
        __Vtemp_2[2U] = ((IData)(((((QData)((IData)(
                                                    ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[2U] 
                                                      << 0x00000017U) 
                                                     | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[1U] 
                                                        >> 9U)))) 
                                    << 0x00000020U) 
                                   | (QData)((IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__saved_rdata))) 
                                  >> 0x00000020U)) 
                         >> 0x00000018U);
        bufp->chgWData(oldp+36,(__Vtemp_2),72);
        bufp->chgWData(oldp+39,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__mem_wb_out),72);
        bufp->chgIData(oldp+42,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__pc_current),32);
        bufp->chgBit(oldp+43,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__branch_taken));
        bufp->chgIData(oldp+44,(((1U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                  ? (((vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[4U] 
                                       << 5U) | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[3U] 
                                                 >> 0x0000001bU)) 
                                     + ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[1U] 
                                         << 5U) | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
                                                   >> 0x0000001bU)))
                                  : 0U)),32);
        bufp->chgBit(oldp+45,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__pc_stall));
        bufp->chgBit(oldp+46,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__id_ex_stall));
        bufp->chgBit(oldp+47,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__mem_stall));
        bufp->chgBit(oldp+48,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_flush));
        bufp->chgBit(oldp+49,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__if_stall));
        bufp->chgBit(oldp+50,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__ex_stall));
        bufp->chgCData(oldp+51,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__forward_a),2);
        bufp->chgCData(oldp+52,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__forward_b),2);
        bufp->chgBit(oldp+53,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__wb_reg_we));
        bufp->chgCData(oldp+54,((0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__mem_wb_out[0U] 
                                                >> 3U))),5);
        bufp->chgIData(oldp+55,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__wb_rd_data),32);
        bufp->chgBit(oldp+56,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__backend_stall));
        bufp->chgIData(oldp+57,(((vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[2U] 
                                  << 0x00000017U) | 
                                 (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[1U] 
                                  >> 9U))),32);
        bufp->chgIData(oldp+58,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplicand),32);
        bufp->chgIData(oldp+59,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplier),32);
        bufp->chgIData(oldp+60,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__alu_operand_b),32);
        bufp->chgIData(oldp+61,(((1U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                  ? ((0x00000080U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                      ? 0U : ((0x00000040U 
                                               & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                               ? ((0x00000020U 
                                                   & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                   ? 0U
                                                   : 
                                                  ((0x00000010U 
                                                    & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                    ? 0U
                                                    : 
                                                   (vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplicand 
                                                    ^ vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__alu_operand_b)))
                                               : ((0x00000020U 
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
                                  : 0U)),32);
        bufp->chgQData(oldp+62,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_result_64),64);
        bufp->chgIData(oldp+64,((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_result_64)),32);
        bufp->chgBit(oldp+65,((2U == (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state))));
        bufp->chgBit(oldp+66,(((~ (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_active)) 
                               & (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT____VdfgRegularize_h20fff292_0_0))));
        bufp->chgBit(oldp+67,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_active));
        bufp->chgCData(oldp+68,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state),2);
        bufp->chgCData(oldp+69,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__count),5);
        bufp->chgWData(oldp+70,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P),65);
        bufp->chgIData(oldp+73,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__A),32);
        bufp->chgIData(oldp+74,((- vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__A)),32);
        bufp->chgCData(oldp+75,((7U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U])),3);
        bufp->chgIData(oldp+76,(((4U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U])
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
                                          : 0U)))),32);
        __Vtemp_4[0U] = (IData)((0x00000001ffffffffULL 
                                 & (((QData)((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[1U])) 
                                     << 0x00000020U) 
                                    | (QData)((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U])))));
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
        __Vtemp_6[0U] = __Vtemp_5[0U];
        __Vtemp_6[1U] = __Vtemp_5[1U];
        __Vtemp_6[2U] = (1U & __Vtemp_5[2U]);
        bufp->chgWData(oldp+77,(__Vtemp_6),65);
        bufp->chgCData(oldp+80,((0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
                                                >> 0x00000011U))),5);
        bufp->chgCData(oldp+81,((0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
                                                >> 0x0000000cU))),5);
        bufp->chgBit(oldp+82,((1U & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] 
                                     >> 3U))));
        bufp->chgCData(oldp+83,((0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] 
                                                >> 4U))),5);
        bufp->chgBit(oldp+84,((1U & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
                                     >> 9U))));
        bufp->chgCData(oldp+85,((0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
                                                >> 0x00000016U))),5);
        bufp->chgCData(oldp+86,((0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U] 
                                                >> 0x00000011U))),5);
        bufp->chgCData(oldp+87,((0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U] 
                                                >> 0x0000000cU))),5);
        bufp->chgBit(oldp+88,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__load_use_hazard));
        bufp->chgCData(oldp+89,((0x0000007fU & (IData)(
                                                       (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                        >> 1U)))),7);
        bufp->chgCData(oldp+90,((7U & (IData)((vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                               >> 0x0000000dU)))),3);
        bufp->chgCData(oldp+91,((0x0000007fU & (IData)(
                                                       (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                        >> 0x0000001aU)))),7);
        bufp->chgCData(oldp+92,((0x0000001fU & (IData)(
                                                       (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                        >> 0x00000010U)))),5);
        bufp->chgCData(oldp+93,((0x0000001fU & (IData)(
                                                       (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                        >> 0x00000015U)))),5);
        bufp->chgCData(oldp+94,((0x0000001fU & (IData)(
                                                       (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                        >> 8U)))),5);
        bufp->chgIData(oldp+95,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__imm_ext),32);
        bufp->chgIData(oldp+96,(((0U == (0x0000001fU 
                                         & (IData)(
                                                   (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                    >> 0x00000010U))))
                                  ? 0U : vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers
                                 [(0x0000001fU & (IData)(
                                                         (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                          >> 0x00000010U)))])),32);
        bufp->chgIData(oldp+97,(((0U == (0x0000001fU 
                                         & (IData)(
                                                   (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                    >> 0x00000015U))))
                                  ? 0U : vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers
                                 [(0x0000001fU & (IData)(
                                                         (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                          >> 0x00000015U)))])),32);
        bufp->chgIData(oldp+98,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[0]),32);
        bufp->chgIData(oldp+99,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[1]),32);
        bufp->chgIData(oldp+100,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[2]),32);
        bufp->chgIData(oldp+101,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[3]),32);
        bufp->chgIData(oldp+102,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[4]),32);
        bufp->chgIData(oldp+103,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[5]),32);
        bufp->chgIData(oldp+104,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[6]),32);
        bufp->chgIData(oldp+105,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[7]),32);
        bufp->chgIData(oldp+106,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[8]),32);
        bufp->chgIData(oldp+107,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[9]),32);
        bufp->chgIData(oldp+108,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[10]),32);
        bufp->chgIData(oldp+109,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[11]),32);
        bufp->chgIData(oldp+110,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[12]),32);
        bufp->chgIData(oldp+111,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[13]),32);
        bufp->chgIData(oldp+112,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[14]),32);
        bufp->chgIData(oldp+113,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[15]),32);
        bufp->chgIData(oldp+114,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[16]),32);
        bufp->chgIData(oldp+115,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[17]),32);
        bufp->chgIData(oldp+116,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[18]),32);
        bufp->chgIData(oldp+117,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[19]),32);
        bufp->chgIData(oldp+118,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[20]),32);
        bufp->chgIData(oldp+119,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[21]),32);
        bufp->chgIData(oldp+120,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[22]),32);
        bufp->chgIData(oldp+121,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[23]),32);
        bufp->chgIData(oldp+122,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[24]),32);
        bufp->chgIData(oldp+123,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[25]),32);
        bufp->chgIData(oldp+124,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[26]),32);
        bufp->chgIData(oldp+125,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[27]),32);
        bufp->chgIData(oldp+126,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[28]),32);
        bufp->chgIData(oldp+127,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[29]),32);
        bufp->chgIData(oldp+128,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[30]),32);
        bufp->chgIData(oldp+129,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[31]),32);
        bufp->chgBit(oldp+130,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_if__DOT__request_pending));
        bufp->chgBit(oldp+131,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_mem__DOT__request_pending));
        bufp->chgBit(oldp+132,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_mem__DOT__is_mem_op));
        bufp->chgBit(oldp+133,(vlSymsp->TOP__riscv_coretb1__DOT__instr_bus.req_valid));
        bufp->chgBit(oldp+134,(vlSymsp->TOP__riscv_coretb1__DOT__instr_bus.rdata_valid));
        bufp->chgBit(oldp+135,((1U & (~ (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__if_stall)))));
        bufp->chgBit(oldp+136,(vlSymsp->TOP__riscv_coretb1__DOT__data_bus.req_valid));
        bufp->chgBit(oldp+137,((1U & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] 
                                      >> 1U))));
        bufp->chgIData(oldp+138,(((vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[1U] 
                                   << 0x00000017U) 
                                  | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] 
                                     >> 9U))),32);
        bufp->chgBit(oldp+139,(vlSymsp->TOP__riscv_coretb1__DOT__data_bus.rdata_valid));
        bufp->chgBit(oldp+140,((1U & (~ (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__mem_stall)))));
        bufp->chgBit(oldp+141,(((1U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__state)) 
                                & (1U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_target)))));
        bufp->chgBit(oldp+142,(((0U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_bram__DOT__state)) 
                                & ((1U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__state)) 
                                   & (1U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_target))))));
        bufp->chgBit(oldp+143,((1U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_bram__DOT__state))));
        bufp->chgBit(oldp+144,(((1U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__state)) 
                                & (2U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_target)))));
        bufp->chgBit(oldp+145,(((1U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__state)) 
                                & (3U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_target)))));
        bufp->chgBit(oldp+146,(((1U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__state)) 
                                & (4U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_target)))));
    }
    bufp->chgBit(oldp+147,(vlSelfRef.riscv_coretb1__DOT__clk));
    bufp->chgBit(oldp+148,(vlSelfRef.riscv_coretb1__DOT__rst));
}

void Vriscv_coretb1___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root__trace_cleanup\n"); );
    // Body
    Vriscv_coretb1___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vriscv_coretb1___024root*>(voidSelf);
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
}
