#!/bin/bash

set -e

## Source settings
HDL_ROOT_DIR=../hdl
TB_MODULE=tb_mskaes
TB_DIR=../tb
TB_PATH=$TB_DIR/$TB_MODULE.v
MAIN_MODULE=MSKaes_128bits_round_based
# signal starting the first simulation cycle (i.e. latency == 0 for the main module), name in the testbench
IN_VALID=valid_in
# clock signal (in the testbench)
CLOCK=clk
# name of the instance of the main module in the testbench
DUT=dut

## workdir
HDL_DIR=$WORK/hdl
VCD_PATH=$WORK/a.vcd
SIM_PATH=$WORK/beh-simu
SYNTH_BASE=$WORK/${MAIN_MODULE}_synth

# Prepare sources
rm -rf $WORK
mkdir -p $WORK
NUM_SHARES=${NUM_SHARES:-2} LATENCY=4 OUT_DIR=$HDL_DIR $HDL_ROOT_DIR/gather_sources.sh
# NB: we use the convention that module X is always in file X.v in this script


####### Execution #######
echo "Starting synthesis..."
OUT_DIR=$WORK MAIN_MODULE=$MAIN_MODULE IMPLEM_DIR=$HDL_DIR ${YOSYS:=yosys} -c ./msk_presynth.tcl || exit
echo "Synthesis finished."

echo "Starting simulation..."
# Change this if you want to use another simulator
# -y source directory for .v modules
# -s top-level module (i.e. testbench)
${IVERILOG:=iverilog} \
    -y $HDL_DIR \
    -y $TB_DIR \
    -I $HDL_DIR \
    -I $TB_DIR \
    -s $TB_MODULE \
    -o $SIM_PATH \
    -D VCD_PATH=\"$VCD_PATH\" \
    -D RES_FILE=\"$WORK/res_$NUM_SHARES.log\" \
    -D FULLVERIF=1 \
    -D LATENCY=4 \
    -D behavioral \
    $SYNTH_BASE.v $TB_PATH || exit
    #-y $FULLVERIF_LIB_DIR \
    #-I $FULLVERIF_LIB_DIR \
${VVP:=vvp} $SIM_PATH
echo "Simulation finished"

echo "Starting fullverif..."
FV_CMDLINE="${FULLVERIF:=fullverif} --json $SYNTH_BASE.json --vcd $VCD_PATH --tb $TB_MODULE --gname $MAIN_MODULE --in-valid $IN_VALID --clock $CLOCK --dut $DUT"
echo "$FV_CMDLINE"
$FV_CMDLINE | tee $WORK/fullverif.log
