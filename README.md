# 5-Stage Pipelined RV32I Processor

A custom **32-bit RV32I pipelined processor** implemented in **Verilog HDL**, featuring a modular 5-stage pipeline with data forwarding for improved instruction throughput. The processor was designed, implemented, and functionally verified using **Xilinx Vivado 2020.2**.

---

## Features

- 32-bit **RV32I** Integer Instruction Set Architecture
- 5-stage pipelined datapath (IF, ID, EX, MEM, WB)
- Data forwarding unit to mitigate data hazards
- Modular RTL implementation in Verilog HDL
- ALU with dedicated ALU Control Unit
- Register File and Immediate Generator
- Pipeline registers (IF/ID, ID/EX, EX/MEM, MEM/WB)
- Functional RTL simulation and verification in Xilinx Vivado 2020.2

---

## Processor Architecture

<p align="center">
  <img src="docs/architecture.png" alt="Processor Architecture" width="900"/>
</p>

---

## Pipeline Stages

| Stage | Description |
| :---: | ----------- |
| **IF** | Instruction Fetch |
| **ID** | Instruction Decode and Register Read |
| **EX** | ALU Execution and Operand Forwarding |
| **MEM** | Data Memory Access |
| **WB** | Register Write Back |

---

## Project Structure

```text
.
├── docs/
│   └── architecture.png
├── riscv.srcs/
├── README.md
├── .gitignore
└── riscv.xpr
```

---

## Tools & Technologies

- Verilog HDL
- Xilinx Vivado 2020.2
- RISC-V RV32I ISA

---

## Future Enhancements

- Hazard Detection Unit
- Branch Prediction
- Cache Memory Integration
- AXI Interface Support
- UART Peripheral Integration

---

## License

This project is released under the MIT License.
