# 8-Bit Gate-Level ALU

An 8-bit Arithmetic Logic Unit (ALU) implemented in **structural Verilog** using basic logic gates and interconnected modules.

The ALU supports arithmetic, bitwise logic, and logical shift operations. Its design is built from reusable components, including a full adder, 2:1 multiplexer, 8:1 multiplexer, adder/subtractor, and barrel shifter.

## Features

- 8-bit input operands (`A` and `B`)
- 3-bit operation selector
- Arithmetic: addition and subtraction
- Bitwise logic: AND, OR, XOR, and NOT
- Logical shift right and logical shift left
- Zero and carry outputs
- Interactive testbench
- VCD waveform generation for simulation analysis

## Supported Operations

| `op` | Operation | Description |
|:---:|---|---|
| `000` | ADD | `A + B` |
| `001` | SUB | `A - B` |
| `010` | AND | `A & B` |
| `011` | OR | `A \| B` |
| `100` | XOR | `A ^ B` |
| `101` | NOT | `~A` |
| `110` | SHR | Logical right shift of `A` by `B[2:0]` |
| `111` | SHL | Logical left shift of `A` by `B[2:0]` |

For shift operations, `B[2:0]` specifies a shift amount from 0 to 7. Vacated bit positions are filled with zero.

## Architecture

The design is divided into small modules:

| File | Module | Responsibility |
|---|---|---|
| `alu8.v` | `alu8` | Top-level ALU. Selects the operation result and generates the zero flag. |
| `full_adder.v` | `full_adder` | One-bit full adder built from XOR, AND, and OR gates. |
| `adder_sub8.v` | `adder_sub8` | 8-bit ripple-carry adder/subtractor using eight full adders. |
| `mux2.v` | `mux2` | Gate-level 2:1 multiplexer. |
| `mux8.v` | `mux8` | 8:1 multiplexer constructed from 2:1 multiplexers. |
| `barrel_shifter_right.v` | `barrel_shifter_right` | 8-bit logical right barrel shifter with three shift stages. |
| `tb_alu8_interactive.v` | `tb_alu8_interactive` | Interactive testbench for entering operands and selecting operations. |

### Design Details

- **Addition and subtraction:** The same ripple-carry adder performs both operations. For subtraction, the second operand is XORed with the subtraction control, and the initial carry-in is set to 1. This implements two's-complement subtraction.
- **Logic operations:** AND, OR, XOR, and NOT are constructed using gate-level primitives.
- **Shifts:** The right barrel shifter uses three stages to shift by 1, 2, and 4 positions. Left shift is implemented by reversing the input bits, using the right shifter, and reversing the result.
- **Result selection:** Each result bit is selected using an 8:1 multiplexer.
- **Zero flag:** `zero` is 1 when all eight result bits are 0.
- **Carry output:** `carry` is connected to the adder/subtractor carry-out. It is not selected or recalculated for the logic and shift operations.

## Project Structure

```text
.
├── alu8.v
├── adder_sub8.v
├── full_adder.v
├── barrel_shifter_right.v
├── mux2.v
├── mux8.v
├── tb_alu8_interactive.v
└── README.md
```

The testbench also generates `alu.vcd` during simulation. The ZIP archive may include generated simulation artifacts such as `sim` and `alu.vcd`; these are not required to compile the design from source.

## Requirements

- [Icarus Verilog](https://steveicarus.github.io/iverilog/) for compilation and simulation
- [GTKWave](https://gtkwave.sourceforge.net/) (optional) for viewing waveforms

## Run the Simulation

Compile the Verilog source files:

```bash
iverilog -o sim mux2.v mux8.v full_adder.v adder_sub8.v barrel_shifter_right.v alu8.v tb_alu8_interactive.v
```

Run the simulation:

```bash
vvp sim
```

The testbench displays an operation menu and prompts you to enter the operands in binary.

Example interaction:

```text
0:ADD 1:SUB 2:AND 3:OR 4:XOR 5:NOT 6:SHR 7:SHL 8:QUIT
operation (decimal): 0
A (8-bit binary): 00001111
B (8-bit binary): 00000001
```

The testbench prints the selected operation, input values, and result in binary and decimal. Enter `8` to quit.

## View Waveforms

The testbench writes simulation signals to `alu.vcd`.

Open the waveform file with GTKWave:

```bash
gtkwave alu.vcd
```

## Notes

- Inputs `A` and `B` are unsigned 8-bit vectors.
- The NOT operation uses only `A`; `B` is not used.
- Shift operations use only the lower three bits of `B`.
- The zero flag is based on the selected ALU result.
- The carry output always reflects the adder/subtractor circuit, regardless of the selected operation.

