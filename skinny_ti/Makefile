
WORK ?= work

SYNTH_LIB ?=../compress/synthesis/nangate45-pdk/stdcells.lib

IMPLEMS=$(addprefix skinny-hdl-thresh-,2222 222 232 33)
WIMPLEMS=$(addprefix $(WORK)/,$(IMPLEMS))
VERILOGS=$(addsuffix /skinny_sbox.v,$(WIMPLEMS))
AREAS=$(addsuffix /area.json,$(WIMPLEMS))


all: $(AREAS)

$(VERILOGS): $(WORK)/%/skinny_sbox.v: gen_verilog.sh
	mkdir -p $(WORK)/$*
	CASE=$* WORK=$(WORK) bash gen_verilog.sh


$(AREAS): $(WORK)/%/area.json: $(WORK)/%/skinny_sbox.v synth.tcl
	SYNTH_SRCS="$<" SYNTH_TOP=substitution SYNTH_LIB=$(SYNTH_LIB) RESDIR=$(WORK)/$* yosys -c synth.tcl

clean:
	rm -rf $(WORK)
