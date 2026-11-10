# RISC-V-Single-Cycle-Processor

Implementation of 32-bit Single Cycle RISC-V Processor using System Verilog and verified via AMD Vivado





\# 32-bit Single-Cycle RISC-V Processor



\## Project Overview

A 32-bit RISC-V processor designed using SystemVerilog and AMD Vivado 2026.1.



\## Architecture



The processor is organized into five logical sections:



1\. IF - Instruction Fetch

2\. ID - Instruction Decode

3\. EX - Execute

4\. MA - Memory Access

5\. WB - Write Back



All five sections operate within a single clock cycle. This is a single-cycle processor, not a pipelined processor.



\## Tools Used

\- SystemVerilog

\- AMD Vivado 2026.1

\- Vivado XSim

\- Git

\- GitHub



\## Repository Structure

\- `rtl/` - Processor hardware design modules

\- `tb/` - Simulation testbenches

\- `programs/` - Test programs and instruction memory files

\- `docs/` - Project documentation and waveforms

\- `constraints/` - Constraint files, if needed

\- `scripts/` - Automation scripts

\- `vivado/` - Vivado project files



\## Project Status

Under development.



