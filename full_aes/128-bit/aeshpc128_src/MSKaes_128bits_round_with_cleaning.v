(* fv_prop = "PINI", fv_strat = "flatten" *)
module MSKaes_128bits_round_with_cleaning
#
(
    parameter d = 2,
    parameter LATENCY = 6
)
(
    clk,
    sh_state_in,
    sh_key_in,
    sh_RCON,
    sh_state_out,
    sh_key_out,
    sh_state_SR_out,
    sh_state_AK_out,
    rnd_bus0,
    rnd_bus2,
    rnd_bus3,
    rnd_bus4,
    cleaning_on
);

`include "MSKand_hpc2.vh"

// Ports
input clk;
input [128*d-1:0] sh_state_in;
input [128*d-1:0] sh_key_in;
input [8*d-1:0] sh_RCON;
output [128*d-1:0] sh_state_out;
output [128*d-1:0] sh_key_out;
output [128*d-1:0] sh_state_SR_out;
output [128*d-1:0] sh_state_AK_out;

input [20*9*hpc2rnd-1:0] rnd_bus0;
input [20*3*hpc2rnd-1:0] rnd_bus2;
input [20*4*hpc2rnd-1:0] rnd_bus3;
input [20*18*hpc2rnd-1:0] rnd_bus4;

input cleaning_on;

// Constant 0
wire [128*d-1:0] sh_zero;
MSKcst #(.d(d), .count(128))
cst_sh_zero(
    .cst(128'h0),
    .out(sh_zero)
);

// KS logic
wire [128*d-1:0] sh_key_in_cleaned;
MSKmux #(.d(d), .count(128))
mux_clean_key(
    .sel(cleaning_on),
    .in_true(sh_zero),
    .in_false(sh_key_in),
    .out(sh_key_in_cleaned)
);

MSKaes_128bits_KS_round #(.d(d), .LATENCY(LATENCY))
KS_mod(
    .clk(clk),
    .sh_key_in(sh_key_in_cleaned),
    .sh_key_out(sh_key_out),
    .sh_RCON_in(sh_RCON),
    .rnd_bus0(rnd_bus0[0 +: 4*9*hpc2rnd]),
    .rnd_bus2(rnd_bus2[0 +: 4*3*hpc2rnd]),
    .rnd_bus3(rnd_bus3[0 +: 4*4*hpc2rnd]),
    .rnd_bus4(rnd_bus4[0 +: 4*18*hpc2rnd])
);

// AK
wire [128*d-1:0] sh_postAK; 
MSKaes_128bits_AK #(.d(d))
AKmod(
    .sh_state_in(sh_state_in),
    .sh_key_in(sh_key_in),
    .sh_state_out(sh_postAK)
);

// SB 
wire [128*d-1:0] sh_postAK_cleaned;
MSKmux #(.d(d), .count(128))
mux_clean_sbox(
    .sel(cleaning_on),
    .in_true(sh_zero),
    .in_false(sh_postAK),
    .out(sh_postAK_cleaned)
);

wire [128*d-1:0] sh_postSB; 
MSKaes_128bits_SB #(.d(d))
SB_unit(
    .clk(clk),
    .sh_state_in(sh_postAK_cleaned),
    .sh_state_out(sh_postSB),
    .rnd_bus0(rnd_bus0[4*9*hpc2rnd +: 16*9*hpc2rnd]),
    .rnd_bus2(rnd_bus2[4*3*hpc2rnd +: 16*3*hpc2rnd]),
    .rnd_bus3(rnd_bus3[4*4*hpc2rnd +: 16*4*hpc2rnd]),
    .rnd_bus4(rnd_bus4[4*18*hpc2rnd +: 16*18*hpc2rnd])
);

// SR 
wire [128*d-1:0] sh_postSR;
MSKaes_128bits_SR #(.d(d))
SR_unit(
    .sh_state_in(sh_postSB),
    .sh_state_out(sh_postSR)
);

// MC
MSKaes_128bits_MC #(.d(d))
MC_unit(
    .sh_state_in(sh_postSR),
    .sh_state_out(sh_state_out)
);

assign sh_state_SR_out = sh_postSR;
assign sh_state_AK_out = sh_postAK;

endmodule
