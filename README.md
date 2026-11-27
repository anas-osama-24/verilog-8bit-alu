# 8-Bit Gate-Level ALU

An 8-bit Arithmetic Logic Unit (ALU) implemented in **structural Verilog** using basic logic gates and interconnected modules.

The ALU supports arithmetic, bitwise logic, and logical shift operations. Its design is built from reusable components: a full adder, 2:1 multiplexer, 8:1 multiplexer, adder/subtractor, and separate left and right barrel shifters.

## Features

- 8-bit input operands (`A` and `B`)
- 3-bit operation selector
- Arithmetic: addition and subtraction
- Bitwise logic: AND, OR, XOR, and NOT
- Logical shift right and logical shift left, each with its own barrel shifter
- Zero and carry outputs (carry is valid for ADD and SUB only)
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

| File | Module | Responsibility |
|---|---|---|
| `alu8.v` | `alu8` | Top-level ALU. Selects the operation result and generates the zero and carry flags. |
| `full_adder.v` | `full_adder` | One-bit full adder built from XOR, AND, and OR gates. |
| `adder_sub8.v` | `adder_sub8` | 8-bit ripple-carry adder/subtractor using eight full adders. |
| `mux2.v` | `mux2` | Gate-level 2:1 multiplexer. |
| `mux8.v` | `mux8` | 8:1 multiplexer constructed from 2:1 multiplexers. |
| `barrel_shifter_right.v` | `barrel_shifter_right` | 8-bit logical right barrel shifter with three shift stages. |
| `barrel_shifter_left.v` | `barrel_shifter_left` | 8-bit logical left barrel shifter with three shift stages. |
| `tb_alu8_interactive.v` | `tb_alu8_interactive` | Interactive testbench for entering operands and selecting operations. |

### Design Details

- **Addition and subtraction:** The same ripple-carry adder performs both operations. For subtraction, the second operand is XORed with the subtraction control, and the initial carry-in is set to 1. This implements two's-complement subtraction.
- **Logic operations:** AND, OR, XOR, and NOT are built from gate-level primitives, one gate per bit.
- **Shifts:** Each barrel shifter uses three mux stages that shift by 1, 2, and 4 positions. Each stage is controlled by one bit of the shift amount.
  - Right shift: bit $i$ takes bit $i + k$.
  - Left shift: bit $i$ takes bit $i - k$.
  - Inputs that fall outside the 8-bit range are tied to 0.
- **Result selection:** Each result bit is selected using an 8:1 multiplexer.
- **Zero flag:** `zero` is 1 when all eight result bits are 0.
- **Carry output:** `carry` is the adder/subtractor carry-out, gated so it is 0 for every operation except ADD and SUB. After SUB, `carry = 1` means no borrow ($A \ge B$).

## Project Structure

```text
.
├── alu8.v
├── adder_sub8.v
├── full_adder.v
├── barrel_shifter_right.v
├── barrel_shifter_left.v
├── mux2.v
├── mux8.v
├── tb_alu8_interactive.v
└── README.md
```

The testbench also generates `alu.vcd` during simulation. Generated files such as `sim` and `alu.vcd` are not required to compile the design from source.

## Requirements

- [Icarus Verilog](https://steveicarus.github.io/iverilog/) for compilation and simulation
- [GTKWave](https://gtkwave.sourceforge.net/) (optional) for viewing waveforms

## Run the Simulation

Compile the Verilog source files:

```bash
iverilog -o sim -s tb_alu8_interactive mux2.v mux8.v full_adder.v adder_sub8.v barrel_shifter_right.v barrel_shifter_left.v alu8.v tb_alu8_interactive.v
```

Run the simulation:

```bash
vvp sim
```

The testbench shows an operation menu and prompts for the inputs.

### Input formats

| Input | Format |
|---|---|
| Operation | Decimal, 0 to 8 |
| `A` and `B` | Binary, up to 8 bits |
| Shift count | Decimal, 0 to 7 |

Invalid values are rejected and the prompt repeats.

### Example: addition

```text
0:ADD 1:SUB 2:AND 3:OR 4:XOR 5:NOT 6:SHR 7:SHL 8:QUIT
operation (decimal): 0
A (8-bit binary): 00001111
B (8-bit binary): 00000001
operation: ADD
A      = 00001111 (15)
B      = 00000001 (1)
result = 00010000 (16)
zero = 0, carry = 0
```

### Example: shift right

```text
operation (decimal): 6
A (8-bit binary): 01111100
number of bits to shift (decimal, 0 to 7): 2
operation: SHR
A      = 01111100 (124)
shift  = 2 bits
result = 00011111 (31)
zero = 0, carry = 0
```

Enter `8` to quit.

## View Waveforms

The testbench writes simulation signals to `alu.vcd`.

```bash
gtkwave alu.vcd
```

## Notes

- Inputs `A` and `B` are unsigned 8-bit vectors.
- The NOT operation uses only `A`; `B` is not asked for.
- Shift operations use only the lower three bits of `B`. The testbench asks for the shift count directly.
- The zero flag is based on the selected ALU result.
- The carry output is 0 for all operations except ADD and SUB.
- If the simulation shows old behavior, delete `sim` and recompile, so an old build is not run.
