# Formal verification with fullverif

## Dependencies

The verification requires the following tools (indicated versions are known to work):

- Yosys 0.33 (git sha1 2584903a0)
- iverilog (11.0)
- fullverif (git sha1 227f3121)

## Execution

Run the following script
```
./run_fullverif.sh
```

`yosys`, `iverilog`, `vvp` and `fullverif` must be in path, or their path can
be indicated as an environment variable with their capitalized name (e.g.,
`FULLVERIF=/path/to/fullverif/binary`).

