# RISC-V Single-Cycle Processor

A 32-bit RISC-V Single-Cycle Processor implemented using **SystemVerilog** and simulated using **AMD Vivado**.

## Project Overview

This project implements a simplified RV32I-based single-cycle processor. Each instruction is processed through the datapath in a single clock cycle.

The processor includes instruction fetching, decoding, execution, memory access, and register writeback.

## Architecture

The processor consists of the following modules:

| Module | Description |
|---|---|
| Program Counter | Holds the current instruction address |
| Instruction Memory | Stores and supplies instructions |
| Register File | Contains 32 general-purpose registers |
| Immediate Generator | Generates I, S, B, U and J immediates |
| Control Unit | Generates instruction control signals |
| ALU | Performs arithmetic and logical operations |
| Branch Unit | Evaluates branch conditions |
| Data Memory | Handles load and store operations |
| Writeback Mux | Selects the value written into the register file |
| RISC-V Top | Integrates all processor modules |

## Supported Instructions

### Arithmetic and Logical
- ADD, SUB, ADDI
- AND, OR, XOR
- ANDI, ORI, XORI

### Shift
- SLL, SRL, SRA
- SLLI, SRLI, SRAI

### Comparison
- SLT, SLTU
- SLTI, SLTIU

### Memory
- LB, LH, LW
- LBU, LHU
- SB, SH, SW

### Branch
- BEQ, BNE
- BLT, BGE
- BLTU, BGEU

### Jump and Upper Immediate
- JAL, JALR
- LUI, AUIPC

## Repository Structure

```text
RISC-V-Single-Cycle-Processor/
├── rtl/
├── tb/
├── programs/
├── constraints/
├── docs/
├── scripts/
├── vivado/
├── README.md
└── .gitignore
```

## Simulation and Verification

The processor was simulated using AMD Vivado Behavioral Simulation.

A comprehensive test program was created to verify arithmetic, logical, shift, comparison, memory, branch, jump, and upper-immediate instructions.

**Initial comprehensive simulation: ALL TESTS PASSED.**

## Tools Used

- SystemVerilog
- AMD Vivado
- Git
- GitHub

## Current Project Status

-  Processor modules implemented
-  Processor datapath integrated
-  Control unit implemented
-  Instruction memory initialized
-  Comprehensive testbench created
-  Initial simulation tests passed
-  Project uploaded to GitHub

##Further Possible Developments 
-  Additional corner-case verification
- FPGA implementation and hardware testing

## Scope and Limitations

This is a simplified single-cycle implementation of a subset of RV32I. It does not currently implement the complete RISC-V privileged architecture, CSR instructions, exception handling, or compressed instructions.

Misaligned memory accesses and their exception handling are not implemented.

## Author

Developed as a digital design and computer architecture project.