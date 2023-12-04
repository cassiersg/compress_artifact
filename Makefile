
SHELL=/bin/bash
PYTHON_VE=source ve/bin/activate

all: aes_sbox skinny_sbox adders sbox_agema adders_agema

ve/pyvenv.cfg:
	python3 -m venv ve

ve/installed: ve/pyvenv.cfg
	${PYTHON_VE}; python -m pip install -r compress/requirements.txt
	touch ve/installed


aes_sbox_%: ve/installed
	# Generate AES S-box designs reported in the paper.
	${PYTHON_VE}; make -C compress CIRCUIT=circuits/aes_bp.txt LATS="4 5 6" DS="2 3 4 5" GADGETS_CONFIG=gadget_library/gadgets_$*.toml WORK=../work/aes_$* area

sbox_handcrafting: ve/installed
	# Generate AES S-box of the "handcrafting" paper, use same algo to generate skinny sbox
	${PYTHON_VE}; make -C compress CIRCUIT=circuits/aes_bp.txt LATS="6" DS="2 3 4 5" GADGETS_CONFIG=gadget_library/gadgets_opt.toml WORK=../work/aes_handcrafting COMPRESS_SCRIPT=scripts/handcrafting.py area
	${PYTHON_VE}; make -C compress CIRCUIT=circuits/skinny8.txt LATS="6" DS="2 3 4 5" GADGETS_CONFIG=gadget_library/gadgets_opt.toml WORK=../work/aes_handcrafting COMPRESS_SCRIPT=scripts/handcrafting.py area

aes_sbox: aes_sbox_opt aes_sbox_sep aes_sbox_base aes_sbox_handcrafting

skinny_sbox_%: ve/installed
	# Generate Skinny (8-bit S-box) designs reported in the paper.
	${PYTHON_VE}; make -C compress CIRCUIT=circuits/skinny8.txt LATS="4 5 6" DS="2 3 4 5" GADGETS_CONFIG=gadget_library/gadgets_$*.toml WORK=../work/skinny_$* area

skinny_sbox: skinny_sbox_opt skinny_sbox_sep skinny_sbox_base

ADDERS= RC3mod KSmod sklanskymod BKmod
adder_circuits:
	${PYTHON_VE}; set -e; $(foreach ADDER,$(ADDERS), \
		python compress/scripts/generate_adder_circuit.py -n 32 --type $(ADDER) --out compress/circuits/$(ADDER)_32.txt; \
	)

adders_handcrafting: ve/installed
	${PYTHON_VE}; make -C compress CIRCUIT=circuits/RC3mod_32.txt LATS="32" DS="2 3" GADGETS_CONFIG=gadget_library/gadgets_opt.toml WORK=../work/adders_handcrafting COMPRESS_SCRIPT=scripts/handcrafting.py area

adders: ve/installed adder_circuits
	# Generate adder designs reported in the paper.
	${PYTHON_VE}; make -C compress CIRCUIT=circuits/RC3mod_32.txt LATS="31 32" DS="2 3" GADGETS_CONFIG=gadget_library/gadgets_opt.toml WORK=../work/adders area
	${PYTHON_VE}; make -C compress CIRCUIT=circuits/KSmod_32.txt LATS="5 12" DS="2 3" GADGETS_CONFIG=gadget_library/gadgets_opt.toml WORK=../work/adders area
	${PYTHON_VE}; make -C compress CIRCUIT=circuits/sklanskymod_32.txt LATS="6 12" DS="2 3" GADGETS_CONFIG=gadget_library/gadgets_opt.toml WORK=../work/adders area
	${PYTHON_VE}; make -C compress CIRCUIT=circuits/BKmod_32.txt LATS="9 18" DS="2 3" GADGETS_CONFIG=gadget_library/gadgets_opt.toml WORK=../work/adders area

# AGEMA HPC3 pipeline
sbox_agema:
	make -C agema CIRCUIT=../compress/circuits/aes_bp.txt
	make -C agema CIRCUIT=../compress/circuits/skinny8.txt

adders_agema: adder_circuits
	# Generate adder designs reported in the paper.
	make -C agema CIRCUIT=../compress/circuits/RC3mod_32.txt DS="1 2"
	make -C agema CIRCUIT=../compress/circuits/KSmod_32.txt DS="1 2"
	make -C agema CIRCUIT=../compress/circuits/sklanskymod_32.txt DS="1 2"
	make -C agema CIRCUIT=../compress/circuits/BKmod_32.txt DS="1 2"

silver:
	-cd gadget_verif && python silver_fv_gadget.py --circuits $$(find ../compress/gadget_library/MSK/ -iname '*.v') --work ./work --silver-root ~/git/SILVER --nshares 2
	-cd gadget_verif && python silver_fv_gadget.py --circuits $$(find ../compress/gadget_library/MSK/ -iname '*.v' | grep -v ghpc) --work ./work --silver-root ~/git/SILVER --nshares 3

.PHONY: aes_sbox skinny_sbox adder_circuits adders sbox_agema adders_agema silver
