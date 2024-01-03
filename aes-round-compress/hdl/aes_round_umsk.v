module aes_round_umsk
(
    input [127:0] state_in,
    input [127:0] key_in,
    input [7:0] RCON,
    output [127:0] state_out,
    output [127:0] key_out
);

///// Key schedule logic
KS_round KS_mod(.kin(key_in),.kout(key_out),.RCON(RCON));

///// Round logic
// Key addition
wire [127:0] postAK = state_in ^ key_in;

// SB
wire [127:0] postSB;
genvar i;
generate
for(i=0;i<16;i=i+1) begin: sbox_inst
    sbox_bp_umsk sbox(.in(postAK[8*i +: 8]),.out(postSB[8*i +: 8])); 
end
endgenerate

// SR
wire [127:0] postSR;
SR_umsk SR_mod(.state_in(postSB), .state_out(postSR));


// MC
MC_umsk MC_mod(.state_in(postSR),.state_out(state_out));


endmodule
