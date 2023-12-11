import argparse
import csv
import json
from pathlib import Path

GE = 0.798 # Nangate45


def parse_reports(reports, module):
    for report in reports:
        with open(report) as f:
            l = json.load(f)
        _, order = str(report.parent.name).rsplit('_', 1)
        order = int(order[1:])
        areaum2 = float(l['design']['area'])
        area_ge = areaum2/GE
        rnd_bits = 34 * order * (order+1) # 34 HPC3 gadgets
        area_rnd_ge = 33.1708333 * rnd_bits # constant manually copied
        yield {
                'design': module,
                'nshares': order+1,
                'area_ge': area_ge,
                'area_ge_wrng': area_ge + area_rnd_ge,
                'solve_time': '',
                'rnd_bits': rnd_bits,
            }


def cli():
    parser = argparse.ArgumentParser()
    parser.add_argument("--outcsv")
    parser.add_argument("--module")
    parser.add_argument("reports", type=Path, metavar='report', nargs='+')
    return parser


def main():
    args = cli().parse_args()
    res = list(parse_reports(args.reports, args.module))
    with open(args.outcsv, 'w') as csvfile:
        fields=['design', 'nshares', 'area_ge', 'area_ge_wrng', 'solve_time', 'rnd_bits']
        writer = csv.DictWriter(csvfile, fieldnames=fields)
        writer.writeheader()
        writer.writerows(res)
    

if __name__ == "__main__":
    main()
