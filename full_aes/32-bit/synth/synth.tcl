yosys -import

set top aes_enc128_32bits_hpc2
set synth_lib ../../../compress/synthesis/stdcells.lib
set num_shares $::env(NUM_SHARES)
set src_dir $::env(SRC_DIR)

verilog_defaults -add -I$src_dir
read_verilog -DDEFAULTSHARES=$num_shares $src_dir/$top.v
hierarchy -check -libdir $src_dir -top $top


procs; opt; fsm; opt; memory; opt

techmap; opt

dfflibmap -liberty $synth_lib

abc -liberty $synth_lib

clean
set synth_name $::env(SYNTH_NAME)
set work $::env(WORK)
tee -o $work/$synth_name.yosys-area.json stat -liberty $synth_lib -json
write_json $work/$synth_name.yosys-design.json
write_verilog $work/$synth_name.yosys.v
