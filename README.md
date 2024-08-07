# COMPRESS artifact

This repository contains the artifact for the paper [**Compress: Reducing Area
and Latency of Masked Pipelined Circuits**](https://eprint.iacr.org/2023/1600).
The artifact contains all the code on which the results presented in the paper
are based, except for COMPRESS itself, which is in a [separate
repository](https://github.com/cassiersg/compress) (and is included as a
submodule of this repository).

## Getting started

When getting this artifact from github, clone the repository with the
[submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules):
```
git clone --recursive https://github.com/cassiersg/compress_artifact
```

The scripts in the repository assume a unix environment (bash, GNU make, coreutils, etc.), as well as the following dependencies:

- python3 (python3.10 tested) with venv (`python3-venv` on Ubuntu)
- yosys (version 0.33 tested)
- iverilog (version 11.0 tested)

Some part of the artifact additionally require:

- [AGEMA](https://github.com/Chair-for-Security-Engineering/AGEMA) (commit `4e43d9d61` tested)
- [fullverif](https://github.com/cassiersg/fullverif) (commit `227f31215` tested)
- [SILVER](https://github.com/Chair-for-Security-Engineering/SILVER) (commit `57fd89b71` tested, some more recent versions do not work)
- [GHDL](https://github.com/ghdl/ghdl) (version 4.1.0 tested)

(See [below](#Installing-Dependencies) for detailed dependencies installation instructions.)

## Contents

```
├── aes-round-compress # AES round fully-generated by COMPRESS.
├── agema # Automated masking of COMPRESS .txt files with AGEMA.
├── agema_direct # Masked circuit generation and synthesis of AGEMA example circuits.
├── canright # Masking of Canright AES Sbox with COMPRESS.
├── compress # Submodule containing COMPRESS, masked gadgets and simulation/synthesis scripts.
├── dom-sbox # Masking of Canright AES Sbox with DOM [GMK16]. 
├── full_aes
│   ├── 128-bit # round-based AES
│   └── 32-bit # AES with 32-bit serial architecture
├── gadget_verif # Verification of COMPRESS gadgets with SILVER.
├── low_random_second_order_aes # Masked TI AES Sbox of [DSM22]
├── Makefile # Top-level makefile for running all flows of this repository.
├── skinny_serialized_sbox # Masked serialized 8-bit Skinny Sbox of [VCS22].
├── skinny_ti # Masked TI 8-bit Skinny Sbox of [CCGB21].
└── work # Where all temporary and result files are generated.
```

## Using COMPRESS directly

See `compress/README.md` or <https://github.com/cassiersg/compress>.

## Reproducing results of the paper

All components of the artifact can be run through the top-level `Makefile`.

### Required environment variables

- `yosys` and `iverilog` must be in `PATH`.
- For AGEMA targets: `AGEMA_ROOT` must point to the root AGEMA directory (the one that contains `bin/` and `cell/`).
- For AES design verification: `FULLVERIF` must point to the `fullverif` binary (typically ending in `fullverif-check/target/release/fullverif`), or `fullverif` must be in `PATH`.
- For gadget verification with SILVER: `SILVER_ROOT` must point to the root SILVER directory (the one that contains `bin/` and `cell/`).

### Optional environment variables

Some of the Makefile targets detailed after may take a significant time to
complete. The time required to simulate the largest circuits can be of the
order of an hour for behavioral simulations, or several hours for structural
simulations. Besides, the execution time of COMPRESS is rather fast (seconds to
minutes) for small circuit, but increase with the circuit size due to the usage
of a CP solver (in the artifact, only some adder circuits take a long time).

The following environment variables provide configuration for the most time consuming steps:

- `SKIP_BEH_SIMU` (default: 0): set to 0 (resp. 1) in order to run (resp. skip) behavioral simulations.
- `SKIP_STRUCT_SIMU` (default: 1): set to 0 (resp. 1) in order to run (resp. skip) structural simulations.
- `TIMEOUT_COMPRESS` (default: 3600): timeout (in seconds) for the COMPRESS CP
solver execution time. Reducing the timeout value may affect the performance of
the generated circuits (e.g., some adders circuits reached the 1h timeout, as
mentioned in Table 7 of the paper). Running on a small machine may have the
same effect (we used a 64-core machine).

```
SKIP_STRUCT_SIMU=1 make $TARGET
```

### S-boxes 

The following `make` targets generate masked AES and 8-bit Skinny S-box designs
using various automated tools.
These also synthesize the designs and report area, using yosys and
the NanGate45 library.

- COMPRESS (new):

    ```
    make aes_sbox_compress # Boyar-Peralta AES S-box
    make canright_aes_sbox_opt # Canright AES S-box
    make skinny_sbox_compress
    ```

- Optimized HPC2 implementations with the tool of the
[''handcrafting''](https://eprint.iacr.org/2022/252) paper:

    ```
    make sbox_handcrafting
    ```

- Pipeline HPC3 implementation using
[AGEMA](https://github.com/Chair-for-Security-Engineering/AGEMA).

    ```
    make sbox_agema # Requires $AGEMA_ROOT to be set
    ```

The reports for area usage and design generation execution time are in 
`work/{aes,skinny}_{opt,sep,base}/{aes_bp,skinny8}_area.csv` for COMPRESS,
`work/handcrafting/{aes_bp,skinny8}_area.csv` for handcrafting, and
`work/agema_{skinny,aes}/{aes_bp,skinny8}_areas.csv` for AGEMA.


We also synthesize existing masked S-box designs with yosys and Nangate45:


- Serialized Skinny8 S-box of [VCS22] (area report: `work/skinny_serialized/areas.csv`):

    ```
    make skinny_sbox_serialized
    ```

- DOM-indep AES S-box [GMK16] (area report: `work/DOM_aes_sbox/d{2,3,4,5}/area/area.json`):

    ```
    make dom_aes_sbox
    ```

- AES Sbox from [DSM22] (area report: `work/low_random_second_order_aes/area/area.json`):

    ```
    make lr_2OM_aes_sbox
    ```

- Skinny Sbox from [CCGB21] (area report: `work/skinny_ti/skinny-hdl-thresh-{222,2222,232,33}/area.json`):

    ```
    make skinny_ti
    ```

### Adders

Generation of masked adder circuits and their synthesis is very similar to the
S-boxes, with the following commands:

```
make adders_compress adders_handcrafting adders_agema
```

Area reports are generated respectively in `work/adders/*.csv`,
`work/adders_handcrafting/*.csv` and `work/adders_agema/*.csv`.

### COMPRESS gadget verification

COMPRESS comes with some new gadgets. In addition to the security proofs in the
paper, these gadgets can be verified at the first- and second-order using
[SILVER](https://github.com/chair-for-Security-Engineering/silver):

```
make silver
```

The first-order verification takes a few minutes, the second-order
verification of the larger gadgets ca take multiple hours.

If the first-order verification stalls, check that you are using the supported
SILVER version (see above).

### Full AES designs

For the 32-bit datapath:

- `make aes32beh` performs a behavioral simulation
- `make aes32synth` runs a synthesis (yosys+NanGate45), and compares with [SMAesH](https://github.com/SIMPLE-Crypto/SMAesH).
- `make aes32postsynth` verifies the synthesized circuit with a simulation
- `make aes32fullverif` runs [fullverif](https://github.com/cassiersg/fullverif) to verify the security of the implementation

The synthesis results summary is then located in `work/aes32synth/areas.csv`. The file contains entries for the following designs:

- `new`: AES (SMAesH based) with 4-cycles COMPRESS Sbox (Boyard Peralta repr.) 
- `newcanright`: AES (SMAesH based) with 4-cycles COMPRESS Sbox (Canright repr.)
- `smaesh`: SMAesH design using Sbox from [MCS22]. 

For the 128-bit datapath (round-based):

- `make aes128beh` performs a behavioral simulation
- `make aes128synth` runs a synthesis (yosys+NanGate45), and compares with the [related work](https://eprint.iacr.org/2022/252).
- `make aes128postsynth` verifies the synthesized circuit with a simulation
- `make aes128fullverif` runs [fullverif](https://github.com/cassiersg/fullverif) to verify the security of the implementation

The synthesis results summary is then located in `work/aes128synth/areas.csv`. The file contains entries for the following designs:

- `aeshpc`: AES with 6-cycles Sbox from [MCS22] 
- `new`: AES with 4-cycles COMPRESS Sbox (Boyard Peralta repr.)
- `newcanright`: AES with 4-cycles COMPRESS Sbox (Canright repr.)
- `new_1round`: 1 round AES pipeline (Boyard Peralta repr., does not include PRNG and state register/control MUXES).

For the (128-bit datapath) AES of AGEMA:

```
make aes128agema
```

For a round-based implementation (fully) generated with compress (Boyard Peralta repr.):

```
make aes_round_compress
```

The synthesis results summary is located in `work/aes_round_compress/aes_round_compress_area.csv`. In the paper, these results are compared with the "handmade" implementation of the round based implementation (i.e., the results reported for `new_1round` above).

## Installing Dependencies

In this section, we provide instructions for installing the dependencies on a
fresh Debian 12 install (bash shell).
These should be mostly portable to other linux distributions, we refer to the
individual tool's documentations for details.

- System packages (includes `iverilog`, `python3` and dependencies of the tools
    installed next).

    ```
    apt install python3-venv python3-pip git iverilog build-essential clang bison flex \
        libreadline-dev gawk tcl-dev libffi-dev git \
        graphviz xdot pkg-config python3 libboost-system-dev \
        libboost-python-dev libboost-filesystem-dev zlib1g-dev \
        libboost-all-dev gnat cmake libgmp-dev curl
    ```

- Put `~/.local` in `$PATH`

    ```
    export PATH=$HOME/.local:$PATH
    ```

- Yosys

    ```
    git clone https://github.com/YosysHQ/yosys
    cd yosys
    git checkout yosys-v0.33
    make config-gcc PREFIX=$HOME/.local
    make PREFIX=$HOME/.local
    make install PREFIX=$HOME/.local
    ```

- AGEMA (due to the challenges in building all AGEMA's dependencies, some are
    bundled in the git repo)

    ```
    git clone https://github.com/cassiersg/agema
    cd agema/AGEMA
    git checkout 9cf3e7bd7138606e5432b3d7a9de789250f4b8c6
    make clean
    make release
    ```

- SILVER (due to the challenges in building all SILVER's dependencies, some are
    bundled in the git repo)

    ```
    git clone https://github.com/cassiersg/SILVER
    cd SILVER
    git checkout ffa6b89a4a724fdbea74b5f74c815820974135c8
    make release
    ```

- GHDL

    ```
    git clone https://github.com/ghdl/ghdl
    cd ghdl
    git checkout v4.1.0
    ./configure --prefix=$HOME/.local
    make
    make install
    ```

- Rust

    ```
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    ```

- fullverif

    ```
    git clone https://github.com/cassiersg/fullverif
    git checkout 227f31215d8269c3b78bb0ebaebf6a1db6bc198e
    cd fullverif/fullverif-check
    cargo build --release
    ```


