
SHELL=/bin/bash
VE=$(abspath ./work/ve)
VE_INSTALLED=$(VE)/installed
PYTHON_VE=source $(VE)/bin/activate

SKIP_BEH_SIMU ?= 1
SKIP_STRUCT_SIMU ?= 1
TIMEOUT_COMPRESS ?= 3600

export TIMEOUT_COMPRESS
export SKIP_BEH_SIMU
export SKIP_STRUCT_SIMU

all: help


### Python virtual environment for COMPRESS ###

$(VE)/pyvenv.cfg:
	mkdir -p work
	python3 -m venv $(VE)

$(VE_INSTALLED): $(VE)/pyvenv.cfg
	${PYTHON_VE}; python -m pip install -r compress/requirements.txt
	${PYTHON_VE}; python -m pip install tqdm=4.66.4
	touch $(VE_INSTALLED)

### Sboxes ###

aes_sbox_compress: aes_sbox_opt aes_sbox_sep aes_sbox_base
aes_sbox_opt aes_sbox_sep aes_sbox_base: aes_sbox_%: $(VE_INSTALLED)
	# Generate AES S-box designs reported in the paper.
	${PYTHON_VE}; TB_CHECK_REF=aes_sbox make -C compress CIRCUIT=circuits/aes_bp.txt LATS="4 5 6" DS="2 3 4 5" GADGETS_CONFIG=gadget_library/gadgets_$*.toml WORK=../work/aes_$* area

skinny_sbox_compress: skinny_sbox_opt skinny_sbox_sep skinny_sbox_base
skinny_sbox_opt skinny_sbox_sep skinny_sbox_base: skinny_sbox_%: $(VE_INSTALLED)
	# Generate Skinny (8-bit S-box) designs reported in the paper.
	${PYTHON_VE}; make -C compress CIRCUIT=circuits/skinny8.txt LATS="4 5 6" DS="2 3 4 5" GADGETS_CONFIG=gadget_library/gadgets_$*.toml WORK=../work/skinny_$* area

sbox_compress: aes_sbox_compress skinny_sbox_compress

sbox_handcrafting: $(VE_INSTALLED)
	# Generate AES S-box of the "handcrafting" paper, use same algo to generate skinny sbox
	${PYTHON_VE}; make -C compress CIRCUIT=circuits/aes_bp.txt LATS="6" DS="2 3 4 5" WORK=../work/handcrafting COMPRESS_SCRIPT=scripts/handcrafting.py area
	${PYTHON_VE}; make -C compress CIRCUIT=circuits/skinny8.txt LATS="6" DS="2 3 4 5" WORK=../work/handcrafting COMPRESS_SCRIPT=scripts/handcrafting.py area

# AGEMA (HPC3 pipeline only, since handcrafting does HPC2 better).
sbox_agema:
	make -C agema CIRCUIT=../compress/circuits/aes_bp.txt WORK=$(abspath work/aes_agema)
	make -C agema CIRCUIT=../compress/circuits/skinny8.txt WORK=$(abspath work/skinny_agema)
	make -C agema_direct WORK=$(abspath work/aes_agema_canright) MODULE_NAME=sbox SRC_VERILOG=$(abspath agema_direct/sbox_canright.v)

skinny_sbox_serialized:
	make -C skinny_serialized_sbox WORK=$(abspath work/skinny_serialized) DS="2 3 4 5"

### Masked AES Sbox with TI
lr_2OM_aes_sbox:
	make -C low_random_second_order_aes WORK=$(abspath work/low_random_second_order_aes) area 

### DOM AES Sbox
dom_aes_sbox:
	set -e; WORK=$(abspath work/DOM_aes_sbox) NSHARES=2 make -C dom-sbox area 
	set -e; WORK=$(abspath work/DOM_aes_sbox) NSHARES=3 make -C dom-sbox area 
	set -e; WORK=$(abspath work/DOM_aes_sbox) NSHARES=4 make -C dom-sbox area 
	set -e; WORK=$(abspath work/DOM_aes_sbox) NSHARES=5 make -C dom-sbox area 

