
'''
Conversion of COMPRESS circuit to a verilog suitable for AGEMA input.
The parser is based on compress.py
'''

import argparse
from dataclasses import dataclass, field
from enum import Enum
from pathlib import Path
from typing import Sequence, Mapping, Tuple, Set, NewType, Callable, Optional, Any

##################################
####### Circuit descrtiption #####
##################################

# We work with Boolean circuits where the gates will be turned in gadgets. We
# never explicitly handle the gates inside the gadgets: gadgets are opaque
# primitive elements from the point of view of this script.
# The same holds for variables: they represent non-masked values, or,
# equivalently, complete sharings. We never manipulate individual shares
# directly.

class Operation(str, Enum):
    '''Logic gate in the Boolean circuit.'''
    XOR = '+'
    XNOR = '#'
    AND = '&'
    NOT = '!'

    def to_gate(self) -> str:
        return {
                '+': 'XOR2_X1',
                '#': 'XNOR2_X1',
                '&': 'AND2_X1',
                '!': 'INV_X1',
                }[self]

    def ports(self):
        return {
                '+': ('Z', 'A', 'B'),
                '#': ('ZN', 'A', 'B'),
                '&': ('ZN', 'A1', 'A2'),
                '!': ('ZN', 'A'),
                }[self]


# Variable in the Boolean circuit
Variable = NewType('Variable', str)


@dataclass(frozen=True)
class Computation:
    '''A way to compute the value of a variable in the circuit.'''
    operation: Operation
    operands: Sequence[Variable]


@dataclass
class Circuit:
    '''A Boolean circuit.

    It is made of input variables and intermediate variables. There may be
    multiple ways to compute each intermediate variables, which are represented
    by a set of Computation objects (each Computation object has an Operation
    and a list of operands).
    For example, a variable 'z' can be computed as 'z = x & y' or as 'z =
    z-cross ^ z-inner' where 'z-cross = CROSS(x, y)' and 'z-inner = INNER(x,
    y)'.
    '''
    # Invariants:
    # - all inputs are distinct
    # - all inputs and keys of 'computations' are in all_vars
    # - an input cannot appear in computations
    # - all operands of computations belong to all_vars
    # - there cannot be any computational cycle

    inputs: Sequence[Variable] = field(default_factory=list)
    outputs: Sequence[Variable] = field(default_factory=list)
    # Maps a variable to the ways of computing it.
    computations: Mapping[Variable, Set[Computation]] = field(default_factory=dict)
    # Maps a variable to the variables that have it as an operand.
    dependents: Mapping[Variable, Set[Variable]] = field(default_factory=dict)

    @property
    def all_vars(self):
        return set(self.computations.keys()) | set(self.inputs)

    def _add_input(self, input_):
        'Private builder method.'
        assert input_ not in self.all_vars
        self.inputs.append(input_)
        self.dependents[input_] = set()

    def _add_output(self, output):
        assert output not in self.outputs
        assert output in self.all_vars
        self.outputs.append(output)

    def _add_computation(self, res, computation):
        assert all(op in self.all_vars for op in computation.operands)
        assert res not in self.inputs
        self.computations.setdefault(res, set()).add(computation)
        for op in computation.operands:
            self.dependents[op].add(res)
        self.dependents[res] = set()

    @classmethod
    def from_circuit_str(cls, circuit: str):
        '''Convert the file representation of Boolean circuits to a Circuit.'''
        # Example circuit string:
        #     // A comment
        #     INPUTS i0 i1 i2
        #     OUTPUTS o0 o1
        #     o0 = i0 + i1 // a XOR gate
        #     t = i0 # i1 // a XNOR gate
        #     o1 = i0 & t // an AND gate
        c = Circuit()
        # Split into lines, remove comments and extraneous whitespace
        l = [line.split('//')[0].strip() for line in circuit.splitlines()]
        # Remove empty lines
        l = [line for line in l if line]
        # There can be only one input and one output line.
        inputs_line = next(line for line in l if line.startswith('INPUTS'))
        outputs_line = next(line for line in l if line.startswith('OUTPUTS'))
        # Convert inputs and outputs to Variable type.
        inputs = [Variable(x) for x in inputs_line.strip().split()[1:] if x]
        outputs = [Variable(x) for x in outputs_line.strip().split()[1:] if x]
        # Add inputs to the circuit
        for input_ in inputs:
            c._add_input(input_)
        # Process computations
        computation_lines = [line for line in l if line != inputs_line and line != outputs_line]
        for computation in computation_lines:
            if Operation.NOT in computation: # handle NOT case
                beg, op, op1 = computation.partition(Operation.NOT)
                res, eq = beg.split()
                assert eq == '=', (eq, computation)
                c._add_computation(Variable(res), Computation(Operation(op), (Variable(op1), )))
            else:
                res, eq, op1, op, op2 = computation.split()
                assert eq == '=', (eq, computation)
                c._add_computation(Variable(res), Computation(Operation(op), (Variable(op1), Variable(op2))))
        # Add inputs to the circuit
        for output in outputs:
            c._add_output(output)
        return c

def circuit2v(circuit: Circuit, module_name: str) -> str:
    lines = []
    lines.append(f'module {module_name} (')
    lines.append('    ' + ', '.join(circuit.inputs + circuit.outputs))
    lines.append(');')
    for x in circuit.inputs:
        lines.append(f'(* AGEMA = "secure" *) input {x};')
    for x in circuit.outputs:
        lines.append(f'(* AGEMA = "secure" *) output {x};')
    for x in circuit.computations:
        lines.append(f'wire {x};')
    for x, computations in circuit.computations.items():
        c = next(iter(computations))
        ops = ', '.join(f'.{opx}({op})' for opx, op in zip(c.operation.ports(), [x] + list(c.operands)))
        lines.append(f'{c.operation.to_gate()} c_{x}({ops});')
    lines.append('endmodule')
    return '\n'.join(lines)

def cli():
    parser = argparse.ArgumentParser()
    parser.add_argument("--circuit", required=True, type=Path, help="Input circuit file.", )
    parser.add_argument('--out', required=True, type=Path, help='Generated verilog file.')
    return parser


def main():
    args = cli().parse_args()
    assert args.circuit.is_file(), f"Circuit file {args.circuit} does not exist."
    with open(args.circuit, 'r') as f:
        circuit_s = f.read()
    circuit_v = circuit2v(Circuit.from_circuit_str(circuit_s), args.circuit.stem)
    with open(args.out, 'w') as f:
        f.write(circuit_v + '\n')


if __name__ == '__main__':
    main()
