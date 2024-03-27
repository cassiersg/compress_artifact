WORK ?= work
MODULE_NAME ?= AESSbox_2OM
SCRIPT_SYNTH ?= synth.tcl

SYNTH_SRCS=$(shell ls ./*.v)
VDEFINES=""
VINCLUDE="."
SYNTH_TOP=$(MODULE_NAME)
SYNTH_LIB ?= ../compress/synthesis/stdcells.lib
RESDIR=$(WORK)/area

$(RESDIR): 
	if [ -d $(RESDIR) ]; then echo "$(RESDIR) already exists"; else mkdir -p $(RESDIR); fi

area: $(RESDIR)
	SYNTH_SRCS="$(SYNTH_SRCS)" VDEFINES=$(VDEFINES) VINCLUDE=$(VINCLUDE) SYNTH_TOP=$(SYNTH_TOP) SYNTH_LIB=$(SYNTH_LIB) RESDIR=$(RESDIR) yosys -c $(SCRIPT_SYNTH)	

