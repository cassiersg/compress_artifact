# COMPRESS artifact

This repository contains the artifact for the paper [**Compress: Reducing Area
and Latency of Masked Pipelined Circuits**](https://eprint.iacr.org/2023/1600).
The artifact contains all the code on which the results presented in the paper
are based, except for COMPRESS itself, which is in a [separate
repository](https://github.com/cassiersg/compress) (and is included as a
submodule of this repository).

## Getting started

Clone the repository with the [submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules):
```
git clone --recursive https://github.com/cassiersg/compress_artifact
```

The scripts in the repository assume a unix environment (bash, coreutils, etc.), as well as the following dependencies:

- python3 with venv (`python3-venv` on Ubuntu)
- yosys (version 0.33 tested)
- iverilog (version 11.0 tested)

Some part of the artifact additionally require:
- [AGEMA](https://github.com/Chair-for-Security-Engineering/AGEMA) (commit `4e43d9d61` tested)
- [fullverif](https://github.com/cassiersg/fullverif) (commit `227f31215` tested)
- [SILVER](https://github.com/Chair-for-Security-Engineering/SILVER) (commit `57fd89b71` tested)
- [GHDL](https://github.com/ghdl/ghdl) (version 4.1.0 tested)

## Contents

```
├── aes-round-compress # AES round fully-generated by COMPRESS.
├── agema # Automated masking of COMPRESS .txt files with AGEMA.
├── agema_direct # Masked circuit generation and synthesis of AGEMA example circuits.
├── canright # Masking of Canright AES Sbox with COMPRESS.
├── compress # Submodule containing COMPRESS and misc. gadgets.
├── dom-sbox # Masking of Canright AES Sbox with DOM [GMK16]. 
├── full_aes
│   ├── 128-bit # round-based AES
│   └── 32-bit # AES with 32-bit serial architecture
├── gadget_verif # Verification of COMPRESS gadgets with SILVER.
├── low_random_second_order_aes # AES Sbox of [DSM22]
├── Makefile # Top-level makefile for running all flows of this repository.
├── skinny_serialized_sbox # Skinny Sbox of [VCS22].
├── skinny_ti # Skinny Sbox of [CCGB21].
└── work # Where all temporary and result files are generated.
```

## Usage

All components of the artifact can be run through the top-level `Makefile`.

### Required environment variables

- `yosys` and `iverilog` must be in `PATH`.
- `AGEMA_ROOT` must point to the root AGEMA directory (the one that contains `bin/` and `cell/`).
- `FULLVERIF` must point to the `fullverif` binary (typically ending in `fullverif-check/target/release/fullverif`), or `fullverif` must be in `PATH`.
- `SILVER_ROOT` must point to the root SILVER directory (the one that contains `bin/` and `cell/`).

### S-boxes

Design of S-box (AES and Skinny 8-bit) implementation using the new COMPRESS
tool, optimized HPC2 implementations with the tool of the
[''handcrafting''](https://eprint.iacr.org/2022/252) paper, or pipeline HPC3
implementation using
[AGEMA](https://github.com/Chair-for-Security-Engineering/AGEMA).
These also synthesize the designs and report area, using yosys and
the NanGate45 library.
```
make aes_sbox_compress
make canright_aes_sbox_opt
make skinny_sbox_compress
make sbox_handcrafting
make sbox_agema # Requires $AGEMA_ROOT to be set
```
The reports for area usage and design generation execution time are in 
`work/{aes,skinny}_{opt,sep,base}/{aes_bp,skinny8}_area.csv` for COMPRESS,
`work/handcrafting/{aes_bp,skinny8}_area.csv` for handcrafting, and
`work/agema_{skinny,aes}/{aes_bp,skinny8}_areas.csv` for AGEMA.

Besides, we synthesize the serialized Skinny8 S-box of [VCS22] with
```
make skinny_sbox_serialized
```
Area report is generated in `work/skinny_serialized/areas.csv`.

Additionally, the synthesis results for the AES Sbox with DOM are obtained with
```
make dom_aes_sbox
```
and the Yosys area report is generated in `work/DOM_aes_sbox/d{2,3,4,5}/area/area.json`.

For the AES Sbox from [DSM22], the area synthesis results are obtained with 
```
make lr_2OM_aes_sbox
```
and the Yosys area report is generated in `work/low_random_second_order_aes/area/area.json`.

Finally, the Skinny Sbox synthesis results from [CCGB21] are obtained via
```
make skinny_ti
```
and the Yosys area report is generated in `work/skinny_ti/skinny-hdl-thresh-{222,2222,232,33}/area.json`.

### Adders

Generation of masked adder circuits and their synthesis is very similar to the
S-boxes, with the following commands.
```
make adders_compress
make adders_handcrafting
make adders_agema
```
Area reports are generated respectively in work/adders/*.csv`,
work/adders_handcrafting/*.csv` and work/adders_agema/*.csv`.

### COMPRESS gadget verification

COMPRESS comes with a few variants of HPC2 and HPC3.
The security of these gadgets can be automatically verified using
[SILVER](https://github.com/chair-for-Security-Engineering/silver).
```
make silver
```

### AES

For the 32-bit AES:

- `make aes32beh` performs a behavioral simulation
- `make aes32synth` runs a synthesis (yosys+NanGate45), and compares with [SMAesH](https://github.com/SIMPLE-Crypto/SMAesH).
- `make aes32postsynth` verifies the synthesized circuit with a simulation
- `make aes32fullverif` runs [fullverif](https://github.com/cassiersg/fullverif) to verify the security of the implementation

For the 128-bit AES:
- `make aes128beh` performs a behavioral simulation
- `make aes128synth` runs a synthesis (yosys+NanGate45), and compares with the [related work](https://eprint.iacr.org/2022/252).
- `make aes128postsynth` verifies the synthesized circuit with a simulation
- `make aes128fullverif` runs [fullverif](https://github.com/cassiersg/fullverif) to verify the security of the implementation

For the (128-bit) AES of AGEMA:
- `make aes128agema`
