// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vriscv_coretb1.h for the primary calling header

#ifndef VERILATED_VRISCV_CORETB1_CPU_BUS_INTF_H_
#define VERILATED_VRISCV_CORETB1_CPU_BUS_INTF_H_  // guard

#include "verilated.h"
#include "verilated_timing.h"


class Vriscv_coretb1__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vriscv_coretb1_cpu_bus_intf final {
  public:

    // DESIGN SPECIFIC STATE
    CData/*0:0*/ req_valid;
    CData/*0:0*/ grant;
    CData/*0:0*/ rdata_valid;
    IData/*31:0*/ rdata;

    // INTERNAL VARIABLES
    Vriscv_coretb1__Syms* vlSymsp;
    const char* vlNamep;

    // CONSTRUCTORS
    Vriscv_coretb1_cpu_bus_intf();
    ~Vriscv_coretb1_cpu_bus_intf();
    void ctor(Vriscv_coretb1__Syms* symsp, const char* namep);
    void dtor();
    VL_UNCOPYABLE(Vriscv_coretb1_cpu_bus_intf);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};

std::string VL_TO_STRING(const Vriscv_coretb1_cpu_bus_intf* obj);

#endif  // guard
