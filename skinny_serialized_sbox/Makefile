
WORK ?= ./work

DS ?= 2 3 4

SYNTH_SCRIPT=synth.tcl
AREA_REPORT = $(WORK)/areas.csv

SYNTH_SRCS=../compress/gadget_library/BIN/*.v ../compress/gadget_library/MSK/*.v
export VINCLUDE=../compress/gadget_library/MSK
export SYNTH_LIB=../compress/synthesis/stdcells.lib

define area
$(WORK)/d_$(1)/area.json
endef

define synth
$(call area,$(1)): skinny_masked_sbox_iterative.v
	mkdir -p $$(dir $$@)
	SYNTH_SRCS="$(SYNTH_SRCS) $$<" SYNTH_TOP=MSKsbox VDEFINES="-DDEFAULTSHARES=$(1)" \
	RESDIR=$$(dir $$@) \
	yosys -q -c $(SYNTH_SCRIPT) -l  $$(dir $$@)/synth.log
endef

all: $(AREA_REPORT)

$(foreach D,$(DS),$(eval $(call synth,$D)))
ALL_AREAS=$(foreach D,$(DS),$(call area,$D))


$(AREA_REPORT): $(ALL_AREAS) | summarize_areas.py
	python3 summarize_areas.py --module skinny_sbox_serialized --outcsv=$@ $^

.PHONY: all

