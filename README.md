# Pipelined RISC-V Processor

A 5-stage pipelined RV32I processor designed in Verilog HDL featuring data forwarding to resolve data hazards. The processor was developed and simulated in Xilinx Vivado 2020.2 as part of my digital design learning and FPGA development journey.

---

## Features

- 5-stage RISC-V pipeline
  - Instruction Fetch (IF)
  - Instruction Decode (ID)
  - Execute (EX)
  - Memory (MEM)
  - Write Back (WB)
- RV32I instruction support
- Data forwarding unit
- Immediate generator
- Register file
- ALU
- Instruction memory
- Data memory
- Pipeline registers
- Branch handling
- Verilog testbench for simulation

---

## Project Structure

```
riscv.srcs/
├── sources_1/
│   └── new/
│       ├── alu.v
│       ├── control_unit.v
│       ├── cpu_top.v
│       ├── data_memory.v
│       ├── forwarding_unit.v
│       ├── imm_generator.v
│       ├── instruction_memory.v
│       ├── pipeline_registers.v
│       ├── progcount.v
│       ├── register_file.v
│       └── riscv_top.v
│
└── sim_1/
    └── new/
        ├── tb_riscv_top.v
        └── program.hex
```

---

## Pipeline Architecture

| Stage | Description |
|--------|-------------|
| IF | Fetch instruction and update Program Counter |
| ID | Decode instruction and read register operands |
| EX | Perform ALU operations and branch calculations |
| MEM | Access data memory |
| WB | Write results back to register file |

---

## Hazard Handling

Implemented:

- Data Forwarding
- EX/MEM Forwarding
- MEM/WB Forwarding

Current limitations:

- No hazard detection unit
- No pipeline stalling
- No branch prediction

---

## Tools Used

- Verilog HDL
- Xilinx Vivado 2020.2
- Xilinx Simulator (XSIM)

---

## Simulation

The processor was verified using a custom Verilog testbench.

Sample program:

```assembly
ADDI x1, x0, 3
ADDI x2, x0, 1
SUB  x1, x1, x2
BNE  x1, x0, loop
```

---

## Future Improvements

- Hazard Detection Unit
- Pipeline Stalling
- Branch Prediction
- JAL/JALR support
- Cache Memory
- AXI Interface
- FPGA implementation on Xilinx evaluation boards

---

## Author

**Manas Tomar**

B.Tech Electrical Engineering

Delhi Technological University

Interested in FPGA Design • RTL Design • Digital Design • Embedded Systems
