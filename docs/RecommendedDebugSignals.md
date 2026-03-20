## Overview

When debugging a processor implemented on an FPGA, only a small subset of signals should be exposed to the ILA. These signals should allow reconstruction of the processor’s behavior without probing the entire design.

---

# 1. Program Counter (PC)

The **program counter** is the most important debug signal.

```
pc
next_pc
```

Why it matters:

* Shows which instruction is executing
* Reveals infinite loops
* Detects incorrect branch targets

Example:

```
PC sequence:
0x0000
0x0004
0x0008
0x000C
```

Sequential instruction execution.

---

# 2. Instruction Word

```
instruction
```

Allows decoding of the instruction being executed.

Useful for verifying:

* instruction fetch
* decoder correctness
* ALU operations

---

# 3. Pipeline Stage Valid Signals

For pipelined processors:

```
if_valid
id_valid
ex_valid
mem_valid
wb_valid
```

These signals reveal pipeline flow and stalls.

Example issue:

```
mem_valid stuck
```

Indicates memory stage is blocking the pipeline.

---

# 4. Register Writeback Signals

Expose writeback interface:

```
reg_write_enable
reg_write_addr
reg_write_data
```

This reveals every register update and allows reconstruction of program execution.

Example:

```
x5 ← 0x42
```

---

# 5. Memory Interface Signals

Memory transactions are frequent sources of bugs.

Expose:

```
mem_valid
mem_ready
mem_addr
mem_wdata
mem_rdata
mem_write
```

These signals verify proper memory bus handshakes.

---

# 6. Branch and Jump Signals

Expose:

```
branch_taken
branch_target
```

These help verify control-flow logic.

---

# 7. Pipeline Control Signals

Expose hazard signals:

```
stall
flush
hazard_detected
```

These signals explain why the pipeline may stop progressing.

---

# 8. Accelerator Interface Signals

For hardware accelerators:

```
sha_start
sha_busy
sha_done
sha_input_valid
sha_output_valid
```

These signals verify correct accelerator interaction with the CPU.

---

# 9. FSM State Signals

For modules controlled by finite state machines:

```
state
```

State observation simplifies debugging dramatically.

Example states:

```
IDLE
LOAD
PROCESS
DONE
```

---

# Minimal Recommended Debug Signal Set

For a small CPU + accelerator system:

```
pc
instruction

if_valid
id_valid
ex_valid
mem_valid
wb_valid

reg_write_enable
reg_write_addr
reg_write_data

mem_valid
mem_ready
mem_addr
mem_write

branch_taken
branch_target

stall
flush

sha_start
sha_busy
sha_done
```

This set allows most CPU bugs to be diagnosed efficiently.

---

# Important Debug Guidelines

**1. Avoid probing large arrays**

Bad:

```
register_file[0:31]
```

Instead probe writeback signals.

---

**2. Use ILA triggers**

Example:

```
pc == failure_address
```

Capture cycles before and after failure.

---

**3. Include a cycle counter**

```
cycle_counter
```

This helps correlate events in time.

