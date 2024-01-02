WORK ?= ./work
NUM_SHARES ?= 2
LATENCY ?= 4

HDL_ROOT_DIR=../hdl

TB_TARGET?=tb_mskaes
TB_DIR=../tb
TB_FILE=$(TB_DIR)/$(TB_TARGET).v


simu: simu-build
	vvp $(WORK)/simu-exec-$(TB_TARGET)
	grep -q -s SUCCESS $(WORK)/res_$(NUM_SHARES).log || exit 1

wave: log.vcd wave.gtkw
	gtkwave $(WORK)/log-$(TB_TARGET).vcd waves-$(TB_TARGET).gtkw

simu-build:
	mkdir -p $(WORK) 
	NUM_SHARES=$(NUM_SHARES) LATENCY=$(LATENCY) OUT_DIR=$(WORK)/hdl $(HDL_ROOT_DIR)/gather_sources.sh
	cp $(TB_DIR)/* $(WORK)/hdl
	iverilog \
	    -y $(WORK)/hdl \
	    -I $(WORK)/hdl \
	    -D VCD_PATH=\"$(WORK)/log-$(TB_TARGET).vcd\" \
	    -D RES_FILE=\"$(WORK)/res_$(NUM_SHARES).log\" \
	    -D behavioral \
	    $(TB_FILE) \
	    -o $(WORK)/simu-exec-$(TB_TARGET) \
		-Pd=$(NUM_SHARES) \
	    -D DEFAULTRND=1 \
	    -D SHARES=$(NUM_SHARES)

clean:
	-rm -r $(WORK) 

.PHONY: simu wave simu-build clean
