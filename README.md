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

### S-boxes

All components of the artifact can be run through the top-level `Makefile`.


Design of S-box (AES and Skinny 8-bit) implementation using the new COMPRESS
tool, optimized HPC2 implementations with the tool of the
[''handcrafting''](https://eprint.iacr.org/2022/252) paper, or pipeline HPC3
implementation using
[AGEMA](https://github.com/Chair-for-Security-Engineering/AGEMA).
These also synthesize the designs and report area (TODO where), using yosys and
the NanGate45 library.
```
make aes_sbox_compress
make skinny_sbox_compress
make sbox_handcrafting
make sbox_agema
```

TODO skinny VCS22

### Adders

Generation of masked adder circuits and their synthesis is very similar to the
S-boxes, with the following commands. TODO area results.
```
make adders_compress
make adders_handcrafting
make adders_agema
```

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
- `make fullverif` runs [fullverif](https://github.com/cassiersg/fullverif) to verify the security of the implementation

For the 128-bit AES:
- `make aes128beh` performs a behavioral simulation
- `make aes128synth` runs a synthesis (yosys+NanGate45), and compares with the
  [related work](https://eprint.iacr.org/2022/252).

