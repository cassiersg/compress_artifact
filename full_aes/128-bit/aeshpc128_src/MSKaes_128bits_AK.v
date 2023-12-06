(* fv_prop = "affine", fv_strat = "composite", fv_order=d *)
module MSKaes_128bits_AK
#
(
    parameter d = 2
)
(
    sh_state_in,
    sh_key_in,
    sh_state_out
);

// IOs
(* fv_type="sharing", fv_latency=0, fv_count=128 *)
input [128*d-1:0] sh_state_in;
(* fv_type="sharing", fv_latency=0, fv_count=128 *)
input [128*d-1:0] sh_key_in;
(* fv_type="sharing", fv_latency=0, fv_count=128 *)
output [128*d-1:0] sh_state_out;

MSKxor #(.d(d), .count(128))
xor_add_AK(
    .ina(sh_state_in),
    .inb(sh_key_in),
    .out(sh_state_out)
);

endmodule
