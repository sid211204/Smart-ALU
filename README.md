# Smart ALU using Verilog HDL

## Overview

This project implements a parameterized Smart Arithmetic Logic Unit (Smart ALU) in Verilog HDL.

The ALU supports arithmetic, logical, shift, rotate, comparison, and intelligent operating modes such as signed arithmetic, saturation arithmetic, approximate computing, and low-power mode.

---

## Features

- Parameterized data width
- Addition
- Subtraction
- Multiplication
- Division
- Barrel Left Shift
- Barrel Right Shift
- Rotate Left
- Rotate Right
- AND
- OR
- XOR
- NAND
- NOR
- XNOR
- Greater Than Comparison
- Equality Comparison

---

## Smart Features

- Signed Arithmetic Mode
- Saturation Arithmetic
- Approximate Addition
- Low Power Mode

---

## Status Flags

- Zero Flag
- Carry Flag
- Overflow Flag
- Divide-by-Zero Flag

---

## Inputs

| Signal | Width | Description |
|---------|------|-------------|
| a | WIDTH | Operand A |
| b | WIDTH | Operand B |
| sel | 4 | Operation Select |
| signed_mode | 1 | Signed Arithmetic Enable |
| saturation_mode | 1 | Saturation Enable |
| approx_mode | 1 | Approximate Computing Enable |
| low_power_mode | 1 | Low Power Mode |

---

## Outputs

| Signal | Description |
|---------|-------------|
| out | ALU Result |
| zero_flag | Result is Zero |
| carry_flag | Carry Generated |
| overflow_flag | Overflow Detected |
| div_zero_flag | Divide by Zero |

---

## Tools Used

- Verilog HDL
- Xilinx Vivado

---
