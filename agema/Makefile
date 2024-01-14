
WORK ?= work
CIRCUIT ?=../compress/circuits/aes_bp.txt
DS=1 2 3 4

MODULE_NAME=$(basename $(notdir $(CIRCUIT)))
SRC_VERILOG=$(WORK)/$(MODULE_NAME).v
AREA_REPORT = $(WORK)/$(MODULE_NAME)_area.csv

.PHONY: all clean

all: $(AREA_REPORT)


define synth_module
$(MODULE_NAME)_$(2)_Pipeline_d$(1)
endef

define synth_dir
$(WORK)/synth_$(2)_d$(1)
endef

define area_json
$(call synth_dir,$(1),$(2))/area.json
endef

define synth_verilog
$(call synth_dir,$(1),$(2))/$(call synth_module,$(1),$(2)).v
endef

define rules_order
$(call synth_verilog,$(1),$(2)): $(SRC_VERILOG)
	mkdir -p $(call synth_dir,$(1),$(2))
	cp $(SRC_VERILOG) $(call synth_dir,$(1),$(2))/$(MODULE_NAME).v
	$(AGEMA_ROOT)/bin/release/AGEMA -lf $(AGEMA_ROOT)/cell/Library.txt -df $(call synth_dir,$(1),$(2))/$(MODULE_NAME).v -mn $(MODULE_NAME) -mt naive -sc $(2) -so $(1)

$(call area_json,$(1),$(2)): $(call synth_verilog,$(1),$(2))
	RESDIR=$(call synth_dir,$(1),$(2)) \
		SYNTH_TOP=$(call synth_module,$(1),$(2)) \
		SYNTH_SRCS="$(call synth_verilog,$(1),$(2)) `find agema_gadgets_verilog/ -iname '*.v'`" \
		SYNTH_LIB=stdcells.lib \
		VDEFINES= \
		VINCLUDE=agema_gadgets_verilog \
		yosys -q -c synth.tcl
endef

HPCS=HPC2 HPC3
$(foreach H,$(HPCS),$(foreach D,$(DS),$(eval $(call rules_order,$D,$H))))
ALL_AREAS=$(foreach H,$(HPCS),$(foreach D,$(DS),$(call area_json,$D,$H)))

$(SRC_VERILOG): $(CIRCUIT)
	mkdir -p $(dir $@)
	python3 ../compress/scripts/circ2v.py --circuit $< --out $@

$(AREA_REPORT): $(ALL_AREAS) | summarize_areas.py
	python3 summarize_areas.py --module $(MODULE_NAME) --outcsv=$@ $^

clean:
	-rm -r $(WORK) / 2> /dev/null
