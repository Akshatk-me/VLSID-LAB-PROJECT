# Module: Register File
**Owner:** Akshat Birla Kushwah (Task 02)
**Layer:** Layer 1: Core Building Blocks

## Overview
The Register File is a core component of the RV32I processor's Decode (ID) stage. It is a 32x32-bit memory array designed to store and supply operands to the Unified ALU.

## Interface (Ports)
* **Inputs:**
  * `clk`: System clock.
  * `we`: Write Enable flag (driven by the Control Unit in the WB stage).
  * `rs1` (5-bit): Source register 1 address.
  * `rs2` (5-bit): Source register 2 address.
  * `rd` (5-bit): Destination register address.
  * `wd` (32-bit): Data to be written back.
* **Outputs:**
  * `rd1` (32-bit): Data read from `rs1`.
  * `rd2` (32-bit): Data read from `rs2`.

## Architecture & Behavior
1. **Asynchronous Reads:** The module features two asynchronous read ports. This ensures that as soon as an instruction is decoded, the operand values are immediately available for the Execute (EX) stage.
2. **Synchronous Writes:** It has one synchronous write port. Data is strictly written into the destination register (`rd`) on the positive edge of the clock when the Write Enable (`we`) signal is high.
3. **Hardwired Zero:** In compliance with the RISC-V ISA, Register `x0` is strictly hardwired to 0. Any attempt to write to `x0` is ignored by the hardware, and reading `x0` will always yield `0x00000000`.

## Reason for Asynchronous Read 

### 1. What “asynchronous read” means

A register file has:

* **synchronous write**
* **read ports**

An **asynchronous read port** means:

* The read output changes **immediately when the address changes**
* No clock edge is required

Conceptually:

```
rs1_addr ──► register file ──► rs1_data
```

If `rs1_addr` changes, `rs1_data` updates after combinational delay.

Example implementation:

```verilog
assign rs1_data = regs[rs1_addr];
assign rs2_data = regs[rs2_addr];
```

Writes remain synchronous:

```verilog
always @(posedge clk)
    if (we)
        regs[rd] <= write_data;
```

---

### 2. Why asynchronous reads work well in a pipeline

Consider the classic **5-stage pipeline**

```
IF → ID → EX → MEM → WB
```

The register file is typically accessed during **ID (decode)**.

Pipeline timeline:

```
cycle n
IF: fetch instruction

cycle n+1
ID: decode + read registers

cycle n+2
EX: ALU operation
```

With **asynchronous reads**, the flow works like this:

1. Instruction enters **ID stage**
2. Decoder extracts `rs1` and `rs2`
3. Register addresses go to register file
4. Data becomes available **in the same cycle**

So the register values are ready for the **EX stage next cycle**.

No extra cycle is needed.

---

### 3. What happens with synchronous reads

A synchronous register file behaves like this:

```
address registered → data appears next clock
```

So the pipeline becomes:

```
cycle n
ID: send read address

cycle n+1
ID: receive register data

cycle n+2
EX: execute
```

This adds **one extra cycle of latency**, which complicates the pipeline.

You must either:

* add another pipeline stage, or
* stall the pipeline

---

### 4. Why most teaching CPUs use async reads

Small RISC-V cores (especially FPGA projects) typically implement the register file like this:

```
32 registers
2 read ports
1 write port
```

Using flip-flops or distributed RAM.

This naturally supports **asynchronous reads**, making the pipeline simple.

Example cores using this style:

* PicoRV32
* many educational RISC-V implementations
* simple MIPS pipelines

---

### 5. Interaction with forwarding

Even with asynchronous reads, **forwarding is still required**.

Example:

```
add x5, x1, x2
add x6, x5, x3
```

Pipeline:

```
cycle 1  ID: read x1,x2
cycle 2  EX: compute result

cycle 2  ID: read x5,x3
```

But `x5` is not written yet.

So forwarding sends the value **from EX or MEM stage** to the ALU input.

Async reads do not remove the need for forwarding; they only simplify register access timing.

---

### 6. FPGA limitation: block RAM

Here's an important practical issue.

### FPGA Block RAM

FPGA **block RAMs are synchronous**.

So if you implement the register file using block RAM:

```
read = synchronous
```

which introduces a cycle of latency.

---

### 7. How FPGA CPUs usually solve this

Most small FPGA CPUs implement the register file using:

**distributed RAM or flip-flops**, not block RAM.

Advantages:

* asynchronous reads
* easier pipeline timing

Disadvantages:

* uses LUT resources

But since the register file is only:

```
32 registers × 32 bits = 1024 bits
```

this is cheap.

---

### 8. Typical register file architecture

Most simple RISC-V cores use:

```
2 read ports
1 write port
```

Structure:

```
          ┌─────────────┐
rs1_addr ─►             │
rs2_addr ─► register    │
          │   file      ├─► rs1_data
rd_addr  ─►             ├─► rs2_data
rd_data  ─►             │
write_en ─►             │
          └─────────────┘
```

Reads are combinational.

Writes occur on clock edge.

---

### 9. The only tricky case: write-after-read

What happens if you read and write the same register in the same cycle?

Example:

```
add x5, ...
next instruction reads x5
```

Solutions:

1. **forwarding network**
2. **write-first behavior**

Forwarding is the common solution.

---

### 10. When asynchronous reads are NOT used

Large processors or ASIC designs often use:

```
fully synchronous register files
```

Reasons:

* better timing control
* easier synthesis
* compatible with SRAM macros

But those pipelines are deeper and designed around the latency.

