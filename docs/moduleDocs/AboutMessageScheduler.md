# Module: SHA-256 Message Scheduler
**Owner:** Akshat Birla Kushwah (Task 07)
**Layer:** Layer 2: Specialized Hardware

## Overview
The Message Scheduler prepares the incoming data for the Compression Core. It takes the padded 512-bit message block (sixteen 32-bit words) and dynamically expands them into the 64-word sequence required for the full hashing operation.

## Interface (Ports)
* **Inputs:**
  * `clk`: System clock.
  * `rst`: Reset signal to load the initial block.
  * `en`: Enable signal synced with the Compression Core.
  * `block_in` (512-bit): The initial 16-word input block.
  * `round_idx` (6-bit): The current round number (0 to 63).
* **Outputs:**
  * `w_out` (32-bit): The scheduled word ($W$) for the current round.

## Architecture & Behavior
1. **Initial Loading (Rounds 0-15):** For the first 16 cycles, the scheduler simply passes the original 16 words from the input block directly to the output.
2. **Dynamic Expansion (Rounds 16-63):** For the remaining 48 cycles, the module uses dedicated shift and XOR logic to generate a new 32-bit word on the fly. This prevents the need to synthesize 64 massive 32-bit registers, saving significant FPGA fabric space.
3. **Synchronization:** This module runs in parallel with the Compression Core's 64-cycle state machine, supplying exactly one scheduled word per clock cycle.
