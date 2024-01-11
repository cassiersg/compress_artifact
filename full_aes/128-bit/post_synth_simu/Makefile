WORK ?= ./work
SYNTH_WORK ?= ../synth/work
NUM_SHARES ?= 2
LATENCY ?= 4

HDL_ROOT_DIR=../hdl

TB_TARGET?=tb_mskaes
TB_DIR=../tb
TB_FILE=$(TB_DIR)/$(TB_TARGET).v

DESIGN_FILE=$(WORK)/design.v
LIBRARY_VERILOG=../../../compress/synthesis/stdcells.v

IVERILOG_DEFINES=-D DEFAULTSHARES=$(NUM_SHARES) -D DUMPFILE=\"$(WORK)/log-$(TB_TARGET).vcd\" -D LATENCY=$(LATENCY)
IVERILOG_DEFINES+= -D DEFAULTRND=1
ifeq ($(CANRIGHT),1)
    TOP=newcanright
    IVERILOG_DEFINES += -D CANRIGHT_SBOX
else
    TOP=new
endif

simu: simu-build
	vvp $(WORK)/simu-exec-$(TB_TARGET)

wave:
	gtkwave $(WORK)/log-$(TB_TARGET).vcd waves-$(TB_TARGET).gtkw

simu-build:
	mkdir -p $(WORK)
	cp $(SYNTH_WORK)/$(TOP)-d$(NUM_SHARES)-L$(LATENCY).yosys.v $(DESIGN_FILE)
	iverilog \
	    -y $(TB_DIR) \
	    -I $(TB_DIR) \
	    -I $(WORK)/hdl \
	    $(IVERILOG_DEFINES) \
	    $(TB_FILE) $(DESIGN_FILE) $(LIBRARY_VERILOG) ../../../compress/gadget_library/MSK/MSKcst.v \
	    -o $(WORK)/simu-exec-$(TB_TARGET) \
	    -D DEFAULTRND=1 \
            -D SHARES=$(NUM_SHARES)

clean:
	-rm -r $(WORK) 

.PHONY: simu wave simu-build clean
