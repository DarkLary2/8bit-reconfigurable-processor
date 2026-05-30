# 8bit-reconfigurable-processor


# 8-bit Reconfigurable Processor (FPGA Implementation)

A lightweight, custom RISC-like processor designed in **SystemVerilog** and implemented on the **RealDigital Boolean Board** (Spartan-7 FPGA). The architecture features a hybrid operational mode allowing dynamically selectable execution between parallel 4-bit dual processing and integrated 8-bit processing.

## Key Features
* **Reconfigurable Architecture:** Hardware switchable execution widths (Dual 4-bit vs Unified 8-bit).
* **Full Datapath Integration:** Includes Program Counter (PC), Instruction ROM, Unified Read-Write Memory (RWM), Arithmetic Logic Unit (ALU), and a multiplexed 7-Segment display controller.
* **Synchronous Flow with Glitch Mitigation:** Hardwired hardware debouncer on physical inputs (`btn`) to ensure precise single-step manual instruction execution.
* **Production-Ready Constraints:** Fully closed timing constraints optimized for hardware stability and low-metastability risk.

---

## Architecture Overview

The system architecture follows a classic modular design:
1. **Control Unit (PC & ROM):** Drives the fetch cycle by auto-incrementing memory addresses on clean input clock edges.
2. **Execution Unit (ALU):** Handles arithmetic (ADD, SUB, MUL, DIV, MOD) and bitwise operations (AND, OR, XOR, NOT, Shifts) with dedicated hardware status flags (Carry, Borrow, Zero, Sign, Parity, Overflow).
3. **Storage (RWM):** Memory array utilizing a banking mechanism to manage register space and immediate test-data loading.



---

## File Structure

* `rtl/` - SystemVerilog source files (Top module, ALU, Memory, Display Controller).
* `sim/` - Behavioral testbench (`tb.sv`) for verification.
* `constraints/` - RealDigital Boolean Board physical pin mappings (`constraints.xdc`).

