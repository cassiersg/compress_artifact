
WORK ?= ./work
NUM_SHARES ?= 2
LATENCY = 4

WORK_DIR=$(WORK)/hdl_d$(NUM_SHARES)_L$(LATENCY)
SMAESH_WORK_DIR=$(WORK)/smaesh_hdl_d$(NUM_SHARES)

HDL_ROOT_DIR=../hdl/
SMAESH_HDL_ROOT_DIR=../smaesh_hdl/

smaesh_synth:
	mkdir -p $(SMAESH_WORK_DIR)
	OUT_DIR=$(SMAESH_WORK_DIR) $(SMAESH_HDL_ROOT_DIR)/gather_sources.sh $(SMAESH_HDL_ROOT_DIR)
	WORK=$(WORK) SYNTH_NAME=smaesh-d$(NUM_SHARES)-L6 SRC_DIR=$(SMAESH_WORK_DIR) NUM_SHARES=$(NUM_SHARES) LATENCY=6 yosys -c synth.tcl -l $(WORK)/smaesh_synth.log

synth:
	mkdir -p work/
	mkdir -p $(WORK_DIR)
	NUM_SHARES=$(NUM_SHARES) LATENCY=$(LATENCY) OUT_DIR=$(WORK_DIR) $(HDL_ROOT_DIR)/gather_sources.sh
	WORK=$(WORK) SYNTH_NAME=new-d$(NUM_SHARES)-L$(LATENCY) SRC_DIR=$(WORK_DIR) LATENCY=$(LATENCY) NUM_SHARES=$(NUM_SHARES) yosys -c synth.tcl -l $(WORK)/synth.log

all_synth:
	for nshares in 2 3 4 5; do make -C . NUM_SHARES=$$nshares synth; done
	for nshares in 2 3 4 5; do make -C . NUM_SHARES=$$nshares smaesh_synth; done

report: all_synth
	python table_area.py --results-dir $(WORK) --outcsv $(WORK)/areas.csv --outlatex $(WORK)/areas_full_aes.tex

clean:
	-rm -r $(WORK)

.PHONY: clean smaesh_synth synth all_synth report
