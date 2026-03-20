This is a **Modular "Claim-a-Task" System**. This breaks the project into discrete units of work with clearly defined inputs and outputs (interfaces). If one person finishes a task, they can grab the next one; if someone doesn't show up, their specific module is the only thing that stalls.
This roadmap transitions the project into a **5-stage pipeline** that accommodates **Single-Port BRAM** and a **Multi-cycle Multiplier**  through a robust **Hazard Detection Unit**.

---

##  Layer 1: Core Pipeline RTL (The "Execution" Stream)

*Goal: Build the individual stages that will eventually be linked by pipeline registers.*

* **Task 1: Unified ALU (EX Stage)**
* Design a single ALU to handle all RV32I arithmetic, logic, and branch comparisons.
* Integrate the **Multi-cycle Multiplier** subset (M-extension) using logic-based shift-and-add or Booth's algorithm.
* **Task 2: Register File & ImmGen (ID Stage)**
* Build the 32x32-bit Register File with dual asynchronous reads and one synchronous write.
* Create the Immediate Generator to handle all sign-extension for I, S, B, U, and J formats.
* **Task 3: BRAM Controller (IF/MEM Stage)**
* Interface with PYNQ-Z2 Block RAM for a unified instruction and data memory.
* Implement logic to prioritize **MEM stage** data access over **IF stage** instruction fetch to handle the single-port bottleneck.





---

##  Layer 2: Control & Hazard Management (The "Intelligence" Stream)

*Goal: Orchestrate the flow of instructions and handle timing conflicts.*

* **Task 4: Main Control & Decode Logic**
* Implement combinational decoding of opcodes and `funct` fields to generate control signals for each stage.
* **Task 5: Hazard Detection Unit (The Traffic Cop)**
* **Data Hazards:** Detect "Load-Use" dependencies and trigger a 1-cycle stall.
* **Structural Hazards:** Stall the IF stage whenever the MEM stage is performing a `LW` or `SW`.
* **Multi-cycle Stalls:** Pause the pipeline while the Multiplier or SHA-256 is computing.
* **Task 6: Forwarding Unit**
* Design logic to bypass data from the EX/MEM and MEM/WB registers back to the ALU inputs to eliminate stalls for R-type instructions.



---

##  Layer 3: SoC Peripherals & CSRs (The "System" Stream)

*Goal: Meet the mandatory connectivity and privileged mode requirements.*

* **Task 7: MMIO Bridge & Peripherals**
* Design the bridge to map addresses to **BRAM**, **GPIO**, and **UART**.
* **Task 8: Machine-Mode CSR Bank (Zicsr)**
* Implement mandatory CSRs: `mcycle`, `minstret`, `mstatus`, `mtvec`, and `mepc`.
* Add logic for `CSRRW`, `CSRRS`, and `CSRRC` instructions.
* **Task 9: Exception & Trap Handler**
* Implement hardware jumping to `mtvec` for illegal instructions or `ecall`, while saving the faulting PC to `mepc`.





---

##  Layer 4: Parallelized SHA-256 Accelerator

Goal: Implement the "Specialized Hardware" extension.

* **Task 10: SHA-256 Core Logic**
* Implement the 512-bit message scheduler and the 64-round compression core.
* **Task 11: Parallel Interface Wrapper**
* Create an MMIO-mapped interface that allows the CPU to offload hashing tasks.
* Ensure the unit provides a `busy` signal to the **Hazard Unit** to stall the pipeline if the CPU attempts to read a result before it is ready.



---

##  Layer 5: Verification & FPGA Deployment

Goal: Move from Verilog to physical PYNQ-Z2 hardware.

* **Task 12: Pipeline Verification Suite**
* Write assembly testbenches specifically targeting Hazards, Forwarding, and Multi-cycle stalls.
* **Task 13: FPGA Synthesis & ILA Setup**
* Create the `.xdc` constraints file and implement the design on the PYNQ-Z2.
* Configure the **Integrated Logic Analyzer (ILA)** to monitor pipeline stages and SHA-256 status bits during the demo.





---

### Suggested Team Assignments (Claim List)

| Member | Focus Area | Deliverable |
| --- | --- | --- |
| **1 & 2** | **Datapath Stages** | ALU, Multiplier, RegFile, ImmGen |
| **3** | **Memory System** | BRAM Controller & MMIO Bridge |
| **4** | **Pipeline Logic** | Hazard Detection & Forwarding Units |
| **5** | **Control & CSRs** | Decoder, CSR Bank, Trap Handler |
| **6 & 7** | **SHA-256 Engine** | Crypto Core & Parallel Wrapper |
| **8** | **Integration** | UART, GPIO, and Final Testbenches |

