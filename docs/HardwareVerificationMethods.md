## Overview

Once simulation passes, FPGA designs must be verified on actual hardware. On the PYNQ-Z2 board we mainly use three verification methods:

1. **Integrated Logic Analyzer (ILA)**
2. **Memory-Mapped I/O (MMIO) via UART**
3. **GPIO Debugging (LEDs & Buttons)**

Each method provides a different level of visibility into the system.

| Method    | Visibility                  | Use Case                   |
| --------- | --------------------------- | -------------------------- |
| ILA       | Internal signals            | Debugging logic and timing |
| UART/MMIO | Software–hardware interface | Functional system testing  |
| GPIO      | Physical indicators         | Quick sanity checks        |

---

# 1. Integrated Logic Analyzer (ILA)

## What it is

The **Integrated Logic Analyzer** is a debug core synthesized into the FPGA fabric that captures internal signals in real time. It works similarly to a logic analyzer or oscilloscope but observes signals **inside the FPGA**.

Captured signals are transmitted to the host PC through **JTAG** and viewed in **Vivado Hardware Manager**.

---

## How it is used

Signals are marked in Verilog:

```verilog
(* mark_debug = "true" *) wire sha_done;
(* mark_debug = "true" *) reg [31:0] pc;
```

During synthesis Vivado allows attaching these signals to an **ILA core**.

Typical workflow:

1. Synthesize design
2. Configure ILA probes
3. Program FPGA
4. Open Vivado Hardware Manager
5. Trigger waveform capture

Example trigger:

```
sha_done == 1
```

The ILA then records several hundred cycles before and after the event.

---

## When to use ILA

ILA is best for **low-level hardware debugging**.

Typical use cases:

**Module debugging**

Example signals:

```
fsm_state
counter
valid
ready
done
```

**Pipeline debugging**

Example signals:

```
pc
instruction
stall
flush
```

**Bus debugging**

Example signals:

```
mem_valid
mem_ready
mem_addr
```

**Accelerator debugging**

Example signals:

```
sha_start
sha_busy
sha_done
```

ILA allows observing **cycle-accurate behavior**, which is impossible with UART or LEDs.

---

## Limitations

* Consumes FPGA resources (BRAM, LUTs)
* Slightly reduces maximum clock frequency
* Requires Vivado Hardware Manager

Once the design stabilizes, ILA probes are usually removed.

---

# 2. Memory-Mapped I/O via UART

## What it is

This method verifies system functionality by sending data between the PC and FPGA using the **UART interface**.

The CPU communicates with peripherals using **memory-mapped registers**, while the PC communicates with the CPU through a serial terminal.

Example tools:

* PuTTY
* TeraTerm
* Minicom

---

## Example workflow

1. PC sends input through UART.
2. CPU receives input.
3. CPU writes input to accelerator registers.
4. Accelerator computes result.
5. CPU reads result from MMIO registers.
6. CPU transmits result back over UART.

Example (SHA-256 accelerator):

```
PC → UART → CPU → SHA accelerator → CPU → UART → PC
```

---

## When to use UART/MMIO

This method is ideal for **system-level testing**.

Typical scenarios:

**Functional verification**

Example:

```
Input: "hello"
Output: SHA256 hash
```

Check that results match the expected value.

**Driver testing**

Verify software drivers that interact with hardware registers.

**Stress testing**

Run multiple inputs to ensure stable system behavior.

---

# 3. GPIO Debugging (LEDs & Buttons)

## What it is

The simplest debugging method uses physical GPIO pins such as **LEDs and buttons** on the board.

Signals are mapped directly to pins.

Example:

```verilog
assign led0 = sha_done;
assign led1 = cpu_fault;
```

---

## When to use GPIO

GPIO is useful for **quick visual feedback**.

Examples:

**Boot indicator**

```
LED0 = CPU running
```

**Error detection**

```
LED1 = exception or fault
```

**State display**

```
LED[2:0] = FSM state
```

---

## Advantages

* Works even when UART or JTAG debugging is unavailable
* No additional FPGA resources required
* Immediate visual feedback

---

# Typical Hardware Debug Workflow

In practice, FPGA verification follows this order:

### 1. Simulation

Verify modules using testbenches.

### 2. ILA Debugging

Confirm correct cycle-level behavior on real hardware.

### 3. System Testing (UART)

Verify full software–hardware functionality.

### 4. GPIO Indicators

Provide quick runtime status information.

