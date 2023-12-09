module wired_MSKaes_128bits
#
(
    parameter d = 2
)
(
    // Global
    nrst,
    clk,
    valid_in,
    ready,
    cipher_valid,
    // Data
    shares_plaintext,
    shares_key,
    shares_ciphertext,
    // Randomness busses (required for the Sboxes)
    rnd_bus0,
    rnd_bus2,
    rnd_bus3,
    rnd_bus4,
    pre_rnd0_valid,
    pre_rnd2_valid,
    pre_rnd3_valid,
    pre_rnd4_valid
);

`include "MSKand_hpc2.vh"

// IOs ports
input nrst;
input clk;
input valid_in;
output ready;
output cipher_valid;

input [128*d-1:0] shares_plaintext;
input [128*d-1:0] shares_key;
output [128*d-1:0] shares_ciphertext;

input [20*9*hpc2rnd-1:0] rnd_bus0;
input [20*3*hpc2rnd-1:0] rnd_bus2;
input [20*4*hpc2rnd-1:0] rnd_bus3;
input [20*18*hpc2rnd-1:0] rnd_bus4;

input pre_rnd0_valid;
input pre_rnd2_valid;
input pre_rnd3_valid;
input pre_rnd4_valid;

// Input wiring
wire [128*d-1:0] sh_key;
shares2shbus #(.d(d),.count(128))
s2b(
    .shares(shares_key),
    .shbus(sh_key)
);

// Input wiring
wire [128*d-1:0] sh_plaintext;
shares2shbus #(.d(d),.count(128))
s2b(
    .shares(shares_plaintext),
    .shbus(sh_plaintext)
);

// Output wiring
wire [128*d-1:0] sh_ciphertext;
shbus2shares #(.d(d),.count(128))
b2s(
    .shbus(sh_ciphertext),
    .shares(shares_ciphertext)
);

// wrapped module
MSKaes_128bits #(.d(d))
wm(
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
    .rnd_bus4(rnd_bus4),
    .pre_rnd0_valid(pre_rnd0_valid),
    .pre_rnd2_valid(pre_rnd2_valid),
    .pre_rnd3_valid(pre_rnd3_valid),
    .pre_rnd4_valid(pre_rnd4_valid)
);

endmodule
