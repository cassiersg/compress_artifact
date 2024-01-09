
WORK ?= ./work
NUM_SHARES ?= 2
LATENCY = 4

WORK_DIR=$(WORK)/hdl_d$(NUM_SHARES)_L$(LATENCY)
SMAESH_WORK_DIR=$(WORK)/smaesh_hdl_d$(NUM_SHARES)
WORK_CANRIGHT=$(WORK)/aes_canright_d$(NUM_SHARES)_L$(LATENCY)

HDL_ROOT_DIR=../hdl/
SMAESH_HDL_ROOT_DIR=../smaesh_hdl/


smaesh_synth:
	mkdir -p $(SMAESH_WORK_DIR)
	OUT_DIR=$(SMAESH_WORK_DIR) $(SMAESH_HDL_ROOT_DIR)/gather_sources.sh $(SMAESH_HDL_ROOT_DIR)
	VINCLUDE=$(SMAESH_WORK_DIR) VDEFINES="-DDEFAULTSHARES=$(NUM_SHARES)" TOP=aes_enc128_32bits_hpc2 WORK=$(WORK) SYNTH_NAME=smaesh-d$(NUM_SHARES)-L6 SRC_DIR=$(SMAESH_WORK_DIR) NUM_SHARES=$(NUM_SHARES) LATENCY=6 yosys -q -c synth.tcl -l $(WORK)/smaesh_synth.log

synth_canright:
	mkdir -p $(WORK_CANRIGHT)
	OUT_DIR=$(WORK_CANRIGHT) GATHER_CANRIGHT_SBOX=1 LATENCY=$(LATENCY) $(HDL_ROOT_DIR)/gather_sources.sh  
	VINCLUDE=$(WORK_CANRIGHT) VDEFINES="-DDEFAULTSHARES=$(NUM_SHARES) -DCANRIGHT_SBOX=1" TOP=aes_enc128_32bits_hpc WORK=$(WORK) SYNTH_NAME=newcanright-d$(NUM_SHARES)-L$(LATENCY) SRC_DIR=$(WORK_CANRIGHT) LATENCY=$(LATENCY) NUM_SHARES=$(NUM_SHARES) yosys -q -c synth.tcl -l $(WORK)/newcanright_synth.log


synth:
	mkdir -p $(WORK)
	mkdir -p $(WORK_DIR)
	NUM_SHARES=$(NUM_SHARES) LATENCY=$(LATENCY) OUT_DIR=$(WORK_DIR) $(HDL_ROOT_DIR)/gather_sources.sh
	VINCLUDE=$(WORK_DIR) VDEFINES="-DDEFAULTSHARES=$(NUM_SHARES)" TOP=aes_enc128_32bits_hpc WORK=$(WORK) SYNTH_NAME=new-d$(NUM_SHARES)-L$(LATENCY) SRC_DIR=$(WORK_DIR) LATENCY=$(LATENCY) NUM_SHARES=$(NUM_SHARES) yosys -q -c synth.tcl -l $(WORK)/synth.log

all_synth:
	for nshares in 2 3 4 5; do make -C . NUM_SHARES=$$nshares synth; done
	for nshares in 2 3 4 5; do make -C . NUM_SHARES=$$nshares smaesh_synth; done
	for nshares in 2 3 4 5; do make -C . NUM_SHARES=$$nshares synth_canright; done

report: all_synth
	python table_area.py --results-dir $(WORK) --outcsv $(WORK)/areas.csv

clean:
	-rm -r $(WORK)

.PHONY: clean smaesh_synth synth all_synth report
