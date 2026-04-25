// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals

#include "verilated_vcd_c.h"
#include "Vriscv_coretb1__Syms.h"


VL_ATTR_COLD void Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__bram_bus__0(Vriscv_coretb1___024root* vlSelf, VerilatedVcd* tracep);
VL_ATTR_COLD void Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__data_bus__0(Vriscv_coretb1___024root* vlSelf, VerilatedVcd* tracep);
VL_ATTR_COLD void Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__gpio_bus__0(Vriscv_coretb1___024root* vlSelf, VerilatedVcd* tracep);
VL_ATTR_COLD void Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__instr_bus__0(Vriscv_coretb1___024root* vlSelf, VerilatedVcd* tracep);
VL_ATTR_COLD void Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__sha_bus__0(Vriscv_coretb1___024root* vlSelf, VerilatedVcd* tracep);
VL_ATTR_COLD void Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__uart_bus__0(Vriscv_coretb1___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void Vriscv_coretb1___024root__trace_init_sub__TOP__0(Vriscv_coretb1___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root__trace_init_sub__TOP__0\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const int c = vlSymsp->__Vm_baseCode;
    tracep->pushPrefix("riscv_coretb1", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+147,0,"clk",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+148,0,"rst",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->pushPrefix("bram_bus", VerilatedTracePrefixType::SCOPE_INTERFACE);
    Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__bram_bus__0(vlSelf, tracep);
    tracep->popPrefix();
    tracep->pushPrefix("data_bus", VerilatedTracePrefixType::SCOPE_INTERFACE);
    Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__data_bus__0(vlSelf, tracep);
    tracep->popPrefix();
    tracep->pushPrefix("gpio_bus", VerilatedTracePrefixType::SCOPE_INTERFACE);
    Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__gpio_bus__0(vlSelf, tracep);
    tracep->popPrefix();
    tracep->pushPrefix("instr_bus", VerilatedTracePrefixType::SCOPE_INTERFACE);
    Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__instr_bus__0(vlSelf, tracep);
    tracep->popPrefix();
    tracep->pushPrefix("sha_bus", VerilatedTracePrefixType::SCOPE_INTERFACE);
    Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__sha_bus__0(vlSelf, tracep);
    tracep->popPrefix();
    tracep->pushPrefix("u_bram", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+149,0,"DEPTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::INT, false,-1, 31,0);
    tracep->declBit(c+147,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+148,0,"rst",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+0,0,"state",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+1,0,"saved_rdata",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+2,0,"word_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 9,0);
    tracep->pushPrefix("bus", VerilatedTracePrefixType::SCOPE_INTERFACE);
    Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__bram_bus__0(vlSelf, tracep);
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->pushPrefix("u_interconnect", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+147,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+148,0,"rst",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+3,0,"state",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+4,0,"latched_target",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBit(c+5,0,"owner",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+6,0,"latched_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+7,0,"latched_wdata",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+8,0,"latched_we",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+9,0,"latched_be",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+10,0,"saved_rdata",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+11,0,"p_valid",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+12,0,"p_data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+13,0,"grant_mem",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+14,0,"grant_if",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+15,0,"is_waiting",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->pushPrefix("bram_bus", VerilatedTracePrefixType::SCOPE_INTERFACE);
    Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__bram_bus__0(vlSelf, tracep);
    tracep->popPrefix();
    tracep->pushPrefix("data_bus", VerilatedTracePrefixType::SCOPE_INTERFACE);
    Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__data_bus__0(vlSelf, tracep);
    tracep->popPrefix();
    tracep->pushPrefix("gpio_bus", VerilatedTracePrefixType::SCOPE_INTERFACE);
    Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__gpio_bus__0(vlSelf, tracep);
    tracep->popPrefix();
    tracep->pushPrefix("instr_bus", VerilatedTracePrefixType::SCOPE_INTERFACE);
    Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__instr_bus__0(vlSelf, tracep);
    tracep->popPrefix();
    tracep->pushPrefix("sha_bus", VerilatedTracePrefixType::SCOPE_INTERFACE);
    Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__sha_bus__0(vlSelf, tracep);
    tracep->popPrefix();
    tracep->pushPrefix("uart_bus", VerilatedTracePrefixType::SCOPE_INTERFACE);
    Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__uart_bus__0(vlSelf, tracep);
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->pushPrefix("uart_bus", VerilatedTracePrefixType::SCOPE_INTERFACE);
    Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__uart_bus__0(vlSelf, tracep);
    tracep->popPrefix();
    tracep->pushPrefix("uut", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+147,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+148,0,"rst",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declQuad(c+16,0,"if_id_in",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 32,0);
    tracep->declQuad(c+18,0,"if_id_out",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 32,0);
    tracep->declArray(c+20,0,"id_ex_in",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 154,0);
    tracep->declArray(c+25,0,"id_ex_out",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 154,0);
    tracep->declArray(c+30,0,"ex_mem_in",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 72,0);
    tracep->declArray(c+33,0,"ex_mem_out",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 72,0);
    tracep->declArray(c+36,0,"mem_wb_in",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 71,0);
    tracep->declArray(c+39,0,"mem_wb_out",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 71,0);
    tracep->declBus(c+42,0,"pc_current",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+150,0,"pc_next",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+43,0,"branch_taken",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+44,0,"branch_target",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+45,0,"pc_stall",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+45,0,"if_id_stall",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+46,0,"id_ex_stall",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+47,0,"ex_mem_stall",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+151,0,"mem_wb_stall",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+43,0,"if_id_flush",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+48,0,"id_ex_flush",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+151,0,"ex_mem_flush",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+151,0,"mem_wb_flush",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+49,0,"if_stall",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+50,0,"ex_stall",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+47,0,"mem_stall",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+51,0,"forward_a",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+52,0,"forward_b",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBit(c+53,0,"wb_reg_we",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+54,0,"wb_rd_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+55,0,"wb_rd_data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+56,0,"backend_stall",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->pushPrefix("data_bus", VerilatedTracePrefixType::SCOPE_INTERFACE);
    Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__data_bus__0(vlSelf, tracep);
    tracep->popPrefix();
    tracep->pushPrefix("instr_bus", VerilatedTracePrefixType::SCOPE_INTERFACE);
    Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__instr_bus__0(vlSelf, tracep);
    tracep->popPrefix();
    tracep->pushPrefix("reg_ex_mem", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+147,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+148,0,"rst",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+47,0,"stall",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+151,0,"flush",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declArray(c+30,0,"data_in",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 72,0);
    tracep->declArray(c+33,0,"data_out",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 72,0);
    tracep->popPrefix();
    tracep->pushPrefix("reg_id_ex", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+147,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+148,0,"rst",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+46,0,"stall",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+48,0,"flush",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declArray(c+20,0,"data_in",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 154,0);
    tracep->declArray(c+25,0,"data_out",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 154,0);
    tracep->popPrefix();
    tracep->pushPrefix("reg_if_id", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+147,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+148,0,"rst",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+45,0,"stall",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+43,0,"flush",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declQuad(c+16,0,"data_in",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 32,0);
    tracep->declQuad(c+18,0,"data_out",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 32,0);
    tracep->popPrefix();
    tracep->pushPrefix("reg_mem_wb", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+147,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+148,0,"rst",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+151,0,"stall",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+151,0,"flush",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declArray(c+36,0,"data_in",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 71,0);
    tracep->declArray(c+39,0,"data_out",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 71,0);
    tracep->popPrefix();
    tracep->pushPrefix("u_ex", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+147,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+148,0,"rst",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declArray(c+25,0,"id_ex_in",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 154,0);
    tracep->declBit(c+50,0,"ex_stall",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+43,0,"branch_taken",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+44,0,"branch_target",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declArray(c+30,0,"ex_mem_out",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 72,0);
    tracep->declBus(c+51,0,"forward_a",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+52,0,"forward_b",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+57,0,"forwarded_mem_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+55,0,"forwarded_wb_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+58,0,"forwarded_rs1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+59,0,"forwarded_rs2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+58,0,"alu_operand_a",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+60,0,"alu_operand_b",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+61,0,"alu_result",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declQuad(c+62,0,"mul_result_64",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBus(c+64,0,"mul_result",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+65,0,"mul_done",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+66,0,"start_mul",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+67,0,"mul_active",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->pushPrefix("u_mul", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+147,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+148,0,"rst",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+66,0,"start",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+58,0,"multiplicand",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+59,0,"multiplier",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declQuad(c+62,0,"result_64",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBit(c+65,0,"done",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+68,0,"state",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+69,0,"count",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declArray(c+70,0,"P",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 64,0);
    tracep->declBus(c+73,0,"A",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+74,0,"neg_A",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+75,0,"booth_window",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBus(c+76,0,"add_val",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declArray(c+77,0,"P_next",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 64,0);
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->pushPrefix("u_forward", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+80,0,"id_ex_rs1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+81,0,"id_ex_rs2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBit(c+82,0,"ex_mem_reg_we",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+83,0,"ex_mem_rd",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBit(c+53,0,"mem_wb_reg_we",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+54,0,"mem_wb_rd",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+51,0,"forward_a",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+52,0,"forward_b",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->popPrefix();
    tracep->pushPrefix("u_hazard", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+49,0,"if_stall",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+50,0,"ex_stall",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+47,0,"mem_stall",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+84,0,"id_ex_mem_re",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+85,0,"id_ex_rd",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+86,0,"if_id_rs1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+87,0,"if_id_rs2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBit(c+43,0,"branch_taken",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+45,0,"pc_stall",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+45,0,"if_id_stall",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+46,0,"id_ex_stall",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+47,0,"ex_mem_stall",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+151,0,"mem_wb_stall",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+56,0,"backend_stall",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+43,0,"if_id_flush",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+48,0,"id_ex_flush",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+151,0,"ex_mem_flush",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+151,0,"mem_wb_flush",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+88,0,"load_use_hazard",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+46,0,"global_stall",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->popPrefix();
    tracep->pushPrefix("u_id", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+147,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+148,0,"rst",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declQuad(c+18,0,"if_id_in",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 32,0);
    tracep->declBit(c+53,0,"wb_reg_we",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+54,0,"wb_rd_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+55,0,"wb_rd_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declArray(c+20,0,"id_ex_out",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 154,0);
    tracep->declBus(c+89,0,"opcode",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+90,0,"funct3",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBus(c+91,0,"funct7",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+92,0,"rs1_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+93,0,"rs2_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+94,0,"rd_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+95,0,"imm_ext",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+96,0,"rs1_data_out",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+97,0,"rs2_data_out",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->pushPrefix("u_reg_file", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+147,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+148,0,"rst",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+92,0,"rs1_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+96,0,"rs1_data",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+93,0,"rs2_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+97,0,"rs2_data",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+53,0,"reg_we",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+54,0,"rd_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+55,0,"rd_data",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->pushPrefix("registers", VerilatedTracePrefixType::ARRAY_UNPACKED);
    for (int i = 0; i < 32; ++i) {
        tracep->declBus(c+98+i*1,0,"",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, true,(i+0), 31,0);
    }
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->pushPrefix("u_if", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+147,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+148,0,"rst",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+42,0,"pc",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+56,0,"if_id_stall",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declQuad(c+16,0,"if_id_out",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 32,0);
    tracep->declBit(c+49,0,"if_stall",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+130,0,"request_pending",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->pushPrefix("bus", VerilatedTracePrefixType::SCOPE_INTERFACE);
    Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__instr_bus__0(vlSelf, tracep);
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->pushPrefix("u_mem", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBit(c+147,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+148,0,"rst",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declArray(c+33,0,"ex_mem_in",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 72,0);
    tracep->declBit(c+151,0,"mem_wb_stall",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declArray(c+36,0,"mem_wb_out",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 71,0);
    tracep->declBit(c+47,0,"mem_stall",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+131,0,"request_pending",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+132,0,"is_mem_op",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->pushPrefix("bus", VerilatedTracePrefixType::SCOPE_INTERFACE);
    Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__data_bus__0(vlSelf, tracep);
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->pushPrefix("u_wb", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declArray(c+39,0,"mem_wb_in",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 71,0);
    tracep->declBit(c+53,0,"wb_reg_we",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+54,0,"wb_rd_addr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+55,0,"wb_rd_data",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->popPrefix();
}

VL_ATTR_COLD void Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__instr_bus__0(Vriscv_coretb1___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__instr_bus__0\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const int c = vlSymsp->__Vm_baseCode;
    tracep->declBit(c+133,0,"req_valid",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+14,0,"grant",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+42,0,"addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+151,0,"we",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+152,0,"be",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+153,0,"wdata",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+10,0,"rdata",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+134,0,"rdata_valid",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+135,0,"ready",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
}

VL_ATTR_COLD void Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__data_bus__0(Vriscv_coretb1___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__data_bus__0\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const int c = vlSymsp->__Vm_baseCode;
    tracep->declBit(c+136,0,"req_valid",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+13,0,"grant",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+57,0,"addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+137,0,"we",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+152,0,"be",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+138,0,"wdata",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+10,0,"rdata",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+139,0,"rdata_valid",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+140,0,"ready",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
}

VL_ATTR_COLD void Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__bram_bus__0(Vriscv_coretb1___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__bram_bus__0\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const int c = vlSymsp->__Vm_baseCode;
    tracep->declBit(c+141,0,"req_valid",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+142,0,"grant",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+6,0,"addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+8,0,"we",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+9,0,"be",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+7,0,"wdata",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+1,0,"rdata",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+143,0,"rdata_valid",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+154,0,"ready",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
}

VL_ATTR_COLD void Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__uart_bus__0(Vriscv_coretb1___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__uart_bus__0\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const int c = vlSymsp->__Vm_baseCode;
    tracep->declBit(c+144,0,"req_valid",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+155,0,"grant",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+6,0,"addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+8,0,"we",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+9,0,"be",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+7,0,"wdata",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+156,0,"rdata",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+157,0,"rdata_valid",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+158,0,"ready",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
}

VL_ATTR_COLD void Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__sha_bus__0(Vriscv_coretb1___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__sha_bus__0\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const int c = vlSymsp->__Vm_baseCode;
    tracep->declBit(c+145,0,"req_valid",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+159,0,"grant",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+6,0,"addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+8,0,"we",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+9,0,"be",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+7,0,"wdata",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+160,0,"rdata",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+161,0,"rdata_valid",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+162,0,"ready",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
}

VL_ATTR_COLD void Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__gpio_bus__0(Vriscv_coretb1___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root__trace_init_sub__TOP__riscv_coretb1__DOT__gpio_bus__0\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const int c = vlSymsp->__Vm_baseCode;
    tracep->declBit(c+146,0,"req_valid",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+163,0,"grant",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+6,0,"addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+8,0,"we",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+9,0,"be",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+7,0,"wdata",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+164,0,"rdata",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+165,0,"rdata_valid",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+166,0,"ready",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
}

VL_ATTR_COLD void Vriscv_coretb1___024root__trace_init_top(Vriscv_coretb1___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root__trace_init_top\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vriscv_coretb1___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vriscv_coretb1___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
VL_ATTR_COLD void Vriscv_coretb1___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vriscv_coretb1___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vriscv_coretb1___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vriscv_coretb1___024root__trace_register(Vriscv_coretb1___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root__trace_register\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    tracep->addConstCb(&Vriscv_coretb1___024root__trace_const_0, 0, vlSelf);
    tracep->addFullCb(&Vriscv_coretb1___024root__trace_full_0, 0, vlSelf);
    tracep->addChgCb(&Vriscv_coretb1___024root__trace_chg_0, 0, vlSelf);
    tracep->addCleanupCb(&Vriscv_coretb1___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vriscv_coretb1___024root__trace_const_0_sub_0(Vriscv_coretb1___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vriscv_coretb1___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root__trace_const_0\n"); );
    // Body
    Vriscv_coretb1___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vriscv_coretb1___024root*>(voidSelf);
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    Vriscv_coretb1___024root__trace_const_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vriscv_coretb1___024root__trace_const_0_sub_0(Vriscv_coretb1___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root__trace_const_0_sub_0\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    bufp->fullIData(oldp+149,(0x00000400U),32);
    bufp->fullIData(oldp+150,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__pc_next),32);
    bufp->fullBit(oldp+151,(0U));
    bufp->fullCData(oldp+152,(0x0fU),4);
    bufp->fullIData(oldp+153,(0U),32);
    bufp->fullBit(oldp+154,(vlSymsp->TOP__riscv_coretb1__DOT__bram_bus.ready));
    bufp->fullBit(oldp+155,(vlSymsp->TOP__riscv_coretb1__DOT__uart_bus.grant));
    bufp->fullIData(oldp+156,(vlSymsp->TOP__riscv_coretb1__DOT__uart_bus.rdata),32);
    bufp->fullBit(oldp+157,(vlSymsp->TOP__riscv_coretb1__DOT__uart_bus.rdata_valid));
    bufp->fullBit(oldp+158,(vlSymsp->TOP__riscv_coretb1__DOT__uart_bus.ready));
    bufp->fullBit(oldp+159,(vlSymsp->TOP__riscv_coretb1__DOT__sha_bus.grant));
    bufp->fullIData(oldp+160,(vlSymsp->TOP__riscv_coretb1__DOT__sha_bus.rdata),32);
    bufp->fullBit(oldp+161,(vlSymsp->TOP__riscv_coretb1__DOT__sha_bus.rdata_valid));
    bufp->fullBit(oldp+162,(vlSymsp->TOP__riscv_coretb1__DOT__sha_bus.ready));
    bufp->fullBit(oldp+163,(vlSymsp->TOP__riscv_coretb1__DOT__gpio_bus.grant));
    bufp->fullIData(oldp+164,(vlSymsp->TOP__riscv_coretb1__DOT__gpio_bus.rdata),32);
    bufp->fullBit(oldp+165,(vlSymsp->TOP__riscv_coretb1__DOT__gpio_bus.rdata_valid));
    bufp->fullBit(oldp+166,(vlSymsp->TOP__riscv_coretb1__DOT__gpio_bus.ready));
}

VL_ATTR_COLD void Vriscv_coretb1___024root__trace_full_0_sub_0(Vriscv_coretb1___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vriscv_coretb1___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root__trace_full_0\n"); );
    // Body
    Vriscv_coretb1___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vriscv_coretb1___024root*>(voidSelf);
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    Vriscv_coretb1___024root__trace_full_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vriscv_coretb1___024root__trace_full_0_sub_0(Vriscv_coretb1___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vriscv_coretb1___024root__trace_full_0_sub_0\n"); );
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    VlWide<3>/*95:0*/ __Vtemp_1;
    VlWide<3>/*95:0*/ __Vtemp_2;
    VlWide<3>/*95:0*/ __Vtemp_4;
    VlWide<3>/*95:0*/ __Vtemp_5;
    VlWide<3>/*95:0*/ __Vtemp_6;
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    bufp->fullCData(oldp+0,(vlSelfRef.riscv_coretb1__DOT__u_bram__DOT__state),2);
    bufp->fullIData(oldp+1,(vlSelfRef.riscv_coretb1__DOT__u_bram__DOT__saved_rdata),32);
    bufp->fullSData(oldp+2,((0x000003ffU & (vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_addr 
                                            >> 2U))),10);
    bufp->fullCData(oldp+3,(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__state),2);
    bufp->fullCData(oldp+4,(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_target),3);
    bufp->fullBit(oldp+5,(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__owner));
    bufp->fullIData(oldp+6,(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_addr),32);
    bufp->fullIData(oldp+7,(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_wdata),32);
    bufp->fullBit(oldp+8,(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_we));
    bufp->fullCData(oldp+9,(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_be),4);
    bufp->fullIData(oldp+10,(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__saved_rdata),32);
    bufp->fullBit(oldp+11,(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__p_valid));
    bufp->fullIData(oldp+12,(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__p_data),32);
    bufp->fullBit(oldp+13,(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__grant_mem));
    bufp->fullBit(oldp+14,(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__grant_if));
    bufp->fullBit(oldp+15,((1U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__state))));
    bufp->fullQData(oldp+16,((((QData)((IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__saved_rdata)) 
                               << 1U) | (QData)((IData)(
                                                        ((~ (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__if_stall)) 
                                                         & (IData)(vlSymsp->TOP__riscv_coretb1__DOT__instr_bus.rdata_valid)))))),33);
    bufp->fullQData(oldp+18,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out),33);
    bufp->fullWData(oldp+20,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in),155);
    bufp->fullWData(oldp+25,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out),155);
    __Vtemp_1[0U] = (((IData)((((QData)((IData)(((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_active)
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
                                << 0x00000020U) | (QData)((IData)(
                                                                  ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[2U] 
                                                                    << 5U) 
                                                                   | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[1U] 
                                                                      >> 0x0000001bU)))))) 
                      << 9U) | ((0x000001f0U & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
                                                >> 0x00000012U)) 
                                | ((0x0000000eU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
                                                   >> 7U)) 
                                   | (1U & ((~ (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__ex_stall)) 
                                            & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])))));
    __Vtemp_1[1U] = (((IData)((((QData)((IData)(((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_active)
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
                                << 0x00000020U) | (QData)((IData)(
                                                                  ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[2U] 
                                                                    << 5U) 
                                                                   | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[1U] 
                                                                      >> 0x0000001bU)))))) 
                      >> 0x00000017U) | ((IData)(((
                                                   ((QData)((IData)(
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
    __Vtemp_1[2U] = ((IData)(((((QData)((IData)(((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_active)
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
                                << 0x00000020U) | (QData)((IData)(
                                                                  ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[2U] 
                                                                    << 5U) 
                                                                   | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[1U] 
                                                                      >> 0x0000001bU))))) 
                              >> 0x00000020U)) >> 0x00000017U);
    bufp->fullWData(oldp+30,(__Vtemp_1),73);
    bufp->fullWData(oldp+33,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out),73);
    __Vtemp_2[0U] = (((IData)((((QData)((IData)(((vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[2U] 
                                                  << 0x00000017U) 
                                                 | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[1U] 
                                                    >> 9U)))) 
                                << 0x00000020U) | (QData)((IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__saved_rdata)))) 
                      << 8U) | ((0x000000f8U & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] 
                                                >> 1U)) 
                                | ((6U & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] 
                                          >> 1U)) | 
                                   (1U & ((~ (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__mem_stall)) 
                                          & vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U])))));
    __Vtemp_2[1U] = (((IData)((((QData)((IData)(((vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[2U] 
                                                  << 0x00000017U) 
                                                 | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[1U] 
                                                    >> 9U)))) 
                                << 0x00000020U) | (QData)((IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__saved_rdata)))) 
                      >> 0x00000018U) | ((IData)(((
                                                   ((QData)((IData)(
                                                                    ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[2U] 
                                                                      << 0x00000017U) 
                                                                     | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[1U] 
                                                                        >> 9U)))) 
                                                    << 0x00000020U) 
                                                   | (QData)((IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__saved_rdata))) 
                                                  >> 0x00000020U)) 
                                         << 8U));
    __Vtemp_2[2U] = ((IData)(((((QData)((IData)(((vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[2U] 
                                                  << 0x00000017U) 
                                                 | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[1U] 
                                                    >> 9U)))) 
                                << 0x00000020U) | (QData)((IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__saved_rdata))) 
                              >> 0x00000020U)) >> 0x00000018U);
    bufp->fullWData(oldp+36,(__Vtemp_2),72);
    bufp->fullWData(oldp+39,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__mem_wb_out),72);
    bufp->fullIData(oldp+42,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__pc_current),32);
    bufp->fullBit(oldp+43,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__branch_taken));
    bufp->fullIData(oldp+44,(((1U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                               ? (((vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[4U] 
                                    << 5U) | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[3U] 
                                              >> 0x0000001bU)) 
                                  + ((vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[1U] 
                                      << 5U) | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
                                                >> 0x0000001bU)))
                               : 0U)),32);
    bufp->fullBit(oldp+45,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__pc_stall));
    bufp->fullBit(oldp+46,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__id_ex_stall));
    bufp->fullBit(oldp+47,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__mem_stall));
    bufp->fullBit(oldp+48,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_flush));
    bufp->fullBit(oldp+49,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__if_stall));
    bufp->fullBit(oldp+50,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__ex_stall));
    bufp->fullCData(oldp+51,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__forward_a),2);
    bufp->fullCData(oldp+52,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__forward_b),2);
    bufp->fullBit(oldp+53,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__wb_reg_we));
    bufp->fullCData(oldp+54,((0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__mem_wb_out[0U] 
                                             >> 3U))),5);
    bufp->fullIData(oldp+55,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__wb_rd_data),32);
    bufp->fullBit(oldp+56,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__backend_stall));
    bufp->fullIData(oldp+57,(((vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[2U] 
                               << 0x00000017U) | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[1U] 
                                                  >> 9U))),32);
    bufp->fullIData(oldp+58,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplicand),32);
    bufp->fullIData(oldp+59,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplier),32);
    bufp->fullIData(oldp+60,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__alu_operand_b),32);
    bufp->fullIData(oldp+61,(((1U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                               ? ((0x00000080U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                   ? 0U : ((0x00000040U 
                                            & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                            ? ((0x00000020U 
                                                & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                ? 0U
                                                : (
                                                   (0x00000010U 
                                                    & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                    ? 0U
                                                    : 
                                                   (vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplicand 
                                                    ^ vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__alu_operand_b)))
                                            : ((0x00000020U 
                                                & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                ? (
                                                   (0x00000010U 
                                                    & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                    ? 
                                                   (vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplicand 
                                                    | vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__alu_operand_b)
                                                    : 
                                                   (vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplicand 
                                                    & vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__alu_operand_b))
                                                : (
                                                   (0x00000010U 
                                                    & vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U])
                                                    ? 
                                                   (vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplicand 
                                                    - vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__alu_operand_b)
                                                    : 
                                                   (vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__multiplicand 
                                                    + vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__alu_operand_b)))))
                               : 0U)),32);
    bufp->fullQData(oldp+62,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_result_64),64);
    bufp->fullIData(oldp+64,((IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_result_64)),32);
    bufp->fullBit(oldp+65,((2U == (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state))));
    bufp->fullBit(oldp+66,(((~ (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_active)) 
                            & (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT____VdfgRegularize_h20fff292_0_0))));
    bufp->fullBit(oldp+67,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__mul_active));
    bufp->fullCData(oldp+68,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__state),2);
    bufp->fullCData(oldp+69,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__count),5);
    bufp->fullWData(oldp+70,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P),65);
    bufp->fullIData(oldp+73,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__A),32);
    bufp->fullIData(oldp+74,((- vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__A)),32);
    bufp->fullCData(oldp+75,((7U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U])),3);
    bufp->fullIData(oldp+76,(((4U & vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_ex__DOT__u_mul__DOT__P[0U])
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
    __Vtemp_6[0U] = __Vtemp_5[0U];
    __Vtemp_6[1U] = __Vtemp_5[1U];
    __Vtemp_6[2U] = (1U & __Vtemp_5[2U]);
    bufp->fullWData(oldp+77,(__Vtemp_6),65);
    bufp->fullCData(oldp+80,((0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
                                             >> 0x00000011U))),5);
    bufp->fullCData(oldp+81,((0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
                                             >> 0x0000000cU))),5);
    bufp->fullBit(oldp+82,((1U & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] 
                                  >> 3U))));
    bufp->fullCData(oldp+83,((0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] 
                                             >> 4U))),5);
    bufp->fullBit(oldp+84,((1U & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
                                  >> 9U))));
    bufp->fullCData(oldp+85,((0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_out[0U] 
                                             >> 0x00000016U))),5);
    bufp->fullCData(oldp+86,((0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U] 
                                             >> 0x00000011U))),5);
    bufp->fullCData(oldp+87,((0x0000001fU & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__id_ex_in[0U] 
                                             >> 0x0000000cU))),5);
    bufp->fullBit(oldp+88,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__load_use_hazard));
    bufp->fullCData(oldp+89,((0x0000007fU & (IData)(
                                                    (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                     >> 1U)))),7);
    bufp->fullCData(oldp+90,((7U & (IData)((vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                            >> 0x0000000dU)))),3);
    bufp->fullCData(oldp+91,((0x0000007fU & (IData)(
                                                    (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                     >> 0x0000001aU)))),7);
    bufp->fullCData(oldp+92,((0x0000001fU & (IData)(
                                                    (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                     >> 0x00000010U)))),5);
    bufp->fullCData(oldp+93,((0x0000001fU & (IData)(
                                                    (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                     >> 0x00000015U)))),5);
    bufp->fullCData(oldp+94,((0x0000001fU & (IData)(
                                                    (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                     >> 8U)))),5);
    bufp->fullIData(oldp+95,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__imm_ext),32);
    bufp->fullIData(oldp+96,(((0U == (0x0000001fU & (IData)(
                                                            (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                             >> 0x00000010U))))
                               ? 0U : vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers
                              [(0x0000001fU & (IData)(
                                                      (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                       >> 0x00000010U)))])),32);
    bufp->fullIData(oldp+97,(((0U == (0x0000001fU & (IData)(
                                                            (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                             >> 0x00000015U))))
                               ? 0U : vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers
                              [(0x0000001fU & (IData)(
                                                      (vlSelfRef.riscv_coretb1__DOT__uut__DOT__if_id_out 
                                                       >> 0x00000015U)))])),32);
    bufp->fullIData(oldp+98,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[0]),32);
    bufp->fullIData(oldp+99,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[1]),32);
    bufp->fullIData(oldp+100,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[2]),32);
    bufp->fullIData(oldp+101,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[3]),32);
    bufp->fullIData(oldp+102,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[4]),32);
    bufp->fullIData(oldp+103,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[5]),32);
    bufp->fullIData(oldp+104,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[6]),32);
    bufp->fullIData(oldp+105,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[7]),32);
    bufp->fullIData(oldp+106,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[8]),32);
    bufp->fullIData(oldp+107,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[9]),32);
    bufp->fullIData(oldp+108,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[10]),32);
    bufp->fullIData(oldp+109,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[11]),32);
    bufp->fullIData(oldp+110,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[12]),32);
    bufp->fullIData(oldp+111,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[13]),32);
    bufp->fullIData(oldp+112,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[14]),32);
    bufp->fullIData(oldp+113,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[15]),32);
    bufp->fullIData(oldp+114,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[16]),32);
    bufp->fullIData(oldp+115,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[17]),32);
    bufp->fullIData(oldp+116,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[18]),32);
    bufp->fullIData(oldp+117,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[19]),32);
    bufp->fullIData(oldp+118,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[20]),32);
    bufp->fullIData(oldp+119,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[21]),32);
    bufp->fullIData(oldp+120,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[22]),32);
    bufp->fullIData(oldp+121,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[23]),32);
    bufp->fullIData(oldp+122,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[24]),32);
    bufp->fullIData(oldp+123,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[25]),32);
    bufp->fullIData(oldp+124,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[26]),32);
    bufp->fullIData(oldp+125,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[27]),32);
    bufp->fullIData(oldp+126,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[28]),32);
    bufp->fullIData(oldp+127,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[29]),32);
    bufp->fullIData(oldp+128,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[30]),32);
    bufp->fullIData(oldp+129,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_id__DOT__u_reg_file__DOT__registers[31]),32);
    bufp->fullBit(oldp+130,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_if__DOT__request_pending));
    bufp->fullBit(oldp+131,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_mem__DOT__request_pending));
    bufp->fullBit(oldp+132,(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_mem__DOT__is_mem_op));
    bufp->fullBit(oldp+133,(vlSymsp->TOP__riscv_coretb1__DOT__instr_bus.req_valid));
    bufp->fullBit(oldp+134,(vlSymsp->TOP__riscv_coretb1__DOT__instr_bus.rdata_valid));
    bufp->fullBit(oldp+135,((1U & (~ (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__if_stall)))));
    bufp->fullBit(oldp+136,(vlSymsp->TOP__riscv_coretb1__DOT__data_bus.req_valid));
    bufp->fullBit(oldp+137,((1U & (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] 
                                   >> 1U))));
    bufp->fullIData(oldp+138,(((vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[1U] 
                                << 0x00000017U) | (vlSelfRef.riscv_coretb1__DOT__uut__DOT__ex_mem_out[0U] 
                                                   >> 9U))),32);
    bufp->fullBit(oldp+139,(vlSymsp->TOP__riscv_coretb1__DOT__data_bus.rdata_valid));
    bufp->fullBit(oldp+140,((1U & (~ (IData)(vlSelfRef.riscv_coretb1__DOT__uut__DOT__u_hazard__DOT__mem_stall)))));
    bufp->fullBit(oldp+141,(((1U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__state)) 
                             & (1U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_target)))));
    bufp->fullBit(oldp+142,(((0U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_bram__DOT__state)) 
                             & ((1U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__state)) 
                                & (1U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_target))))));
    bufp->fullBit(oldp+143,((1U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_bram__DOT__state))));
    bufp->fullBit(oldp+144,(((1U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__state)) 
                             & (2U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_target)))));
    bufp->fullBit(oldp+145,(((1U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__state)) 
                             & (3U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_target)))));
    bufp->fullBit(oldp+146,(((1U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__state)) 
                             & (4U == (IData)(vlSelfRef.riscv_coretb1__DOT__u_interconnect__DOT__latched_target)))));
    bufp->fullBit(oldp+147,(vlSelfRef.riscv_coretb1__DOT__clk));
    bufp->fullBit(oldp+148,(vlSelfRef.riscv_coretb1__DOT__rst));
}
