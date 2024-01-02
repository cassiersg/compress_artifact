set TOP canright_aes_sbox_trivial_from_c
yosys read_verilog $TOP.v
yosys setattr -mod -set keep_hierarchy 1 G4_mul G16_mul 
yosys proc
yosys flatten
yosys techmap
yosys opt
yosys write_json -compat-int yosys_$TOP.json 
