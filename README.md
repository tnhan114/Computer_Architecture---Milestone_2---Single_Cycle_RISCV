# RISC-V RV32I Single-Cycle Processor

## Overview
This project implements a 32-bit **RISC-V (RV32I) single-cycle processor** developed for a Computer Architecture design milestone.

The processor executes each instruction within a single clock cycle and serves as the architectural foundation for later pipelined processor designs. The implementation includes datapath construction, control logic, memory interface, and functional verification through simulation.

---

## Architecture Features
- RV32I instruction set support (excluding FENCE)
- Single-cycle datapath architecture
- Centralized control unit
- Arithmetic Logic Unit (ALU)
- Branch Comparison Unit (BRC)
- 32 × 32-bit register file
- Load-Store Unit (LSU)
- Memory-mapped I/O support

---

## Processor Operation
All instruction stages complete in one clock cycle:
- Instruction Fetch
- Instruction Decode & Control
- Execute
- Memory Access
- Write Back

---

## Verification
Functional verification was performed using an instructor-provided verification environment.

The processor RTL design acts as the **Device Under Test (DUT)** and was validated through:
- Instruction-level simulation
- Functional testing programs
- Waveform inspection

---

## Simulation Environment
Simulation was executed on a Linux server using **Cadence Xcelium**.  
Waveforms were analyzed using SimVision.

---

## Tools & Technologies
- Verilog / SystemVerilog
- Cadence Xcelium (server-based simulation)
- Linux environment
- RISC-V RV32I ISA

---

## Learning Outcomes
- CPU datapath design
- Control signal generation
- Instruction execution flow
- Hardware verification methodology

---

## Status
✅ Functional implementation completed  
📄 Detailed report and results included
