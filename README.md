# Diad RISC Core

Diad is an experimental 24-bit RISC microarchitecture. It features a simple five-stage pipeline that now includes full instruction decode, execution and memory access. The current design adds a register file, forwarding, branch handling and basic hazard detection so a small program can run end-to-end.

The overall architecture and instruction format are documented in `design.txt`.

## Repository layout

```
src/        Verilog source files for the core and its pipeline stages
LICENSE     GPLv3 license text
```

Key pipeline stages are defined in `src/diad.v`:

```
1. IA/IF – Instruction Address & Fetch
2. ID    – Instruction Decode
3. EX    – Execute
4. MA/MO – Memory Address & Operation
5. RA/RO – Register Address & Operation
```

## Building and simulation

The project is written for Verilog-2001. A simple way to test the design is with Icarus Verilog:

```bash
iverilog -DMEM_HEX_FILE="\"simple_loop.hex\"" -g2012 -o test.vvp src/*.v
vvp test.vvp
```

The repository includes a small test program in `simple_loop.hex`.
Simulation shows the pipeline executing this code, and debug output can be enabled by defining `DEBUGPC`, `DEBUGINSTR` or related macros when running Icarus Verilog.

## License

This project is distributed under the terms of the GNU General Public License version 3. See the `LICENSE` file for details.
