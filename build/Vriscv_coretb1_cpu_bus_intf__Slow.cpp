// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vriscv_coretb1.h for the primary calling header

#include "Vriscv_coretb1__pch.h"

void Vriscv_coretb1_cpu_bus_intf___ctor_var_reset(Vriscv_coretb1_cpu_bus_intf* vlSelf);

Vriscv_coretb1_cpu_bus_intf::Vriscv_coretb1_cpu_bus_intf() = default;
Vriscv_coretb1_cpu_bus_intf::~Vriscv_coretb1_cpu_bus_intf() = default;

void Vriscv_coretb1_cpu_bus_intf::ctor(Vriscv_coretb1__Syms* symsp, const char* namep) {
    vlSymsp = symsp;
    vlNamep = strdup(Verilated::catName(vlSymsp->name(), namep));
    // Reset structure values
    Vriscv_coretb1_cpu_bus_intf___ctor_var_reset(this);
}

void Vriscv_coretb1_cpu_bus_intf::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

void Vriscv_coretb1_cpu_bus_intf::dtor() {
    VL_DO_DANGLING(std::free(const_cast<char*>(vlNamep)), vlNamep);
}
