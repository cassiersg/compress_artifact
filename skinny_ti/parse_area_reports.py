from pathlib import Path
import json



def parse_yosys_area(path_report,GE_area=0.798):
    # Load json 
    with open(path_report) as f:
        data = json.load(f)
    # Recover area from design
    area = data["design"]["area"]
    corrected = area / GE_area
    return corrected


if __name__ == "__main__":
    work = "../work/skinny_ti"
    dirs = [
            "skinny-hdl-thresh-222",
            "skinny-hdl-thresh-232",
            "skinny-hdl-thresh-2222",
            "skinny-hdl-thresh-33"
            ]

    for d in dirs:
        # path
        path = "{}/{}/area.json".format(work,d)
        area = parse_yosys_area(path)
        print("{}: {:.2f}".format(d,round(area/(1000*16),2)))
