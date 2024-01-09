
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

WORK_DIR_BP = $(WORK)/aesbp
WORK_DIR_CANRIGHT = $(WORK)/aescanright

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

wave:
	gtkwave $(WORK)/log-$(TB_TARGET).vcd waves-$(TB_TARGET).gtkw

simu-bp: ${TVIN} simu-bp-build
	vvp $(WORK_DIR_BP)/simu-exec-$(TB_TARGET)

simu-bp-build:
	mkdir -p $(WORK_DIR_BP)
	OUT_DIR=$(WORK_DIR_BP)/hdl NUM_SHARES=$(NUM_SHARES) LATENCY=$(LATENCY) $(HDL_ROOT_DIR)/gather_sources.sh
	cp $(TB_DIR)/* $(WORK_DIR_BP)/hdl 
	iverilog \
	    -y $(WORK_DIR_BP)/hdl \
	    -I $(WORK_DIR_BP)/hdl \
	    -D TV_IN=\"${TVIN}\" \
	    -D TV_OUT=\"${TVOUT}\" \
	    $(TB_FILE) \
	    -o $(WORK_DIR_BP)/simu-exec-$(TB_TARGET) \
		-Pd=$(NUM_SHARES) \
	    -D DUMPFILE=\"$(WORK)/log-$(TB_TARGET).vcd\" \
		-D DEFAULTRND=1 \
		-D behavioral

simu-canright: ${TVIN} simu-canright-build
	vvp $(WORK_DIR_CANRIGHT)/simu-exec-$(TB_TARGET)

simu-canright-build:
	mkdir -p $(WORK_DIR_CANRIGHT)
	OUT_DIR=$(WORK_DIR_CANRIGHT)/hdl GATHER_CANRIGHT_SBOX=1 NUM_SHARES=$(NUM_SHARES) LATENCY=$(LATENCY) $(HDL_ROOT_DIR)/gather_sources.sh
	cp $(TB_DIR)/* $(WORK_DIR_CANRIGHT)/hdl 
	iverilog \
	    -y $(WORK_DIR_CANRIGHT)/hdl \
	    -I $(WORK_DIR_CANRIGHT)/hdl \
	    -D TV_IN=\"${TVIN}\" \
	    -D TV_OUT=\"${TVOUT}\" \
	    -D CANRIGHT_SBOX \
	    $(TB_FILE) \
	    -o $(WORK_DIR_CANRIGHT)/simu-exec-$(TB_TARGET) \
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
