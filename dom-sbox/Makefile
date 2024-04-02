NSHARES ?= 2

WORK ?= work
WORKDIR = $(WORK)/aes-sbox-dom
CASE_DIR= $(WORKDIR)/d${NSHARES}
HDL_DIR = $(CASE_DIR)/hdl

MODULE_NAME = aes_sbox
SCRIPT_SYNTH = synth.tcl

SYNTH_SRCS = $(shell ls $(HDL_DIR)/*.v)
VDEFINES=""
VINCLUDE="$(HDL_DIR)"
SYNTH_TOP=$(MODULE_NAME)
SYNTH_LIB ?=../compress/synthesis/stdcells.lib
RESDIR=$(CASE_DIR)/area

$(RESDIR): 
	if [ -d $(RESDIR) ]; then echo "$(RESDIR) already exists"; else mkdir -p $(RESDIR); fi

$(HDL_DIR):
	WORK=$(WORKDIR) NSHARES=$(NSHARES) bash gen_verilog.sh

area: $(RESDIR) $(HDL_DIR)
	SYNTH_SRCS="$(SYNTH_SRCS)" VDEFINES=$(VDEFINES) VINCLUDE=$(VINCLUDE) SYNTH_TOP=$(SYNTH_TOP) SYNTH_LIB=$(SYNTH_LIB) RESDIR=$(RESDIR) yosys -c $(SCRIPT_SYNTH)	

clean:
	if [ -d $(WORKDIR) ]; then rm -r $(WORKDIR); fi
