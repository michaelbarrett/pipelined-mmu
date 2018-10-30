# pipelined-mmu
A three-stage pipelined multimedia unit written in VHDL.

# features
- A multimedia ALU
- A register file, which stores 32 128-bit registers
- An instruction buffer, which stores 32 24-bit instructions
- A three-stage pipelined multimedia unit, with edge-sensitive interstage registers.
- IF, ID, and EXE pipeline stages, where EXE is responsible for calculating the result and writing it to the register file.
- An equivalent runtime of three cycles for all instructions.
- A testbench supplies a program and displays register file contents.