skinny_ti:
	make -C skinny_ti WORK=$(abspath work/skinny_ti)

# canright compress
canright_aes_sbox_opt: $(VE_INSTALLED)
	# Generate AES S-box designs reported in the paper.
	${PYTHON_VE}; TB_CHECK_REF=aes_sbox make -C canright LATS="4 5 6" DS="2 3 4 5" WORK=../work/$@ area

# AES round with compress
aes_round_compress: $(VE_INSTALLED)
	# Generate masked AES round (with compress) designs reported in the paper 
	${PYTHON_VE}; make -C aes-round-compress LATS="4" DS="2 3 4 5" WORK=../work/$@ area 

### Adders ###

ADDERS= RC3mod KSmod sklanskymod BKmod
ADDER_DIR=$(abspath ./work/adder_circuits)
ADDER_FILES=$(foreach ADDER,$(ADDERS),$(ADDER_DIR)/$(ADDER)_32.txt)
$(ADDER_FILES): $(ADDER_DIR)/%_32.txt: compress/scripts/generate_adder_circuit.py
	mkdir -p $(dir $@)
	${PYTHON_VE}; python $< -n 32 --type $* --out $@

adder_circuits: $(ADDER_FILES)

adders_compress: $(VE_INSTALLED) adder_circuits
	# Generate adder designs reported in the paper.
	${PYTHON_VE}; make -C compress WORK=$(abspath ./work/adders) CIRCUIT=$(ADDER_DIR)/RC3mod_32.txt LATS="31 32" DS="2 3" area
	${PYTHON_VE}; make -C compress WORK=$(abspath ./work/adders) CIRCUIT=$(ADDER_DIR)/KSmod_32.txt LATS="5 6 7 8" DS="2 3" area
	${PYTHON_VE}; make -C compress WORK=$(abspath ./work/adders) CIRCUIT=$(ADDER_DIR)/sklanskymod_32.txt LATS="6 7" DS="2 3" area
	${PYTHON_VE}; make -C compress WORK=$(abspath ./work/adders) CIRCUIT=$(ADDER_DIR)/BKmod_32.txt LATS="9 10" DS="2 3" area

adders_handcrafting: $(VE_INSTALLED) adder_circuits
	${PYTHON_VE}; set -e; $(foreach ADDER,$(ADDERS), \
		make -C compress CIRCUIT=$(ADDER_DIR)/$(ADDER)_32.txt LATS="32" DS="2 3" WORK=$(abspath ./work/adders_handcrafting) COMPRESS_SCRIPT=scripts/handcrafting.py area; \
	)

adders_agema: adder_circuits
	$(foreach ADDER,$(ADDERS), \
		make -C agema CIRCUIT=$(ADDER_DIR)/$(ADDER)_32.txt DS="1 2" WORK=$(abspath ./work/adders_agema/$(ADDER)) ; \
	)

### Gadget verfication with silver ###
silver: 
	mkdir -p work/silver_d2 work/silver_d3
	@echo "#### First-order verification ####"
	${PYTHON_VE}; cd gadget_verif && python silver_fv_gadget.py --circuits $$(find ../compress/gadget_library/MSK/ -iname '*.v') --work ../work/silver_d2 --silver-root $(SILVER_ROOT) --nshares 2
	@echo "#### Second-order verification ####"
	${PYTHON_VE}; cd gadget_verif && python silver_fv_gadget.py --circuits $$(find ../compress/gadget_library/MSK/ -iname '*.v' | grep -v ghpc) --work ../work/silver_d3 --silver-root $(SILVER_ROOT) --nshares 3


### Full AES instances ###

