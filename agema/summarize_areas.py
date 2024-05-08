"""
Parse .json area reports from Yosys and summarize them in a CSV, estimating the
area used by a Trivium PRNG to generate the required randomness.
"""
import argparse
import csv
import re
import json
from pathlib import Path

GE = 0.798  # um^2, for Nangate45
# From syntheses of Trivium (work/aes_opt/rng_area/area_ge.txt).
AREA_RND_GE = 39.3606770833333


def parse_reports(reports, module):
    for report in reports:
        report_dir = report.parent
        with open(report) as f:
            l = json.load(f)
        _, hpc, order = str(report_dir.name).rsplit("_", 2)
        order = int(order[1:])
        areaum2 = float(l["design"]["area"])
        area_ge = areaum2 / GE
        with open(report_dir / f"{module}_{hpc}_Pipeline_d{order}.v") as f:
            verilog = f.read()
        latency = int(
            re.search(r"the circuit has (\d+) register stage", verilog).group(1)
        )
        rnd_bits = int(re.search(r"input \[(\d+):0\] Fresh ;", verilog).group(1)) + 1
        area_rnd_ge = (
            AREA_RND_GE * rnd_bits
        )  # RNG bit-area copied from synthesis results
        yield {
            "design": f"{module}_{hpc}",
            "nshares": order + 1,
            "latency": latency,
            "area_ge": area_ge,
            "area_ge_wrng": area_ge + area_rnd_ge,
            "solve_time": "",
            "rnd_bits": rnd_bits,
        }


def cli():
    parser = argparse.ArgumentParser()
    parser.add_argument("--outcsv")
    parser.add_argument("--module")
    parser.add_argument("reports", type=Path, metavar="report", nargs="+")
    return parser


def main():
    args = cli().parse_args()
    res = list(parse_reports(args.reports, args.module))
    with open(args.outcsv, "w") as csvfile:
        fields = [
            "design",
            "nshares",
            "latency",
            "area_ge",
            "area_ge_wrng",
            "solve_time",
            "rnd_bits",
        ]
        writer = csv.DictWriter(csvfile, fieldnames=fields)
        writer.writeheader()
        writer.writerows(res)


if __name__ == "__main__":
    main()
