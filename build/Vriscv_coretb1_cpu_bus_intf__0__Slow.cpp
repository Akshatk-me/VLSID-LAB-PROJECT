// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vriscv_coretb1.h for the primary calling header

#include "Vriscv_coretb1__pch.h"

VL_ATTR_COLD void Vriscv_coretb1_cpu_bus_intf___ctor_var_reset(Vriscv_coretb1_cpu_bus_intf* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+            Vriscv_coretb1_cpu_bus_intf___ctor_var_reset\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->vlNamep);
    vlSelf->req_valid = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 12465084953323796564ull);
    vlSelf->grant = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 741988092961692266ull);
    vlSelf->rdata = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 10065165116613087284ull);
    vlSelf->rdata_valid = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 1482607620371764411ull);
    vlSelf->ready = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 898948264233693212ull);
}
