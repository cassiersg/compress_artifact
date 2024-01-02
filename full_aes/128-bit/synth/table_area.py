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
        'aeshpc': 'Handcrafting (128-bit)',
        'new': 'This work (128-bit)',
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
        r = re.search(r"(\w+)-d(\d+)-L(\d+)\.yosys-area\.json", str(f))
        design = r.group(1)
        shares = int(r.group(2))
        lat = int(r.group(3))
        res.append((design, shares, lat, area))
    return res 

def sblat2aeslat(lat):
    return 10*(lat+1)+1


def write_csv(csvfile,results_data):
    fields = ["Design","NumShares","Latency","Area GE"]
    with open(csvfile, 'w') as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        for design, shares, lat, area in sorted(results_data):
            lat = sblat2aeslat(lat)
            writer.writerow({"Design": design, "NumShares": shares, "Latency": lat, "Area GE": area})


def write_latex(latexfile, results_data):
    res = defaultdict(lambda: defaultdict(dict))
    for design, shares, lat, area in results_data:
        res[design][lat][shares] = area
    all_rows = []
    for i, (design, res_d) in enumerate(sorted(res.items())):
        rows_d = []
        for lat, res_lat in sorted(res_d.items()):
            rows_lat = [f'{shares} & {area/1e3} \\\\'  for shares, area in sorted(res_lat.items())]
            rows_d.extend(
                    f'\\multirow{{{len(rows_lat)}}}{{*}}{{{sblat2aeslat(lat)}}} & {row}' if i == 0 else f' & {row}'
                    for i, row in enumerate(rows_lat)
                    )
        all_rows.extend(
                f'\\multirow{{{len(rows_d)}}}{{*}}{{{NAME_MAP[design]}}} & {row}' if i == 0 else f' & {row}'
                for i, row in enumerate(rows_d)
                )
        if i < len(res)-1:
            all_rows.append(r'\addlinespace[1.2ex]')
    s = latex_template.substitute({
        'rows': '\n'.join(all_rows)
        })
    with open(latexfile, 'w') as f:
        f.write(s)

def cli():
    parser = argparse.ArgumentParser()
    parser.add_argument("--results-dir", type=Path)
    parser.add_argument("--outcsv")
    parser.add_argument("--outlatex")
    return parser


def main():
    args = cli().parse_args()
    rd = get_results_data(args.results_dir)
    write_csv(args.outcsv, rd)
    write_latex(args.outlatex, rd)

if __name__ == "__main__":
    main()
