"""
Verification of gadgets with SILVER. Uses fullverif annotations on the gadget
and generates the SILVER annotations (parsing of verilog done with Yosys).
"""
import argparse
from dataclasses import dataclass
import json
from pathlib import Path
import re
import subprocess as sp
import time
from typing import Optional


@dataclass
class Settings:
    circuit: Path
    work: Path
    yosys: Path
    silver_root: Path
    nshares: int

    @property
    def module(self):
        return self.circuit.stem

    @property
    def circ_json(self):
        return self.work / f"{self.module}_d{self.nshares}.json"

    @property
    def circ_top(self):
        return self.work / f"top_{self.module}_d{self.nshares}.v"

    @property
    def circ_synth(self):
        return self.work / f"synth_{self.module}_d{self.nshares}.v"

    @property
    def insfile(self):
        return self.work / f"{self.module}_d{self.nshares}.nl"


@dataclass
class Gadget:
    module_name: str
    input_sharings: list[(str, int)]
    output_sharings: list[str]
    clk: Optional[str]
    rnd: list[(str, int)]
    nshares: int

    @classmethod
    def from_gadget(cls, params):
        sp.run(
            [
                params.yosys,
                "-p",
                f"read_verilog {params.circuit}; chparam -set d {params.nshares}; proc; write_json {params.circ_json}",
            ],
            check=True,
            stdout=sp.DEVNULL,
        )
        with open(params.circ_json, "rb") as f:
            j = json.load(f)
        module = j["modules"][params.module]
        netattr = lambda x, y: module["netnames"][x]["attributes"].get(y)
        sharings = [x for x in module["ports"] if netattr(x, "fv_type") == "sharing"]
        input_sharings = [
            x for x in sharings if module["ports"][x]["direction"] == "input"
        ]
        output_sharings = [
            x for x in sharings if module["ports"][x]["direction"] == "output"
        ]
        clocks = [x for x in module["ports"] if netattr(x, "fv_type") == "clock"]
        assert len(clocks) <= 1
        randoms = [
            (x, len(p["bits"]))
            for x, p in module["ports"].items()
            if netattr(x, "fv_type") == "random"
        ]
        return cls(
            module_name=params.module,
            input_sharings=[
                (x, int(netattr(x, "fv_latency"), 2)) for x in input_sharings
            ],
            output_sharings=output_sharings,
            clk=next(iter(clocks), None),
            rnd=randoms,
            nshares=params.nshares,
        )


def generate_top(gadget):
    lines = []
    inputs = []
    if gadget.clk:
        inputs.append(("clock", gadget.clk, 1))
    for rnd, w in gadget.rnd:
        inputs.append(("refresh", rnd, w))

    for i, (x, lat) in enumerate(
        (x, lat) for x, lat in gadget.input_sharings if not x.endswith("_prev")
    ):
        inputs.extend((f"{i}_{j}", f"{x}{j}", 1) for j in range(gadget.nshares))
    outputs = [
        (f"{i}_{j}", f"{x}{j}", 1)
        for i, x in enumerate(gadget.output_sharings)
        for j in range(gadget.nshares)
    ]
    lines.append("module top(")
    lines.append("    " + ", ".join(x for _, x, _ in inputs + outputs))
    lines.append(");")
    lines.append(f"localparam d = {gadget.nshares};")
    ports = [("input", x) for x in inputs] + [("output", x) for x in outputs]
    for k, (s, x, w) in ports:
        w = f"[{w}-1:0] " if w != 1 else ""
        lines.append(f'(* SILVER="{s}" *) {k} {w}{x};')
    for x, lat in gadget.input_sharings:
        if x.endswith("_prev"):
            lines.append(f'wire [d-1:0] {x}_d0 = {x.removesuffix("_prev")}_d0;')
        else:
            shares = ", ".join(f"{x}{i}" for i in reversed(range(gadget.nshares)))
            lines.append(f"wire [d-1:0] {x}_d0 = {{ {shares} }};")
        for l in range(1, lat + 1):
            lines.append(f"reg [d-1:0] {x}_d{l};")
            lines.append(f"always @(posedge {gadget.clk}) {x}_d{l} <= {x}_d{l-1};")
    for x in gadget.output_sharings:
        lines.append(f"wire [d-1:0] {x};")
        for i in range(gadget.nshares):
            lines.append(f"assign {x}{i} = {x}[{i}];")
    lines.append(f"{gadget.module_name} #(.d(d)) test (")
    ports = []
    if gadget.clk:
        ports.append(f".{gadget.clk}({gadget.clk})")
    for x, _ in gadget.rnd:
        ports.append(f".{x}({x})")
    for x, l in gadget.input_sharings:
        ports.append(f".{x}({x}_d{l})")
    for x in gadget.output_sharings:
        ports.append(f".{x}({x})")
    lines.append("    " + ", ".join(ports))
    lines.append(");")
    lines.append("endmodule")
    return "\n".join(lines)


