
WORK ?= work
CIRCUIT ?=../compress/circuits/aes_bp.txt
DS=1 2 3 4

MODULE_NAME=$(basename $(notdir $(CIRCUIT)))
SRC_VERILOG=$(WORK)/$(MODULE_NAME).v
AREA_REPORT = $(WORK)/$(MODULE_NAME)_areas.csv

.PHONY: all clean

all: $(AREA_REPORT)


define synth_module
$(MODULE_NAME)_HPC3_Pipeline_d$(1)
endef

define synth_dir
$(WORK)/synth_d$(1)
endef

define area_json
$(call synth_dir,$(1))/area.json
endef

define synth_verilog
$(call synth_dir,$(1))/$(call synth_module,$(1)).v
endef

define rules_order
$(call synth_verilog,$(1)): $(SRC_VERILOG)
	mkdir -p $(call synth_dir,$(1))
	cp $(SRC_VERILOG) $(call synth_dir,$(1))/$(MODULE_NAME).v
	$(AGEMA_ROOT)/bin/release/AGEMA -lf $(AGEMA_ROOT)/cell/Library.txt -df $(call synth_dir,$(1))/$(MODULE_NAME).v -mn $(MODULE_NAME) -mt naive -sc HPC3 -so $(1)

$(call area_json,$(1)): $(call synth_verilog,$(1))
	RESDIR=$(call synth_dir,$(1)) \
		SYNTH_TOP=$(call synth_module,$(1)) \
		SYNTH_SRCS="$(call synth_verilog,$(1)) `find verilog_hpc3/ -iname '*.v'`" \
		SYNTH_LIB=stdcells.lib \
		VDEFINES= \
		VINCLUDE=verilog_hpc3 \
		yosys -c synth.tcl
endef

$(foreach D,$(DS),$(eval $(call rules_order,$D)))
ALL_AREAS=$(foreach D,$(DS),$(call area_json,$D))

$(SRC_VERILOG): $(CIRCUIT)
	mkdir -p $(dir $@)
	python3 circ2v.py --circuit $< --out $@

$(AREA_REPORT): $(ALL_AREAS) | summarize_areas.py
	python3 summarize_areas.py --outcsv=$@ $^

clean:
	-rm -r $(WORK) / 2> /dev/null
