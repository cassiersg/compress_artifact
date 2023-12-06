
SHELL=/bin/bash
VE=$(abspath ./work/ve)
VE_INsTALLED=$(VE)/installed
PYTHON_VE=source $(VE)/bin/activate

all: help


### Python virtual environment for COMPRESS ###

$(VE)/pyvenv.cfg:
	mkdir -p work
	python3 -m venv $(VE)

$(VE)/installed: $(VE)/pyvenv.cfg
	${PYTHON_VE}; python -m pip install -r compress/requirements.txt
	touch $(VE_INsTALLED)

### Sboxes ###

aes_sbox_%: $(VE_INSTALLED)
	# Generate AES S-box designs reported in the paper.
	${PYTHON_VE}; make -C compress CIRCUIT=circuits/aes_bp.txt LATS="4 5 6" DS="2 3 4 5" GADGETS_CONFIG=gadget_library/gadgets_$*.toml WORK=../work/aes_$* area
aes_sbox_compress: aes_sbox_opt aes_sbox_sep aes_sbox_base

skinny_sbox_%: $(VE_INSTALLED)
	# Generate Skinny (8-bit S-box) designs reported in the paper.
	${PYTHON_VE}; make -C compress CIRCUIT=circuits/skinny8.txt LATS="4 5 6" DS="2 3 4 5" GADGETS_CONFIG=gadget_library/gadgets_$*.toml WORK=../work/skinny_$* area
skinny_sbox_compress: skinny_sbox_opt skinny_sbox_sep skinny_sbox_base

sbox_compress: aes_sbox_compress skinny_sbox_compress

sbox_handcrafting: $(VE_INSTALLED)
	# Generate AES S-box of the "handcrafting" paper, use same algo to generate skinny sbox
	${PYTHON_VE}; make -C compress CIRCUIT=circuits/aes_bp.txt LATS="6" DS="2 3 4 5" WORK=../work/handcrafting COMPRESS_SCRIPT=scripts/handcrafting.py area
	${PYTHON_VE}; make -C compress CIRCUIT=circuits/skinny8.txt LATS="6" DS="2 3 4 5" WORK=../work/handcrafting COMPRESS_SCRIPT=scripts/handcrafting.py area

# AGEMA (HPC3 pipeline only, since handcrafting does HPC2 better).
sbox_agema:
	make -C agema CIRCUIT=../compress/circuits/aes_bp.txt WORK=../work/agema_aes
	make -C agema CIRCUIT=../compress/circuits/skinny8.txt WORK=../work/agema_skinny

# TODO: serialized skinny s-box

### Adders ###

ADDERS= RC3mod KSmod sklanskymod BKmod
ADDER_DIR=$(abspath ./work/adder_circuits)
adder_circuits:
	${PYTHON_VE}; set -e; $(foreach ADDER,$(ADDERS), \
		python compress/scripts/generate_adder_circuit.py -n 32 --type $(ADDER) --out $(ADDER_DIR)/$(ADDER)_32.txt; \
	)

adders_compress: $(VE_INSTALLED) adder_circuits
	# Generate adder designs reported in the paper.
	${PYTHON_VE}; make -C compress CIRCUIT=$(ADDER_DIR)/RC3mod_32.txt LATS="31 32" DS="2 3" WORK=../work/adders area
	${PYTHON_VE}; make -C compress CIRCUIT=$(ADDER_DIR)/KSmod_32.txt LATS="5 12" DS="2 3" WORK=../work/adders area
	${PYTHON_VE}; make -C compress CIRCUIT=$(ADDER_DIR)/sklanskymod_32.txt LATS="6 12" DS="2 3" WORK=../work/adders area
	${PYTHON_VE}; make -C compress CIRCUIT=$(ADDER_DIR)/BKmod_32.txt LATS="9 18" DS="2 3" WORK=../work/adders area

adders_handcrafting: $(VE_INSTALLED) adder_circuits
	${PYTHON_VE}; set -e; $(foeach ADDER,$(ADDERS), \
		make -C compress CIRCUIT=$(ADDER_DIR)/$(ADDER).txt LATS="32" DS="2 3" WORK=../work/adders_handcrafting COMPRESS_SCRIPT=scripts/handcrafting.py area; \
	)

adders_agema: adder_circuits
	$(foeach ADDER,$(ADDERS), \
		make -C agema CIRCUIT=$(ADDER_DIR)/$(ADDER).txt DS="1 2"; \
		make -C compress CIRCUIT=$(ADDER_DIR)/$(ADDER).txt LATS="32" DS="2 3" WORK=../work/adders_handcrafting COMPRESS_SCRIPT=scripts/handcrafting.py area; \
	)

### Gadget verfication with silver ###
silver:
	mkdir -p work/silver_d2 work/silver_d3
	@echo "#### First-order verification ####"
	-cd gadget_verif && python silver_fv_gadget.py --circuits $$(find ../compress/gadget_library/MSK/ -iname '*.v') --work ../work/silver_d2 --silver-root $(SILVER_ROOT) --nshares 2
	@echo "#### Second-order verification ####"
	-cd gadget_verif && python silver_fv_gadget.py --circuits $$(find ../compress/gadget_library/MSK/ -iname '*.v' | grep -v ghpc) --work ../work/silver_d3 --silver-root $(SILVER_ROOT) --nshares 3


### Full AES instances ###

DS=2 3 4
aes32beh: aes_sbox_opt
	set -e; $(foreach D,$(DS), make -C full_aes/32-bit/beh_simu WORK=$(abspath ./work/aes32beh_d$D) NUM_SHARES=$D simu; )

aes32synth: aes_sbox_opt
	make -C full_aes/32-bit/synth WORK=$(abspath ./work/aes32synth) report

aes32postsynth: aes32synth
	set -e; $(foreach D,$(DS), make -C full_aes/32-bit/post_synth_simu SYNTH_WORK=$(abspath ./work/aes32synth) NUM_SHARES=$D WORK=$(abspath ./work/aes32postsynth_d$D) simu; )

fullverif: aes_sbox_opt
	WORK=$(abspath ./work/fullverif) bash -c "cd full_aes/32-bit/fullverif && ./run_fullverif.sh"

aes128beh: aes_sbox_opt
	set -e; $(foreach D,$(DS), make -C full_aes/128-bit/beh_simu WORK=$(abspath ./work/aes128beh_d$D) NUM_SHARES=$D simu; )

aes128synth: aes_sbox_opt
	make -C full_aes/128-bit/synth WORK=$(abspath ./work/aes128synth) report

help:
	@echo "See REDAME.md."
