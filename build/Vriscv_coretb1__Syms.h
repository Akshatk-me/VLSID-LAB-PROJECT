// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VRISCV_CORETB1__SYMS_H_
#define VERILATED_VRISCV_CORETB1__SYMS_H_  // guard

#include "verilated.h"
#include "verilated_vcd_c.h"

// INCLUDE MODEL CLASS

#include "Vriscv_coretb1.h"

// INCLUDE MODULE CLASSES
#include "Vriscv_coretb1___024root.h"
#include "Vriscv_coretb1_cpu_bus_intf.h"

// SYMS CLASS (contains all model state)
class alignas(VL_CACHE_LINE_BYTES) Vriscv_coretb1__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vriscv_coretb1* const __Vm_modelp;
    bool __Vm_dumping = false;  // Dumping is active
    VerilatedMutex __Vm_dumperMutex;  // Protect __Vm_dumperp
    VerilatedVcdC* __Vm_dumperp VL_GUARDED_BY(__Vm_dumperMutex) = nullptr;  /// Trace class for $dump*
    bool __Vm_activity = false;  ///< Used by trace routines to determine change occurred
    uint32_t __Vm_baseCode = 0;  ///< Used by trace routines when tracing multiple models
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vriscv_coretb1___024root       TOP;
    Vriscv_coretb1_cpu_bus_intf    TOP__riscv_coretb1__DOT__bram_bus;
    Vriscv_coretb1_cpu_bus_intf    TOP__riscv_coretb1__DOT__data_bus;
    Vriscv_coretb1_cpu_bus_intf    TOP__riscv_coretb1__DOT__gpio_bus;
    Vriscv_coretb1_cpu_bus_intf    TOP__riscv_coretb1__DOT__instr_bus;
    Vriscv_coretb1_cpu_bus_intf    TOP__riscv_coretb1__DOT__sha_bus;
    Vriscv_coretb1_cpu_bus_intf    TOP__riscv_coretb1__DOT__uart_bus;

    // CONSTRUCTORS
    Vriscv_coretb1__Syms(VerilatedContext* contextp, const char* namep, Vriscv_coretb1* modelp);
    ~Vriscv_coretb1__Syms();

    // METHODS
    const char* name() const { return TOP.vlNamep; }
    void _traceDump();
    void _traceDumpOpen();
    void _traceDumpClose();
};

#endif  // guard
