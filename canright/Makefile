
WORK ?= work
MODULE_NAME ?= canright
YOSYS_NETLIST ?= $(WORK)/$(MODULE_NAME).json
CIRCUIT=$(WORK)/$(MODULE_NAME).txt
LATS ?= 4 5 6
DS ?= 1 2 3 4

AREA_REPORT = $(WORK)/$(MODULE_NAME)_area.csv

.PHONY: all clean area

all: $(AREA_REPORT)

clean:
	-rm -r $(WORK) / 2> /dev/null

FILE_IN=canright_aes_sbox_trivial_from_c.v
$(YOSYS_NETLIST): $(FILE_IN) build-json-yosys.tcl 
	mkdir -p $(WORK)
	FILE_IN=$(FILE_IN) YOSYS_NETLIST=$(YOSYS_NETLIST) yosys -c build-json-yosys.tcl

$(CIRCUIT): $(YOSYS_NETLIST) json2compress.py
	python json2compress.py \
	    --netlist-file $(YOSYS_NETLIST) \
	    --top Sbox \
	    --compress-file $(CIRCUIT)

$(AREA_REPORT): $(CIRCUIT)
	make -C ../compress CIRCUIT=$(CIRCUIT) LATS="$(LATS)" DS="$(DS)" WORK=$(WORK) area

area: $(AREA_REPORT)
