WORK ?= work
MODULE_NAME ?= AESSbox_2OM
SCRIPT_SYNTH ?= synth.tcl

SYNTH_SRCS=$(shell ls ./*.v)
VDEFINES=""
VINCLUDE="."
SYNTH_TOP=$(MODULE_NAME)
SYNTH_LIB ?= ../compress/synthesis/stdcells.lib
RESDIR=$(WORK)/area


.PHONY: simu clean

$(RESDIR): 
	if [ -d $(RESDIR) ]; then echo "$(RESDIR) already exists"; else mkdir -p $(RESDIR); fi

all: simu

Round.v: Round.vhd
	bash vhd2verilog-ghdl.sh Round.vhd Round Round.v

Cipher.v: Cipher.vhd
	bash vhd2verilog-ghdl.sh Cipher.vhd Cipher Cipher.v

simu-exec: Round.v Cipher.v
	iverilog tb/AESCipher_tb.v -y . -o simu-exec

simu: simu-exec
	vvp simu-exec

echo:
	echo $(SYNTH_SRCS)

area: $(RESDIR)
	SYNTH_SRCS="$(SYNTH_SRCS)" VDEFINES=$(VDEFINES) VINCLUDE=$(VINCLUDE) SYNTH_TOP=$(SYNTH_TOP) SYNTH_LIB=$(SYNTH_LIB) RESDIR=$(RESDIR) yosys -c $(SCRIPT_SYNTH)	


clean:
	if [ -e simu-exec ]; then rm simu-exec; fi
	if [ -e Round.v ]; then rm Round.v; fi
	if [ -e Cipher.v ]; then rm Cipher.v; fi
	if [ -e work-obj93.cf ]; then rm work-obj93.cf; fi
