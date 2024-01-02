
WORK ?= ./work
NUM_SHARES ?= 2
LATENCY = 4

WORK_DIR=$(WORK)/hdl_d$(NUM_SHARES)_L$(LATENCY)
AESHPC128_WORK_DIR=$(WORK)/aeshpc_hdl_d$(NUM_SHARES)

HDL_ROOT_DIR=../hdl
AESHPC128_HDL_ROOT_DIR=../aeshpc128_src
GADGETS_SRC = ../../../compress/gadget_library/BIN/ \
		../../../compress/gadget_library/MSK/ \
		../../../compress/gadget_library/RNG/


aeshpc_synth:
	mkdir -p $(AESHPC128_WORK_DIR)
	OUT_DIR=$(AESHPC128_WORK_DIR) $(AESHPC128_HDL_ROOT_DIR)/gather_sources.sh $(AESHPC128_HDL_ROOT_DIR) $(GADGETS_SRC)
	WORK=$(WORK) SYNTH_NAME=aeshpc-d$(NUM_SHARES)-L4 SRC_DIR=$(AESHPC128_WORK_DIR) NUM_SHARES=$(NUM_SHARES) yosys -c synth.tcl -l $(AESHPC128_WORK_DIR)/synth.log

synth:
	mkdir -p $(WORK_DIR)
	NUM_SHARES=$(NUM_SHARES) LATENCY=$(LATENCY) OUT_DIR=$(WORK_DIR) $(HDL_ROOT_DIR)/gather_sources.sh
	WORK=$(WORK) SYNTH_NAME=new-d$(NUM_SHARES)-L$(LATENCY) SRC_DIR=$(WORK_DIR) LATENCY=$(LATENCY) NUM_SHARES=$(NUM_SHARES) yosys -c synth.tcl -l $(WORK_DIR)/synth.log

all_synth:
	for nshares in 2 3 4 5; do make -C . NUM_SHARES=$$nshares synth; done
	for nshares in 2 3 4 5; do make -C . NUM_SHARES=$$nshares aeshpc_synth; done

report: all_synth
	python table_area.py --results-dir $(WORK) --outcsv $(WORK)/areas.csv --outlatex $(WORK)/areas_full_aes.tex


clean:
	-rm -r $(WORK) 


.PHONY: clean synth all_synth report
