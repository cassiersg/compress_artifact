#! /bin/bash

shopt -s nullglob

CASE=${CASE:-skinny-hdl-thresh-2222}
VHDL_ROOT_DIR=${VHDL_ROOT_DIR:-.}
VHDL_DIR=$VHDL_ROOT_DIR/$CASE

WORK=${WORK:-work}
WORKDIR=$WORK/$CASE

echo WORKDIR $WORKDIR
mkdir -p $WORKDIR

VHDL_FILES=(
	$VHDL_DIR/skinny_pkg.vhd
	$VHDL_DIR/ff.vhd
	$VHDL_DIR/pipe.vhd
	$VHDL_DIR/pipereg.vhd
	$VHDL_DIR/shares/*.vhd
	$VHDL_DIR/substitution.vhd
)
EXPANDED_FILES=$(for f in ${VHDL_FILES[@]}; do if [ -f $f ]; then echo "$f"; fi; done)
echo $EXPANDED_FILES

# synshtesis with ghdl

ghdl -a --workdir=$WORKDIR $EXPANDED_FILES
echo analysis done
ghdl synth --workdir=$WORKDIR --out=verilog substitution >$WORKDIR/skinny_sbox.v
