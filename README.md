# COMPRESS artifact

This repository contains the artifact for the paper
[**Compress: Reducing Area and Latency of Masked Pipelined Circuits**](https://eprint.iacr.org/2023/1600).
The artifact contains all the code on which the results presented in the paper are based, except for COMPRESS itself, which is in a [separate repository](https://github.com/cassiersg/compress) (and is included as a submodule of this repository).

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

## Contents

```
.
├── agema
│   ├── circ2v.py
│   ├── Makefile
│   ├── stdcells.lib
│   ├── summarize_areas.py
│   ├── synth.tcl
│   └── verilog_hpc3 # AGEMA's HPC3 gadgets re-implemented in verilog for easier synthesis.
├── compress # COMPRESS submodule
├── full_aes
│   ├── 128-bit # AES implementation with 128-bit architecture.
│   └── 32-bit # AES implementations with 32-bit architecture.
├── gadget_verif # Verification of our gadget implementations with SILVER.
├── LICENSE.txt
├── COPYRIGHT.txt
├── Makefile
└── README.md
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
make skinny_sbox_compress
make sbox_handcrafting
make sbox_agema
```
The reports for area usage and design generation execution time are in 
`work/{aes,skinny}_{opt,sep,base}/{aes_bp,skinny8}_area.csv` for COMPRESS,
`work/handcrafting/{aes_bp,skinny8}_area.csv` for handcrafting, and
`work/agema_{skinny,aes}/{aes_bp,skinny8}_areas.csv` for AGEMA.

Finally, we synthesize the serialized Skinny8 S-box of [VCS22] with
```
make skinny_sbox_serialized
```
Area report is generated in `work/skinny_serialized/areas.csv`.

### Adders

Generation of masked adder circuits and their synthesis is very similar to the
S-boxes, with the following commands.
```
make adders_compress
make adders_handcrafting
make adders_agema
```
TODO area results.

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

