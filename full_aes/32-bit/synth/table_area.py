import argparse
from collections import defaultdict
from enum import Enum
from pathlib import Path
from string import Template
import json
import re
import csv

GE_area = 0.798

NAME_MAP = {
        'smaesh': 'Handcrafting (32-bit)',
        'new': 'This work (32-bit)',
        }

latex_template=Template(r"""
\begin{tabular}{lccS[table-alignment-mode=format,table-format=3.1,round-mode=places,round-precision=1]}
\toprule
{Design} & {Latency} & {\nshares} & {Area (kGE)} \\ \midrule
$rows
\bottomrule
\end{tabular}
""")



def parse_report(fname):
    with open(fname, 'r') as f:
        j = json.load(f)
    return float(j["design"]["area"]) / GE_area


def get_results_data(results_dir):
    globstr = f'*.yosys-area.json'
    res = []
    for f in results_dir.glob(globstr):
        area = parse_report(f)
        r = re.search(r"([\w\d]+)-d(\d+)-L(\d+)\.yosys-area\.json", str(f))
        design = r.group(1)
        shares = int(r.group(2))
        lat = int(r.group(3))
        res.append((design, shares, lat, area))
    return res 

def sblat2aeslat(lat):
    return 44+10*lat


def write_csv(csvfile,results_data):
    fields = ["Design","NumShares","Latency","Area GE"]
    with open(csvfile, 'w') as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        for design, shares, lat, area in sorted(results_data):
            lat = sblat2aeslat(lat)
            writer.writerow({"Design": design, "NumShares": shares, "Latency": lat, "Area GE": area})


def cli():
    parser = argparse.ArgumentParser()
    parser.add_argument("--results-dir", type=Path)
    parser.add_argument("--outcsv")
    return parser


def main():
    args = cli().parse_args()
    rd = get_results_data(args.results_dir)
    write_csv(args.outcsv, rd)

if __name__ == "__main__":
    main()
