import argparse
import csv
import json
from pathlib import Path

GE = 0.798 # Nangate45


def parse_reports(reports):
    for report in reports:
        with open(report) as f:
            l = json.load(f)
        _, order = str(report.parent.name).rsplit('_', 1)
        module = "agema_aes_bp_sbox"
        order = int(order[1:])
        areaum2 = float(l['design']['area'])
        area_ge = areaum2/GE
        area_rnd_ge = 33.1708333 * 34 * order * (order+1)
        yield {'design': module, 'nshares': order+1, 'area_ge': area_ge, 'area_ge_wrnd': area_ge + area_rnd_ge}


def cli():
    parser = argparse.ArgumentParser()
    parser.add_argument("--outcsv")
    parser.add_argument("reports", type=Path, metavar='report', nargs='+')
    return parser


def main():
    args = cli().parse_args()
    res = list(parse_reports(args.reports))
    with open(args.outcsv, 'w') as csvfile:
        fields=['design', 'nshares', 'area_ge', 'area_ge_wrnd']
        writer = csv.DictWriter(csvfile, fieldnames=fields)
        writer.writeheader()
        writer.writerows(res)
    

if __name__ == "__main__":
    main()
