#! /bin/bash

VHDL_ROOT_DIR=${VHDL_ROOT_DIR:-vhdl}
NSHARES=${NSHARES:-2}

WORK=${WORK:-work}
WORKDIR=$WORK/d$NSHARES
CASE_HDL=$WORKDIR/hdl

mkdir -p $CASE_HDL

VHDL_FILES=(
    masked_aes_pkg.vhdl 
    lin_map.vhdl 
    square_scaler.vhdl 
    gf2_mul.vhdl 
    shared_mul_gf2.vhdl 
    real_dom_shared_mul_gf2.vhdl 
    inverter.vhdl 
    shared_mul_gf4.vhdl 
    real_dom_shared_mul_gf4.vhdl 
    aes_sbox.vhdl
)
EXPANDED_FILES=$(for f in ${VHDL_FILES[@]}; do echo "$VHDL_ROOT_DIR/$f"; done)

# synshtesis with ghdl
ghdl -a $EXPANDED_FILES
ghdl synth --out=verilog -gSHARES=$NSHARES aes_sbox > $CASE_HDL/aes_sbox.v

# Clean
LS_CF=$(ls ./*.cf)
for fcf in ${LS_CF[@]} 
do
    echo "Remove building file '$fcf'"
    rm $fcf
done
