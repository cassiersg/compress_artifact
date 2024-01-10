WORK ?= ./work
NUM_SHARES ?= 2
LATENCY ?= 4

HDL_ROOT_DIR=../hdl

TB_TARGET?=tb_mskaes
TB_DIR=../tb
TB_FILE=$(TB_DIR)/$(TB_TARGET).v

GATHER_ENV=OUT_DIR=$(WORK)/hdl NUM_SHARES=$(NUM_SHARES) LATENCY=$(LATENCY)
IVERILOG_DEFINES= -D DUMPFILE=\"$(WORK)/log-$(TB_TARGET).vcd\" -D LATENCY=$(LATENCY) -D SHARES=$(NUM_SHARES)
IVERILOG_DEFINES+= -D DEFAULTRND=1 -D behavioral
ifeq ($(CANRIGHT),1)
	GATHER_ENV+= GATHER_CANRIGHT_SBOX=1 
	IVERILOG_DEFINES+= -D CANRIGHT_SBOX
endif

simu: ${TVIN} simu-build
	vvp $(WORK)/simu-exec-$(TB_TARGET)

simu-build:
	mkdir -p $(WORK)
	$(GATHER_ENV) $(HDL_ROOT_DIR)/gather_sources.sh
	cp $(TB_DIR)/* $(WORK)/hdl 
	iverilog \
	    -y $(WORK)/hdl \
	    -I $(WORK)/hdl \
	    $(IVERILOG_DEFINES) \
	    $(TB_FILE) \
	    -o $(WORK)/simu-exec-$(TB_TARGET) \
		-Pd=$(NUM_SHARES)

clean:
	-rm -r $(WORK)

wave: log.vcd wave.gtkw
	gtkwave $(WORK)/log-$(TB_TARGET).vcd waves-$(TB_TARGET).gtkw

.PHONY: simu wave simu-build clean
