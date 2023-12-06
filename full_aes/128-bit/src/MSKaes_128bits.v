(* fv_prop = "PINI", fv_strat = "composite", fv_order=d *)
module MSKaes_128bits
#
(
    parameter d=2
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
    // Randomness busses (required for the Sboxes)
    rnd_bus0w,
    rnd_bus1w,
    rnd_bus2w
);

//`include "MSKand_hpc2.vh"
`include "aes_bp.vh"

// IOs ports
(* fv_type="control" *)
input nrst;
(* fv_type="clock" *)
input clk;
(* fv_type="control" *)
input valid_in;
(* fv_type="control" *)
output ready;
(* fv_type="control" *)
output cipher_valid;

(* fv_type="sharing", fv_latency=0, fv_count=128 *)
input [128*d-1:0] sh_plaintext;
(* fv_type="sharing", fv_latency=0, fv_count=128 *)
input [128*d-1:0] sh_key;
(* fv_type="sharing", fv_latency=71, fv_count=128 *)
output [128*d-1:0] sh_ciphertext;

(* fv_type="random", fv_count=0, fv_rnd_count_0=20*rnd_bus0 *)
input [20*rnd_bus0-1:0] rnd_bus0w;
(* fv_type="random", fv_count=0, fv_rnd_count_0=20*rnd_bus1 *)
input [20*rnd_bus1-1:0] rnd_bus1w;
(* fv_type="random", fv_count=0, fv_rnd_count_0=20*rnd_bus2 *)
input [20*rnd_bus2-1:0] rnd_bus2w;

// Sharing of the plaintext
wire gated_valid_in = valid_in && ready;

// Register for the state
wire [128*d-1:0] sh_to_state_reg;
wire [128*d-1:0] sh_from_state_reg;
wire enable_state_reg;

MSKregEn #(.d(d),.count(128))
reg_state(
    .clk(clk),
    .en(enable_state_reg),
    .in(sh_to_state_reg),
    .out(sh_from_state_reg)
);

// Register for the key
wire [128*d-1:0] sh_to_key_reg;
wire [128*d-1:0] sh_from_key_reg;
wire enable_key_reg;

MSKregEn #(.d(d),.count(128))
reg_key(
    .clk(clk),
    .en(enable_key_reg),
    .in(sh_to_key_reg),
    .out(sh_from_key_reg)
);

// Mux input register state
wire [128*d-1:0] sh_loop_lastR_state;
wire [128*d-1:0] sh_loop_R_state;

wire [128*d-1:0] sh_loop_state;
wire ctrl_mux_state_lastR;
wire ctrl_mux_feed_in;

MSKmux #(.d(d), .count(128))
mux_loop_state(
    .sel(ctrl_mux_state_lastR),
    .in_true(sh_loop_lastR_state),
    .in_false(sh_loop_R_state),
    .out(sh_loop_state)
);

MSKmux #(.d(d), .count(128))
mux_feed_state(
    .sel(ctrl_mux_feed_in),
    .in_true(sh_plaintext),
    .in_false(sh_loop_state),
    .out(sh_to_state_reg)
);

// Mux input register key
wire [128*d-1:0] cst_sh_key;
MSKcst #(.d(d),.count(128))
cst_sh_key_gadget(
    .cst(128'b0),
    .out(cst_sh_key)
);

wire [128*d-1:0] gated_sh_key;
MSKmux #(.d(d),.count(128))
mux_in_key_holder(
    .sel(gated_valid_in),
    .in_true(sh_key),
    .in_false(cst_sh_key),
    .out(gated_sh_key)
);

wire [128*d-1:0] sh_loop_key;
MSKmux #(.d(d),.count(128))
mux_loop_key(
    .sel(ctrl_mux_feed_in),
    .in_true(gated_sh_key),
    .in_false(sh_loop_key),
    .out(sh_to_key_reg)
);

//// Constant zeros inputs 
wire [128*d-1:0] sh_cst_zeros;
MSKcst #(.d(d),.count(128))
cst_0s(
    .cst(128'b0),
    .out(sh_cst_zeros)
);

//// Create the state logic
// AK
wire [128*d-1:0] sh_from_AK;
MSKaes_128bits_AK #(.d(d))
AK_unit(
    .sh_state_in(sh_from_state_reg),
    .sh_key_in(sh_from_key_reg),
    .sh_state_out(sh_from_AK)
);

// Sbox
wire SB_valid_in;

wire [128*d-1:0] sh_SB_gated_in;
MSKmux #(.d(d),.count(128))
mux_in_SB(
    .sel(SB_valid_in),
    .in_true(sh_from_AK),
    .in_false(sh_cst_zeros),
    .out(sh_SB_gated_in)
);

wire [128*d-1:0] sh_from_SB;
MSKaes_128bits_SB #(.d(d))
SB_unit(
    .clk(clk),
    .nrst(nrst),
    .sh_state_in(sh_SB_gated_in),
    .sh_state_out(sh_from_SB),
    .rnd_bus0w(rnd_bus0w[0 +: 16*rnd_bus0]),
    .rnd_bus1w(rnd_bus1w[0 +: 16*rnd_bus1]),
    .rnd_bus2w(rnd_bus2w[0 +: 16*rnd_bus2])
);

// SR
wire [128*d-1:0] sh_from_SR;
MSKaes_128bits_SR #(.d(d))
SR_unit(
    .sh_state_in(sh_from_SB),
    .sh_state_out(sh_from_SR)
);

// MC
wire [128*d-1:0] sh_from_MC;
MSKaes_128bits_MC #(.d(d))
MC_unit(
    .sh_state_in(sh_from_SR),
    .sh_state_out(sh_from_MC)
);

// Assign feedback
assign sh_loop_R_state = sh_from_MC;
assign sh_loop_lastR_state = sh_from_SR;

//// Create the key logic 
wire [128*d-1:0] sh_key_from_KS;

wire KS_in_valid;
wire KS_rcon_update;
wire KS_rcon_rst;

// Timing of pre_need similar than the one of state Sbox -> not used
MSKaes_128bits_KS #(.d(d))
KS_unit(
    .clk(clk),
    .nrst(nrst),
    .sh_key_in(sh_from_key_reg),
    .sh_key_out(sh_key_from_KS),
    .rnd_bus0w(rnd_bus0w[16*rnd_bus0 +: 4*rnd_bus0]),
    .rnd_bus1w(rnd_bus1w[16*rnd_bus1 +: 4*rnd_bus1]),
    .rnd_bus2w(rnd_bus2w[16*rnd_bus2 +: 4*rnd_bus2]),
    .data_in_valid(KS_in_valid),
    .rcon_update(KS_rcon_update),
    .rcon_rst(KS_rcon_rst)
);

assign sh_loop_key = sh_key_from_KS;

// FSM 
MSKaes_128bits_fsm
fsm_unit(
    .clk(clk),
    .nrst(nrst),
    .valid_in(valid_in),
    .ready(ready),
    .cipher_valid(cipher_valid),
    .feed_in(ctrl_mux_feed_in),
    .state_reg_enable(enable_state_reg),
    .state_mux_lastR(ctrl_mux_state_lastR),
    .key_reg_enable(enable_key_reg),
    .SB_valid_in(SB_valid_in),
    .KS_in_valid(KS_in_valid),
    .KS_rcon_update(KS_rcon_update),
    .KS_rcon_rst(KS_rcon_rst)
);

// Mux at the output, to only output data when required
wire [128*d-1:0] zeros_out;
MSKcst #(.d(d),.count(128))
cst_sh_zeros(
    .cst(128'b0),
    .out(zeros_out)
);

MSKmux #(.d(d),.count(128))
mux_out(
    .sel(cipher_valid),
    .in_true(sh_from_AK),
    .in_false(zeros_out),
    .out(sh_ciphertext)
);

endmodule
