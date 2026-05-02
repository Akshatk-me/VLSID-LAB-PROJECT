// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vriscv_coretb1.h for the primary calling header

#include "Vriscv_coretb1__pch.h"

void Vriscv_coretb1_cpu_bus_intf___nba_sequent__TOP__riscv_coretb1__DOT__instr_bus__0(Vriscv_coretb1_cpu_bus_intf* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+            Vriscv_coretb1_cpu_bus_intf___nba_sequent__TOP__riscv_coretb1__DOT__instr_bus__0\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.rdata_valid = ((~ (IData)(vlSymsp->TOP.riscv_coretb1__DOT__u_interconnect__DOT__owner)) 
                             & (2U == (IData)(vlSymsp->TOP.riscv_coretb1__DOT__u_interconnect__DOT__state)));
}

void Vriscv_coretb1_cpu_bus_intf___nba_sequent__TOP__riscv_coretb1__DOT__instr_bus__1(Vriscv_coretb1_cpu_bus_intf* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+            Vriscv_coretb1_cpu_bus_intf___nba_sequent__TOP__riscv_coretb1__DOT__instr_bus__1\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.req_valid = (1U & (~ ((IData)(vlSymsp->TOP.riscv_coretb1__DOT__uut__DOT__u_if__DOT__request_pending) 
                                    | (IData)(vlSymsp->TOP.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__backend_stall))));
}

void Vriscv_coretb1_cpu_bus_intf___nba_sequent__TOP__riscv_coretb1__DOT__data_bus__0(Vriscv_coretb1_cpu_bus_intf* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+            Vriscv_coretb1_cpu_bus_intf___nba_sequent__TOP__riscv_coretb1__DOT__data_bus__0\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.rdata_valid = ((2U == (IData)(vlSymsp->TOP.riscv_coretb1__DOT__u_interconnect__DOT__state)) 
                             & (IData)(vlSymsp->TOP.riscv_coretb1__DOT__u_interconnect__DOT__owner));
    vlSelfRef.req_valid = ((IData)(vlSymsp->TOP.riscv_coretb1__DOT__uut__DOT__u_mem__DOT__is_mem_op) 
                           & (~ (IData)(vlSymsp->TOP.riscv_coretb1__DOT__uut__DOT__u_mem__DOT__request_pending)));
}

void Vriscv_coretb1_cpu_bus_intf___nba_sequent__TOP__riscv_coretb1__DOT__bram_bus__0(Vriscv_coretb1_cpu_bus_intf* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+            Vriscv_coretb1_cpu_bus_intf___nba_sequent__TOP__riscv_coretb1__DOT__bram_bus__0\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.req_valid = ((1U == (IData)(vlSymsp->TOP.riscv_coretb1__DOT__u_interconnect__DOT__state)) 
                           & (1U == (IData)(vlSymsp->TOP.riscv_coretb1__DOT__u_interconnect__DOT__latched_target)));
    vlSelfRef.grant = ((0U == (IData)(vlSymsp->TOP.riscv_coretb1__DOT__u_bram__DOT__state)) 
                       & (IData)(vlSelfRef.req_valid));
}

std::string VL_TO_STRING(const Vriscv_coretb1_cpu_bus_intf* obj) {
    VL_DEBUG_IF(VL_DBG_MSGF("+            Vriscv_coretb1_cpu_bus_intf::VL_TO_STRING\n"); );
    // Body
    return (obj ? obj->vlNamep : "null");
}
