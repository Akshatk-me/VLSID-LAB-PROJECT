// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vriscv_coretb1__pch.h"
#include "verilated_vcd_c.h"

//============================================================
// Constructors

Vriscv_coretb1::Vriscv_coretb1(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vriscv_coretb1__Syms(contextp(), _vcname__, this)}
    , __PVT__riscv_coretb1__DOT__instr_bus{vlSymsp->TOP.__PVT__riscv_coretb1__DOT__instr_bus}
    , __PVT__riscv_coretb1__DOT__data_bus{vlSymsp->TOP.__PVT__riscv_coretb1__DOT__data_bus}
    , __PVT__riscv_coretb1__DOT__bram_bus{vlSymsp->TOP.__PVT__riscv_coretb1__DOT__bram_bus}
    , __PVT__riscv_coretb1__DOT__uart_bus{vlSymsp->TOP.__PVT__riscv_coretb1__DOT__uart_bus}
    , __PVT__riscv_coretb1__DOT__sha_bus{vlSymsp->TOP.__PVT__riscv_coretb1__DOT__sha_bus}
    , __PVT__riscv_coretb1__DOT__gpio_bus{vlSymsp->TOP.__PVT__riscv_coretb1__DOT__gpio_bus}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
    contextp()->traceBaseModelCbAdd(
        [this](VerilatedTraceBaseC* tfp, int levels, int options) { traceBaseModel(tfp, levels, options); });
}

Vriscv_coretb1::Vriscv_coretb1(const char* _vcname__)
    : Vriscv_coretb1(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vriscv_coretb1::~Vriscv_coretb1() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vriscv_coretb1___024root___eval_debug_assertions(Vriscv_coretb1___024root* vlSelf);
#endif  // VL_DEBUG
void Vriscv_coretb1___024root___eval_static(Vriscv_coretb1___024root* vlSelf);
void Vriscv_coretb1___024root___eval_initial(Vriscv_coretb1___024root* vlSelf);
void Vriscv_coretb1___024root___eval_settle(Vriscv_coretb1___024root* vlSelf);
void Vriscv_coretb1___024root___eval(Vriscv_coretb1___024root* vlSelf);

void Vriscv_coretb1::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vriscv_coretb1::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vriscv_coretb1___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_activity = true;
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vriscv_coretb1___024root___eval_static(&(vlSymsp->TOP));
        Vriscv_coretb1___024root___eval_initial(&(vlSymsp->TOP));
        Vriscv_coretb1___024root___eval_settle(&(vlSymsp->TOP));
        vlSymsp->__Vm_didInit = true;
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vriscv_coretb1___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

void Vriscv_coretb1::eval_end_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+eval_end_step Vriscv_coretb1::eval_end_step\n"); );
#ifdef VM_TRACE
    // Tracing
    if (VL_UNLIKELY(vlSymsp->__Vm_dumping)) vlSymsp->_traceDump();
#endif  // VM_TRACE
}

//============================================================
// Events and timing
bool Vriscv_coretb1::eventsPending() { return !vlSymsp->TOP.__VdlySched.empty() && !contextp()->gotFinish(); }

uint64_t Vriscv_coretb1::nextTimeSlot() { return vlSymsp->TOP.__VdlySched.nextTimeSlot(); }

//============================================================
// Utilities

const char* Vriscv_coretb1::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vriscv_coretb1___024root___eval_final(Vriscv_coretb1___024root* vlSelf);

VL_ATTR_COLD void Vriscv_coretb1::final() {
    Vriscv_coretb1___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vriscv_coretb1::hierName() const { return vlSymsp->name(); }
const char* Vriscv_coretb1::modelName() const { return "Vriscv_coretb1"; }
unsigned Vriscv_coretb1::threads() const { return 1; }
void Vriscv_coretb1::prepareClone() const { contextp()->prepareClone(); }
void Vriscv_coretb1::atClone() const {
    contextp()->threadPoolpOnClone();
}
std::unique_ptr<VerilatedTraceConfig> Vriscv_coretb1::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false, false, false}};
};

//============================================================
// Trace configuration

void Vriscv_coretb1___024root__trace_decl_types(VerilatedVcd* tracep);

void Vriscv_coretb1___024root__trace_init_top(Vriscv_coretb1___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vriscv_coretb1___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vriscv_coretb1___024root*>(voidSelf);
    Vriscv_coretb1__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->pushPrefix(vlSymsp->name(), VerilatedTracePrefixType::SCOPE_MODULE);
    Vriscv_coretb1___024root__trace_decl_types(tracep);
    Vriscv_coretb1___024root__trace_init_top(vlSelf, tracep);
    tracep->popPrefix();
}

VL_ATTR_COLD void Vriscv_coretb1___024root__trace_register(Vriscv_coretb1___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void Vriscv_coretb1::traceBaseModel(VerilatedTraceBaseC* tfp, int levels, int options) {
    (void)levels; (void)options;
    VerilatedVcdC* const stfp = dynamic_cast<VerilatedVcdC*>(tfp);
    if (VL_UNLIKELY(!stfp)) {
        vl_fatal(__FILE__, __LINE__, __FILE__,"'Vriscv_coretb1::trace()' called on non-VerilatedVcdC object;"
            " use --trace-fst with VerilatedFst object, and --trace-vcd with VerilatedVcd object");
    }
    stfp->spTrace()->addModel(this);
    stfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->TOP), name(), false, 167);
    Vriscv_coretb1___024root__trace_register(&(vlSymsp->TOP), stfp->spTrace());
}
