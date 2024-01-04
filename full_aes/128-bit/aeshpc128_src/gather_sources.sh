#! /bin/bash

# Copy all HDL source files in OUT_DIR.

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ -z "$OUT_DIR" ]
then
    echo "OUT_DIR must be set"
    exit
fi


mkdir -p $OUT_DIR

SRC_DIRS="./ ../../../compress/gadget_library/BIN ../../../compress/gadget_library/MSK ../../../compress/gadget_library/RNG ../../../work/aes_opt/circuits/aes_bp_d${NUM_SHARES}_l${LATENCY}"

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
