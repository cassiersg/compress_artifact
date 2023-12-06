
# Synthesize AES implementations.


1. Pre-requisite: synthesize the AES S-boxes with COMPRESS.
2. Run synthesis of AES implementations:
```
make all_synth
```
3. Extract results:
```
make report
```
produces `areas.csv` and `areas_full_aes.tex`.
