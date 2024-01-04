
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

`include "MSKand_hpc2.vh"

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

localparam rnd0 = 9*hpc2rnd;
localparam rnd2 = 3*hpc2rnd;
localparam rnd3 = 4*hpc2rnd;
localparam rnd4 = 18*hpc2rnd;

wire [20*rnd0-1:0] rnd_bus0;
wire [20*rnd2-1:0] rnd_bus2;
wire [20*rnd3-1:0] rnd_bus3;
wire [20*rnd4-1:0] rnd_bus4;

// Inner AES core
MSKaes_128bits_round_based
`ifndef CORE_SYNTHESIZED
#(
    .d(d)
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
    .rnd_bus0(rnd_bus0),
    .rnd_bus2(rnd_bus2),
    .rnd_bus3(rnd_bus3),
    .rnd_bus4(rnd_bus4)
);

/* =========== PRNG =========== */
localparam NINIT=4*288;
localparam RND_AM = 20*(rnd0+rnd2+rnd3+rnd4);
wire [RND_AM-1:0] rnd; 

prng_top #(.RND(RND_AM),.NINIT(NINIT),.MAX_UNROLL(PRNG_MAX_UNROLL))
prng_unit(
    .rst(~nrst),
    .clk(clk),
    .seed(prng_seed),
    .start_reseed(prng_start_reseed),
    .out_ready(prng_out_ready),
    .out_valid(prng_out_valid),
    .out_rnd(prng_out_rnd),
    .busy(prng_busy)
);

assign rnd_bus0 = rnd[0 +: 20*rnd0];
assign rnd_bus2 = rnd[20*rnd0 +: 20*rnd2];
assign rnd_bus3 = rnd[20*(rnd0+rnd2) +: 20*rnd3];
assign rnd_bus4 = rnd[20*(rnd0+rnd2+rnd3) +: 20*rnd4];


endmodule
