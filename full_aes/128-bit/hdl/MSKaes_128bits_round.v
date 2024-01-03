module MSKaes_128bits_round
#
(
    parameter d = 2,
    parameter LATENCY = 4
)
(
    clk,
    sh_state_in,
    sh_key_in,
    sh_RCON,
    sh_state_out,
    sh_key_out,
    sh_state_SR_out,
    rnd_bus0w,
    rnd_bus1w,
    rnd_bus2w
);

`include "aes_bp.vh"

// Ports
input clk;
input [128*d-1:0] sh_state_in;
input [128*d-1:0] sh_key_in;
input [8*d-1:0] sh_RCON;
output [128*d-1:0] sh_state_out;
output [128*d-1:0] sh_state_SR_out;
output [128*d-1:0] sh_key_out;

input [20*rnd_bus0-1:0] rnd_bus0w;
input [20*rnd_bus1-1:0] rnd_bus1w;
input [20*rnd_bus2-1:0] rnd_bus2w;

// KS logic
MSKaes_128bits_KS_round #(.d(d), .LATENCY(LATENCY))
KS_mod(
    .clk(clk),
    .sh_key_in(
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
wire [128*d-1:0] sh_postSB; 
MSKaes_128bits_SB #(.d(d))
SB_unit(
    .clk(clk),
    .sh_state_in(sh_postAK),
    .sh_state_out(sh_postSB),
    .rnd_bus0w(rnd_bus0w[0 +: 16*rnd_bus0]),
    .rnd_bus1w(rnd_bus1w[0 +: 16*rnd_bus1]),
    .rnd_bus2w(rnd_bus2w[0 +: 16*rnd_bus2])
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

endmodule
