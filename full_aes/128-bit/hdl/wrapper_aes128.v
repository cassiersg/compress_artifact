
/*
    CAUTION:
    this module is only inteded to evaluate the cost of the MSK128_bits togheter with a PRNG

*/ 

// Masked AES implementation using HPC masking scheme and 128-bit
// architecture.
`ifndef DEFAULTSHARES
`define DEFAULTSHARES 2
`endif
module wrapper_aes128
#
(
    parameter d = `DEFAULTSHARES,
    parameter PRNG_MAX_UNROLL = 512
)
(
    // Global
    nrst,
    clk,
    valid_in,
    ready,
    cipher_valid,
    // Data
    sh_plaintext,
    sh_key,
    sh_ciphertext,
    // PRNG interface
    prng_seed,
    prng_start_reseed,
    prng_out_ready,
    prng_out_valid,
    prng_busy
);

`include "design.vh"

//// IOs
// AES
input nrst;
input clk;
input valid_in;
output ready;
output cipher_valid;
input [128*d-1:0] sh_plaintext;
input [128*d-1:0] sh_key;
output [128*d-1:0] sh_ciphertext;
// PRNG
input [79:0] prng_seed;
input prng_start_reseed;
input prng_out_ready;
output prng_out_valid;
output prng_busy;


wire [20*rnd_bus0-1:0] rnd_bus0w;
wire [20*rnd_bus1-1:0] rnd_bus1w;
wire [20*rnd_bus2-1:0] rnd_bus2w;
`ifdef CANRIGHT_SBOX
wire [20*rnd_bus3-1:0] rnd_bus3w;
`endif

// Inner AES core
MSKaes_128bits_round_based
`ifndef CORE_SYNTHESIZED
#(
    .d(d),
    .LATENCY(4)
)
`endif
aes_core(
    .nrst(nrst),
    .clk(clk),
    .valid_in(valid_in),
    .ready(ready),
    .cipher_valid(cipher_valid),
    .sh_plaintext(sh_plaintext),
    .sh_key(sh_key),
    .sh_ciphertext(sh_ciphertext),
    .rnd_bus0w(rnd_bus0w),
    .rnd_bus1w(rnd_bus1w),
    .rnd_bus2w(rnd_bus2w)
`ifdef CANRIGHT_SBOX
    ,.rnd_bus3w(rnd_bus3w)
`endif
);

/* =========== PRNG =========== */
localparam NINIT=4*288;
`ifdef CANRIGHT_SBOX
localparam RND_AM = 20*(rnd_bus0+rnd_bus1+rnd_bus2+rnd_bus3);
`else
localparam RND_AM = 20*(rnd_bus0+rnd_bus1+rnd_bus2);
`endif
wire [RND_AM-1:0] rnd; 

prng_top #(.RND(RND_AM),.NINIT(NINIT),.MAX_UNROLL(PRNG_MAX_UNROLL))
prng_unit(
    .rst(~nrst),
    .clk(clk),
    .seed(prng_seed),
    .start_reseed(prng_start_reseed),
    .out_ready(prng_out_ready),
    .out_valid(prng_out_valid),
    .out_rnd(rnd),
    .busy(prng_busy)
);

assign rnd_bus0w = rnd[0 +: 20*rnd_bus0];
assign rnd_bus1w = rnd[20*rnd_bus0 +: 20*rnd_bus1];
assign rnd_bus2w = rnd[20*(rnd_bus0+rnd_bus1) +: 20*rnd_bus2];
`ifdef CANRIGHT_SBOX
assign rnd_bus3w = rnd[20*(rnd_bus0+rnd_bus1+rnd_bus2) +: 20*rnd_bus3];
`endif

endmodule