DS=2 3 4
aes32beh: aes_sbox_opt canright_aes_sbox_opt
	set -e; $(foreach D,$(DS), make -C full_aes/32-bit/beh_simu WORK=$(abspath ./work/aes32bpbeh_d$D) NUM_SHARES=$D simu; )
	set -e; $(foreach D,$(DS), make -C full_aes/32-bit/beh_simu WORK=$(abspath ./work/aes32canrightbeh_d$D) NUM_SHARES=$D CANRIGHT=1 simu; )

aes32synth: aes_sbox_opt canright_aes_sbox_opt
	${PYTHON_VE}; make -C full_aes/32-bit/synth WORK=$(abspath ./work/aes32synth) report

aes32postsynth:
	set -e; $(foreach D,$(DS), make -C full_aes/32-bit/post_synth_simu SYNTH_WORK=$(abspath ./work/aes32synth) NUM_SHARES=$D WORK=$(abspath ./work/aes32postsynth_d$D) simu; )
	set -e; $(foreach D,$(DS), make -C full_aes/32-bit/post_synth_simu SYNTH_WORK=$(abspath ./work/aes32synth) NUM_SHARES=$D WORK=$(abspath ./work/aes32postsynth_d$D) CANRIGHT=1 simu; )

aes32fullverif: aes_sbox_opt canright_aes_sbox_opt
	set -e; $(foreach D,$(DS), NUM_SHARES=$D WORK=$(abspath ./work/aes32bpfullverif_d$D) bash -c "set -e; cd full_aes/32-bit/fullverif && ./run_fullverif.sh" ; )
	set -e; $(foreach D,$(DS), NUM_SHARES=$D WORK=$(abspath ./work/aes32canrightfullverif_d$D) CANRIGHT=1 bash -c "set -e; cd full_aes/32-bit/fullverif && ./run_fullverif.sh" ; )

aes128beh: aes_sbox_opt canright_aes_sbox_opt
	set -e; $(foreach D,$(DS), make -C full_aes/128-bit/beh_simu WORK=$(abspath ./work/aes128beh_d$D) NUM_SHARES=$D simu; )
	set -e; $(foreach D,$(DS), make -C full_aes/128-bit/beh_simu WORK=$(abspath ./work/aes128canrightbeh_d$D) NUM_SHARES=$D CANRIGHT=1 simu; )

aes128synth: aes_sbox_opt canright_aes_sbox_opt
	${PYTHON_VE}; make -C full_aes/128-bit/synth WORK=$(abspath ./work/aes128synth) report

aes128postsynth:
	set -e; $(foreach D,$(DS), make -C full_aes/128-bit/post_synth_simu SYNTH_WORK=$(abspath ./work/aes128synth) NUM_SHARES=$D WORK=$(abspath ./work/aes128postsynth_d$D) simu; )
	set -e; $(foreach D,$(DS), make -C full_aes/128-bit/post_synth_simu SYNTH_WORK=$(abspath ./work/aes128synth) NUM_SHARES=$D WORK=$(abspath ./work/aes128postsynth_d$D) CANRIGHT=1 simu; )

aes128fullverif: aes_sbox_opt
	set -e; $(foreach D,$(DS), NUM_SHARES=$D WORK=$(abspath ./work/aes128bpfullverif_d$D) bash -c "set -e; cd full_aes/128-bit/fullverif && ./run_fullverif.sh" ; )
	set -e; $(foreach D,$(DS), NUM_SHARES=$D WORK=$(abspath ./work/aes128canrightfullverif_d$D) CANRIGHT=1 bash -c "set -e; cd full_aes/128-bit/fullverif && ./run_fullverif.sh" ; )

aes128agema:
	make -C agema_direct WORK=$(abspath work/aes128agema) MODULE_NAME=AES SRC_VERILOG=$(AGEMA_ROOT)/../CaseStudies/08_AES128_round_based_encryption/netlists/AES.v

	

help:
	@echo "See README.md."

.PHONY: skinny_ti
