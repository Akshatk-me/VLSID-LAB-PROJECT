A **SHA-256 accelerator** is a hardware module that computes the SHA-256 hash much faster than software running on a CPU. In an SoC with a RISC-V processor, the accelerator is typically attached as a **memory-mapped peripheral**, so the CPU sends data to it and receives the hash result.

To understand how to build one, you need to understand three things:

1. **The SHA-256 algorithm itself**
2. **How the algorithm maps to hardware**
3. **How the accelerator interfaces with the CPU**

Below is a structured explanation starting from the algorithm and moving toward hardware design.

---

# 1. What SHA-256 Does

SHA-256 is a cryptographic hash function that maps arbitrary input data to a **256-bit digest**.

Properties:

* deterministic
* fixed output size (256 bits)
* collision resistant
* one-way (hard to invert)

Example:

```
Input:  "hello"
Output: 2cf24dba5fb0a30e26e83b2ac5b9e29e...
```

Internally, SHA-256 processes data in **512-bit blocks**.

Pipeline of operations:

```
message
   ↓
padding
   ↓
512-bit blocks
   ↓
64 rounds of compression
   ↓
256-bit hash
```

The **compression function** is what your accelerator will implement.

---

# 2. SHA-256 State

The algorithm maintains **eight 32-bit registers**:

```
a b c d e f g h
```

These represent the internal state.

Initial constants:

```
h0 = 0x6a09e667
h1 = 0xbb67ae85
h2 = 0x3c6ef372
h3 = 0xa54ff53a
h4 = 0x510e527f
h5 = 0x9b05688c
h6 = 0x1f83d9ab
h7 = 0x5be0cd19
```

These values are loaded at the start.

---

# 3. Message Schedule

Each 512-bit block is split into **16 words**:

```
W0 ... W15
```

But the algorithm requires **64 words**, so additional ones are computed:

```
W16 ... W63
```

Using:

```
W[t] = σ1(W[t−2]) + W[t−7] + σ0(W[t−15]) + W[t−16]
```

Where:

```
σ0(x) = ROTR7(x) XOR ROTR18(x) XOR SHR3(x)
σ1(x) = ROTR17(x) XOR ROTR19(x) XOR SHR10(x)
```

In hardware this becomes a **message scheduler unit**.

---

# 4. The Core Round Function

The algorithm runs **64 rounds**.

Each round uses:

```
T1 = h + Σ1(e) + Ch(e,f,g) + K[t] + W[t]
T2 = Σ0(a) + Maj(a,b,c)
```

Where:

```
Ch(x,y,z)  = (x AND y) XOR (~x AND z)
Maj(x,y,z) = (x AND y) XOR (x AND z) XOR (y AND z)
```

And rotations:

```
Σ0(x) = ROTR2(x) XOR ROTR13(x) XOR ROTR22(x)
Σ1(x) = ROTR6(x) XOR ROTR11(x) XOR ROTR25(x)
```

Then state updates:

```
h = g
g = f
f = e
e = d + T1
d = c
c = b
b = a
a = T1 + T2
```

This is repeated **64 times**.

---

# 5. Hardware Architecture of a SHA-256 Accelerator

Most designs contain these blocks:

```
                ┌──────────────┐
message block → │ message      │
                │ scheduler    │
                └──────┬───────┘
                       │ W[t]
                       ▼
                ┌──────────────┐
                │ compression  │
                │ round core   │
                └──────┬───────┘
                       │
                       ▼
                ┌──────────────┐
                │ state        │
                │ registers    │
                └──────────────┘
```

Major components:

1. message scheduler
2. round computation unit
3. state registers
4. round counter
5. control FSM

---

# 6. Sequential vs Parallel Designs

There are two main architectures.

## Iterative (most common)

One round per clock.

```
64 cycles per block
```

Hardware cost is low.

Structure:

```
round_unit
   ↑
register feedback
```

---

## Fully unrolled

All 64 rounds exist in hardware.

```
1 clock per block
```

But area is very large.

Most FPGA projects use **iterative architecture**.

---

# 7. Control FSM

A typical accelerator uses a state machine:

```
IDLE
LOAD_BLOCK
EXPAND_MESSAGE
ROUND_LOOP
FINAL_ADD
DONE
```

Example flow:

```
CPU writes start
      ↓
load input block
      ↓
run 64 rounds
      ↓
update hash
      ↓
set done flag
```

---

# 8. Accelerator Interface (MMIO)

The CPU interacts with the accelerator via **memory-mapped registers**.

Example register map:

```
0x00 CONTROL
0x04 STATUS
0x08 BLOCK0
0x0C BLOCK1
...
0x44 BLOCK15
0x48 HASH0
...
0x64 HASH7
```

Workflow:

CPU writes input:

```
write BLOCK0 ... BLOCK15
```

Start computation:

```
write CONTROL.start = 1
```

Wait:

```
STATUS.done
```

Read result:

```
HASH0 ... HASH7
```

---

# 9. Example Hardware Data Path

Typical datapath:

```
           W[t]
            │
            ▼
    ┌───────────────┐
    │ compression   │
    │ round logic   │
    └─────┬─────────┘
          │
          ▼
   a b c d e f g h registers
```

Each clock:

* compute T1 and T2
* shift registers
* update state

---

# 10. Important Hardware Operations

SHA-256 maps extremely well to hardware because it uses only:

* bitwise operations
* additions
* rotations
* shifts

Main units needed:

```
32-bit adders
rotators
XOR gates
AND gates
```

No multipliers required.

---

# 11. Performance Example

Software SHA-256:

```
~1000+ cycles per block
```

Hardware accelerator:

```
~64 cycles per block
```

Speedup ≈ **15–30×**.

---

# 12. Verification Strategy

Typical verification steps:

### Unit testing

Test message scheduler separately.

Test compression round logic.

---

### Known test vectors

Example SHA-256 test:

```
Input: "abc"

Expected hash:
ba7816bf8f01cfea414140de5dae2223...
```

---

### Integration test

CPU writes input block.

Accelerator returns hash.

Compare with software implementation.

---

# 13. Common Beginner Mistakes

**Incorrect rotation implementation**

Rotate ≠ shift.

---

**Endianness mistakes**

SHA-256 uses **big-endian word order**.

---

**Message padding errors**

Padding must follow exact specification.

---

**Incorrect constant table**

SHA-256 uses **64 constants K[t]**.

---

# 14. Typical Verilog Modules

A full design might include:

```
sha256_top
sha256_control
sha256_round
sha256_message_schedule
sha256_constants
```

---

# 15. Rough Development Steps

Step 1 — implement **single round logic**

Step 2 — implement **64-round loop**

Step 3 — implement **message scheduler**

Step 4 — integrate **state registers**

Step 5 — add **control FSM**

Step 6 — add **MMIO interface**

Step 7 — test with **known vectors**

---

# Summary

A SHA-256 accelerator consists of:

* message scheduler generating W[t]
* compression core performing 64 rounds
* state registers (a–h)
* control FSM
* MMIO interface to CPU

The hardware repeatedly executes the SHA-256 round function, updating the state until the final 256-bit hash is produced.


