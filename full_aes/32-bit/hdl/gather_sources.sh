#! /bin/bash

# Copy all HDL source files in OUT_DIR.
set -e 

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ -z "$OUT_DIR" ]
then
    echo "OUT_DIR must be set"
    exit
fi


mkdir -p $OUT_DIR

if [[ $GATHER_CANRIGHT_SBOX -eq 1 ]];
then
    SBOX_DIR="../../../work/canright_aes_sbox_opt/circuits/canright_d${NUM_SHARES}_l${LATENCY}"
else
    SBOX_DIR="../../../work/aes_opt/circuits/aes_bp_d${NUM_SHARES}_l${LATENCY}"
fi

SRC_DIRS="aes_enc128_32bits_hpc ../../../compress/gadget_library/BIN ../../../compress/gadget_library/MSK ../../../compress/gadget_library/RNG $SBOX_DIR"

# Iterate over each directory
for var in $SRC_DIRS
do
    dir="$SCRIPT_DIR/$var"
    files=$(find $dir -name '*.v' -o -name '*.vh')
    for file in $files
    do
        cp $file $OUT_DIR
        #echo "$file copied to $OUT_DIR"
    done
done
