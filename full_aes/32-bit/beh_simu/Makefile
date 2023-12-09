
WORK ?= ./work
NUM_SHARES ?= 2
LATENCY ?= 4

HDL_ROOT_DIR=../hdl/
TB_TARGET?=tb_aes_enc128_32bits_hpc
TB_DIR=$(HDL_ROOT_DIR)/tb
TB_FILE=$(TB_DIR)/$(TB_TARGET).v

TV_DIR=./tvs/files
DIR_GENERATED=$(WORK)/tvs
#TV_FILE_PREF=ECBGFSbox128
TV_FILE_PREF=ECBKeySbox128
#TV_FILE_PREF=ECBVarKey128
#TV_FILE_PREF?=ECBVarTxt128

###########################
KATIN=${TV_DIR}/${TV_FILE_PREF}.rsp
TVIN=${DIR_GENERATED}/TV_${TV_FILE_PREF}_in.rsp
TVOUT=${DIR_GENERATED}/TV_${TV_FILE_PREF}_out.rsp

${TVIN}:
	mkdir -p ${DIR_GENERATED}
	python3 tvs/parse_KAT_for_TV.py \
	    --file-in ${KATIN} \
	    --dir-out ${DIR_GENERATED}

tv: ${TVIN}

simu: ${TVIN} simu-build
	vvp $(WORK)/simu-exec-$(TB_TARGET)

wave:
	gtkwave $(WORK)/log-$(TB_TARGET).vcd waves-$(TB_TARGET).gtkw

simu-build:
	mkdir -p $(WORK)
	OUT_DIR=$(WORK)/hdl NUM_SHARES=$(NUM_SHARES) LATENCY=$(LATENCY) $(HDL_ROOT_DIR)/gather_sources.sh
	cp $(TB_DIR)/* $(WORK)/hdl 
	iverilog \
	    -y $(WORK)/hdl \
	    -I $(WORK)/hdl \
	    -D TV_IN=\"${TVIN}\" \
	    -D TV_OUT=\"${TVOUT}\" \
	    $(TB_FILE) \
	    -o $(WORK)/simu-exec-$(TB_TARGET) \
		-Pd=$(NUM_SHARES) \
	    -D DUMPFILE=\"$(WORK)/log-$(TB_TARGET).vcd\" \
		-D DEFAULTRND=1 \
		-D behavioral

clean:
	-rm -r $(WORK)

help:
	@echo "Behavioral simulation of the masked core."
	@echo "make simu: run the simulation."
	@echo "make wave: open gtkwave."
	@echo "makefile parameter TB_TARGET: name of the tb module."
	@echo "makefile parameter TV_FILE_PREF: name of the KAT file to use for testvector (without extension)."

.PHONY: clean help wave simu-build simu tv
