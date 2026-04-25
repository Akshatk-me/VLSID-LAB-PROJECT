// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vriscv_coretb1__pch.h"

Vriscv_coretb1__Syms::Vriscv_coretb1__Syms(VerilatedContext* contextp, const char* namep, Vriscv_coretb1* modelp)
    : VerilatedSyms{contextp}
    // Setup internal state of the Syms class
    , __Vm_modelp{modelp}
    // Setup top module instance
    , TOP{this, namep}
{
    // Check resources
    Verilated::stackCheck(444);
    // Setup sub module instances
    TOP__riscv_coretb1__DOT__bram_bus.ctor(this, "riscv_coretb1.bram_bus");
    TOP__riscv_coretb1__DOT__data_bus.ctor(this, "riscv_coretb1.data_bus");
    TOP__riscv_coretb1__DOT__gpio_bus.ctor(this, "riscv_coretb1.gpio_bus");
    TOP__riscv_coretb1__DOT__instr_bus.ctor(this, "riscv_coretb1.instr_bus");
    TOP__riscv_coretb1__DOT__sha_bus.ctor(this, "riscv_coretb1.sha_bus");
    TOP__riscv_coretb1__DOT__uart_bus.ctor(this, "riscv_coretb1.uart_bus");
    // Configure time unit / time precision
    _vm_contextp__->timeunit(-12);
    _vm_contextp__->timeprecision(-12);
    // Setup each module's pointers to their submodules
    TOP.__PVT__riscv_coretb1__DOT__bram_bus = &TOP__riscv_coretb1__DOT__bram_bus;
    TOP.__PVT__riscv_coretb1__DOT__data_bus = &TOP__riscv_coretb1__DOT__data_bus;
    TOP.__PVT__riscv_coretb1__DOT__gpio_bus = &TOP__riscv_coretb1__DOT__gpio_bus;
    TOP.__PVT__riscv_coretb1__DOT__instr_bus = &TOP__riscv_coretb1__DOT__instr_bus;
    TOP.__PVT__riscv_coretb1__DOT__sha_bus = &TOP__riscv_coretb1__DOT__sha_bus;
    TOP.__PVT__riscv_coretb1__DOT__uart_bus = &TOP__riscv_coretb1__DOT__uart_bus;
    // Setup each module's pointer back to symbol table (for public functions)
    TOP.__Vconfigure(true);
    TOP__riscv_coretb1__DOT__bram_bus.__Vconfigure(true);
    TOP__riscv_coretb1__DOT__data_bus.__Vconfigure(false);
    TOP__riscv_coretb1__DOT__gpio_bus.__Vconfigure(false);
    TOP__riscv_coretb1__DOT__instr_bus.__Vconfigure(false);
    TOP__riscv_coretb1__DOT__sha_bus.__Vconfigure(false);
    TOP__riscv_coretb1__DOT__uart_bus.__Vconfigure(false);
    // Setup scopes
}

Vriscv_coretb1__Syms::~Vriscv_coretb1__Syms() {
    if (__Vm_dumping) _traceDumpClose();
    // Tear down scopes
    // Tear down sub module instances
    TOP__riscv_coretb1__DOT__uart_bus.dtor();
    TOP__riscv_coretb1__DOT__sha_bus.dtor();
    TOP__riscv_coretb1__DOT__instr_bus.dtor();
    TOP__riscv_coretb1__DOT__gpio_bus.dtor();
    TOP__riscv_coretb1__DOT__data_bus.dtor();
    TOP__riscv_coretb1__DOT__bram_bus.dtor();
}

void Vriscv_coretb1__Syms::_traceDump() {
    const VerilatedLockGuard lock{__Vm_dumperMutex};
    __Vm_dumperp->dump(VL_TIME_Q());
}

void Vriscv_coretb1__Syms::_traceDumpOpen() {
    const VerilatedLockGuard lock{__Vm_dumperMutex};
    if (VL_UNLIKELY(!__Vm_dumperp)) {
        __Vm_dumperp = new VerilatedVcdC();
        __Vm_modelp->trace(__Vm_dumperp, 0, 0);
        const std::string dumpfile = _vm_contextp__->dumpfileCheck();
        __Vm_dumperp->open(dumpfile.c_str());
        __Vm_dumping = true;
    }
}

void Vriscv_coretb1__Syms::_traceDumpClose() {
    const VerilatedLockGuard lock{__Vm_dumperMutex};
    __Vm_dumping = false;
    VL_DO_CLEAR(delete __Vm_dumperp, __Vm_dumperp = nullptr);
}
