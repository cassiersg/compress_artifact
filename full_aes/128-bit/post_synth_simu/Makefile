WORK ?= ./work
NUM_SHARES ?= 2
LATENCY ?= 4

HDL_ROOT_DIR=../hdl

TB_TARGET?=tb_mskaes
TB_DIR=../tb
TB_FILE=$(TB_DIR)/$(TB_TARGET).v

DESIGN_FILE=$(WORK)/design.v
LIBRARY_VERILOG=../../../compress/synthesis/stdcells.v

IVERILOG_DEFINES= -D DUMPFILE=\"$(WORK)/log-$(TB_TARGET).vcd\" -D LATENCY=$(LATENCY) -D SHARES=$(NUM_SHARES)
IVERILOG_DEFINES+= -D DEFAULTRND=1
ifeq ($(CANRIGHT),1)
endif

simu: simu-build
	vvp $(WORK)/simu-exec-$(TB_TARGET)
	grep -q -s SUCCESS $(WORK)/res_$(NUM_SHARES).log || exit 1

wave:
	gtkwave $(WORK)/log-$(TB_TARGET).vcd waves-$(TB_TARGET).gtkw

simu-build:
	mkdir -p $(WORK) 
	cp $(SYNTH_WORK)/new-d$(NUM_SHARES)-L$(LATENCY).yosys.v $(DESIGN_FILE)
	NUM_SHARES=$(NUM_SHARES) LATENCY=$(LATENCY) OUT_DIR=$(WORK)/hdl $(HDL_ROOT_DIR)/gather_sources.sh
	cp $(TB_DIR)/* $(WORK)/hdl
	iverilog \
	    -y $(TB_DIR) \
	    -I $(TB_DIR) \
	    -I $(WORK)/hdl \
	    -D VCD_PATH=\"$(WORK)/log-$(TB_TARGET).vcd\" \
	    -D RES_FILE=\"$(WORK)/res_$(NUM_SHARES).log\" \
	    $(TB_FILE) $(DESIGN_FILE) $(LIBRARY_VERILOG) ../../../compress/gadget_library/MSK/MSKcst.v \
	    -o $(WORK)/simu-exec-$(TB_TARGET) \
	    -D DEFAULTRND=1 \
	    -D SHARES=$(NUM_SHARES)

clean:
	-rm -r $(WORK) 

.PHONY: simu wave simu-build clean
