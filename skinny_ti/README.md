# Skinny 8-bit S-box TI implementations.
These implementations come from

*Andrea Caforio, Daniel Collins, Ognjen Glamocanin, Subhadeep Banik:
Improving First-Order Threshold Implementations of SKINNY. INDOCRYPT 2021: 246-267*

and all the VHDL code in this directory is copied from
https://github.com/qantik/skinny-dipping (and subject to its license).

## Synthesis
The synthesis is performed in two steps:

1. Using ghdl to convert the VHDL code to a verilog netlist.
2. Using yosys to synthesize to the NanGate45 technology.

The flow can be run with the command `make`, and the resulting files are in `work/`.

