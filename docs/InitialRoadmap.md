This is a **Modular "Claim-a-Task" System**. This breaks the project into discrete units of work with clearly defined inputs and outputs (interfaces). If one person finishes a task, they can grab the next one; if someone doesn't show up, their specific module is the only thing that stalls.

Here is our layered roadmap for the **RV32I SoC with SHA-256 Accelerator**.

---

## Layer 1: The Building Blocks (Hardware Components)

These are standalone modules that can be designed and tested individually with their own testbenches.

* **Task 1: The "Unified" ALU:** Design a single ALU that handles arithmetic (ADD, SUB), logical (AND, OR, XOR), and comparison (SLT) operations.

* **Task 2: Register File:** Build a 32x32-bit register file with two read ports and one write port.

* **Task 3: Multi-cycle Multiplier:** Create a separate module for multiplication (M-extension subset) that takes multiple cycles to complete.

* **Task 4: BRAM Controller:** Design the interface for the PYNQ-Z2 Block RAM. It must support a single-port "Von Neumann" style (fetching instructions and data in different cycles).

* **Task 5: GPIO & UART Modules:** Implement a basic GPIO controller (for LEDs) and a UART TX/RX module for PC communication.



---

## Layer 2: The SHA-256 Engine (Specialized Hardware)

This is the "special functionality" of your project. Since you want it parallelized, these tasks focus on the crypto-core.

* **Task 6: SHA-256 Constants & Padding:** Implement the hardware logic for SHA-256 padding and the 64-word constant array.

* **Task 7: SHA-256 Compression Core:** The "round logic" that performs the actual hashing transformations.

* **Task 8: Message Scheduler:** Build the logic that expands the 512-bit message block into the 64-word sequence required by the core.

* **Task 9: Parallel Controller:** Design a logic wrapper that allows the SHA-256 engine to process multiple data blocks or utilize multiple compression cores in parallel.

---

## Layer 3: The Multi-Cycle Brain (Integration)

*This layer connects the blocks from Layer 1 into a functioning processor.*

* **Task 10: Instruction Decoder:** Create a module that takes a 32-bit instruction and breaks it into opcode, func3, func7, and register addresses.

* **Task 11: The Main FSM:** Design the State Machine to orchestrate the Fetch, Decode, Execute, Memory, and Write-back stages.

* **Task 12: Memory-Mapped I/O (MMIO) Bridge:** Create the address decoding logic so the CPU can "talk" to the UART, GPIO, and SHA-256 core by reading/writing to specific memory addresses.

---

## Layer 4: CSRs & Privileged Logic (Mandatory Features)

These tasks ensure the processor meets the specific project requirements for machine-mode operation.

* **Task 13: CSR Register Bank:** Implement `mcycle`, `minstret`, `mstatus`, `mtvec`, and `mepc`.

* **Task 14: Exception Handling:** Add logic to the FSM to handle `ecall` or illegal instructions by jumping to the address in `mtvec`.

* **Task 15: Performance Counter Logic:** Connect the `mcycle` and `minstret` registers so they increment correctly during execution.



---

## Layer 5: Testing & Deployment (The Final Push)

*Moving the verified Verilog onto the actual FPGA hardware.*

* **Task 16: Assembly Test Suite:** Write a RISC-V assembly program that tests every instruction type (R, I, S, B, U, J).

* **Task 17: SHA-256 "Driver" Program:** Write an assembly/C program that sends a string to the SHA-256 accelerator and reads back the resulting hash.

* **Task 18: FPGA Constraints & ILA:** Map the design pins to the PYNQ-Z2 board and set up the Integrated Logic Analyzer (ILA) to view signals during the demo.


