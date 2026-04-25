// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vriscv_coretb1.h for the primary calling header

#include "Vriscv_coretb1__pch.h"

void Vriscv_coretb1___024root___ctor_var_reset(Vriscv_coretb1___024root* vlSelf);

Vriscv_coretb1___024root::Vriscv_coretb1___024root(Vriscv_coretb1__Syms* symsp, const char* namep)
    : __VdlySched{*symsp->_vm_contextp__}
 {
    vlSymsp = symsp;
    vlNamep = strdup(namep);
    // Reset structure values
    Vriscv_coretb1___024root___ctor_var_reset(this);
}

void Vriscv_coretb1___024root::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vriscv_coretb1___024root::~Vriscv_coretb1___024root() {
    VL_DO_DANGLING(std::free(const_cast<char*>(vlNamep)), vlNamep);
}
