import argparse
import csv
import json
from pathlib import Path

GE = 0.798 # Nangate45


def parse_reports(reports, module):
    for report in reports:
        with open(report) as f:
            l = json.load(f)
        _, nshares = str(report.parent.name).rsplit('_', 1)
        nshares = int(nshares)
        areaum2 = float(l['design']['area'])
        area_ge = areaum2/GE
        rnd_bits =  2 * nshares * (nshares-1) // 2
        area_rnd_ge = 33.1708333 * rnd_bits
        yield {'design': module, 'nshares': nshares, 'area_ge': area_ge, 'area_ge_wrng': area_ge + area_rnd_ge, 'rnd_bits': rnd_bits, 'solve_time': ''}


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
        fields=['design', 'nshares', 'area_ge', 'area_ge_wrng', 'rnd_bits', 'solve_time']
        writer = csv.DictWriter(csvfile, fieldnames=fields)
        writer.writeheader()
        writer.writerows(res)
    

if __name__ == "__main__":
    main()
