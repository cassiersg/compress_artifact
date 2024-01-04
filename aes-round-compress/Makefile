
WORK ?= work
MODULE_NAME ?= aes_round_compress
YOSYS_NETLIST ?= $(WORK)/$(MODULE_NAME).json
CIRCUIT=$(WORK)/$(MODULE_NAME).txt
LATS ?= 4
DS ?= 1 2 3 4

AREA_REPORT = $(WORK)/$(MODULE_NAME)_area.csv

.PHONY: all clean area

all: $(AREA_REPORT)

clean:
	-rm -r $(WORK) / 2> /dev/null

FILE_IN=$(WORK)/aes_round_single_file.v
TOP_MOD=aes_round_umsk

$(FILE_IN): hdl/sbox_bp_umsk.v hdl/SR_umsk.v hdl/MC_umsk.v hdl/KS_round.v hdl/aes_round_umsk.v
	mkdir -p $(WORK)
	cat hdl/sbox_bp_umsk.v > $(FILE_IN)
	cat hdl/SR_umsk.v >> $(FILE_IN)
	cat hdl/MC_umsk.v >> $(FILE_IN)
	cat hdl/KS_round.v >> $(FILE_IN)
	cat hdl/aes_round_umsk.v >> $(FILE_IN)

$(YOSYS_NETLIST): $(FILE_IN) build-json-yosys.tcl 
	mkdir -p $(WORK)
	FILE_IN=$(FILE_IN) YOSYS_NETLIST=$(YOSYS_NETLIST) yosys -c build-json-yosys.tcl

$(CIRCUIT): $(YOSYS_NETLIST) json2compress.py
	python3 json2compress.py \
	    --netlist-file $(YOSYS_NETLIST) \
	    --top $(TOP_MOD) \
	    --compress-file $(CIRCUIT)

$(AREA_REPORT): $(CIRCUIT)
	make -C ../compress CIRCUIT=$(CIRCUIT) LATS="$(LATS)" DS="$(DS)" WORK=$(WORK) area

area: $(AREA_REPORT)