def synth_for_silver(params):
    silver_lib = params.silver_root / "yosys" / "LIB"
    yosys_instructions = [
        f"read_verilog ../compress/gadget_library/BIN/bin_REG.v",
        f"read_verilog {params.circ_top}",
        f"read_verilog {params.circuit}",
        f'read_verilog -lib {silver_lib/"custom_cells.v"}',
        f"hierarchy -check -libdir ../compress/gadget_library/MSK -top top",
        f"setattr -mod -set keep_hierarchy 0",
        f"setattr -set keep_hierarchy 1",
        f"synth -top top",
        f'dfflibmap -liberty {silver_lib/"custom_cells.lib"}',
        f'abc -liberty {silver_lib/"custom_cells.lib"}',
        f"opt_clean",
        f'stat -liberty {silver_lib/"custom_cells.lib"}',
        f"setattr -set keep_hierarchy 0",
        f"flatten",
        f"select top",
        f"insbuf -buf BUF A Y",
        f"write_verilog -selected {params.circ_synth}",
    ]
    sp.run(
        [params.yosys, "-p", "; ".join(yosys_instructions)],
        check=True,
        stdout=sp.DEVNULL,
    )


def strip_ansi_codes(s):
    return re.sub(r"\x1b\[([0-9,A-Z]{1,2}(;[0-9]{1,2})?(;[0-9]{3})?)?[m|K]?", "", s)


def run_silver(params):
    silver_cmd = [
        str(params.silver_root / "bin" / "verify"),
        "--verbose=1",
        "--verilog=1",
        f"--verilog-design_file={params.circ_synth}",
        "--verilog-module_name=top",
        f"--insfile={params.insfile}",
    ]
    # print(' '.join(silver_cmd))
    silver = sp.run(silver_cmd, check=True, capture_output=True)
    p = re.compile(
        f"^\[[ \.0-9]+\] (?P<prop>\w+).(?P<mode>\w+)\s*\(d ≤ (?P<order>\d+)\) -- (?P<success>\S+)\."
    )
    # print(silver.stdout.decode())
    matches = [
        p.match(l) for l in strip_ansi_codes(silver.stdout.decode()).splitlines()
    ]
    matches = [m for m in matches if m]
    return {
        (m.group("prop"), m.group("mode")): int(m.group("order"))
        if "PASS" in m.group("success")
        else 0
        for m in matches
    }


def check_gadget(params):
    # The module-level attributes are not picked up by yosys.
    with open(params.circuit) as f:
        v = f.read()
    if m := re.search(f'fv_strat\s*=\s*"(\w+)"', v):
        fv_strat = m.group(1)
    else:
        fv_strat = None
    if m := re.search(f'fv_prop\s*=\s*"(\w+)"', v):
        fv_prop = m.group(1)
    else:
        fv_prop = None
    if fv_strat != "assumed" or fv_prop == "_mux":
        return None
    if fv_prop is None:
        raise ValueError("{params.circuit} has no fv_prop attribute.")
    # For the rest, we use yosys to parse and convert to json.
    gadget = Gadget.from_gadget(params)
    top = generate_top(gadget)
    with open(params.circ_top, "w") as f:
        f.write(top + "\n")
    synth_for_silver(params)
    res = run_silver(params)
    return res[(fv_prop, "robust")] == (params.nshares - 1)


def cli():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--circuits",
        required=True,
        type=Path,
        nargs="+",
        help="Input circuit file.",
    )
    parser.add_argument(
        "--work",
        required=True,
        type=Path,
        help="Working directory.",
    )
    parser.add_argument(
        "--yosys",
        default="yosys",
        type=Path,
        help="Path to yosys binary.",
    )
    parser.add_argument(
        "--silver-root", required=True, type=Path, help="Path to SILVER root directory."
    )
    parser.add_argument(
        "--nshares",
        required=True,
        type=int,
        help="Number of shares.",
    )
    return parser


def main():
    args = cli().parse_args()
    fail = 0
    circuits = list(sorted(args.circuits))
    tstart = time.time()
    for circuit in circuits:
        params = Settings(
            circuit=circuit,
            work=args.work,
            yosys=args.yosys,
            silver_root=args.silver_root,
            nshares=args.nshares,
        )
        assert (
            params.circuit.is_file()
        ), f"Circuit file {params.circuit} does not exist."
        params.work.mkdir(exist_ok=True)
        print(
            f"Verification with {params.nshares} shares of {params.circuit}... ",
            end="",
            flush=True,
        )
        t0 = time.time()
        c = check_gadget(params)
        tend = time.time()
        if c is None:
            print("SKIPPED: not fv_start=assumed.")
        else:
            res = "PASS" if c else "FAIL"
            print(f"{res} ({tend-t0:.1f} s).")
            if not c:
                fail += 1

    if fail:
        print(f"=== {fail} gadgets FAILED. ===")
        exit(1)
    tfinish = time.time()
    print(f"=== All gadgets PASSED ({tfinish-tstart:.1f} s). ===")


if __name__ == "__main__":
    main()
