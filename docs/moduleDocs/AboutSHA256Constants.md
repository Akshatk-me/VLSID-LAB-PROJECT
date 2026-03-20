# Module: SHA-256 Constants & Padding Logic
**Owner:** Akshat Birla Kushwah (Task 06)
**Layer:** Layer 2: Specialized Hardware

## Overview
This module acts as the reference library for the SHA-256 cryptographic accelerator. It securely stores the standard mathematical constants required to perform the hashing algorithm.

## Interface (Ports)
* **Inputs:**
  * `round_idx` (6-bit): The current round number (0 to 63) provided by the Compression Core.
* **Outputs:**
  * `k_out` (32-bit): The specific round constant for the current cycle.
  * `h0` to `h7` (32-bit each): The 8 standard initial hash values.

## Architecture & Behavior
1. **Round Constants ($K[i]$):** The module contains a combinational Look-Up Table (ROM) that stores the 64 round constants. Based on the 6-bit `round_idx` input from the Compression Core state machine, it outputs the correct 32-bit predefined round constant.
2. **Initial Hash Values ($H_0$):** It statically outputs the 8 initial hash values. These are the starting variables loaded into the Compression Core before the 64-round hashing process begins.
