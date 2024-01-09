(* fv_prop = "PINI", fv_strat = "flatten" *)
module MSKaes_128bits_SB
#
(
    parameter d = 2
)
(
    // Global
    clk,
    nrst,
    // Values
    sh_state_in,
    sh_state_out,
    // Randomness
    rnd_bus0w,
    rnd_bus1w,
    rnd_bus2w
`ifdef CANRIGHT_SBOX
    ,rnd_bus3w
`endif
);

`include "design.vh"

// IOs
input clk;
input nrst;

input [128*d-1:0] sh_state_in;
output [128*d-1:0] sh_state_out;

input [16*rnd_bus0-1:0] rnd_bus0w;
input [16*rnd_bus1-1:0] rnd_bus1w;
input [16*rnd_bus2-1:0] rnd_bus2w;
`ifdef CANRIGHT_SBOX
input [16*rnd_bus3-1:0] rnd_bus3w;
`endif

// Byte matrix representation
wire [8*d-1:0] sh_byte_in [15:0];
wire [8*d-1:0] sh_byte_out [15:0];


genvar i;
generate
for(i=0;i<16;i=i+1) begin: byte_in
    assign sh_byte_in[i] = sh_state_in[8*d*i +: 8*d];
end
endgenerate

// Create the SBOX
generate
for(i=0;i<16;i=i+1) begin: sbox_inst
    gen_bp_sbox #(.d(d))
    //bp_aes_sbox_msk_TOY #(.d(d))
    sbox_unit(
        .clk(clk),
        .i0(sh_byte_in[i][0*d +: d]),
        .i1(sh_byte_in[i][1*d +: d]),
        .i2(sh_byte_in[i][2*d +: d]),
        .i3(sh_byte_in[i][3*d +: d]),
        .i4(sh_byte_in[i][4*d +: d]),
        .i5(sh_byte_in[i][5*d +: d]),
        .i6(sh_byte_in[i][6*d +: d]),
        .i7(sh_byte_in[i][7*d +: d]),
        .rnd_bus0w(rnd_bus0w[i*rnd_bus0 +: rnd_bus0]),
        .rnd_bus1w(rnd_bus1w[i*rnd_bus1 +: rnd_bus1]),
        .rnd_bus2w(rnd_bus2w[i*rnd_bus2 +: rnd_bus2]),
`ifdef CANRIGHT_SBOX
        .rnd_bus3w(rnd_bus3w[i*rnd_bus3 +: rnd_bus3]),
`endif
        .o0(sh_byte_out[i][0*d +: d]),
        .o1(sh_byte_out[i][1*d +: d]),
        .o2(sh_byte_out[i][2*d +: d]),
        .o3(sh_byte_out[i][3*d +: d]),
        .o4(sh_byte_out[i][4*d +: d]),
        .o5(sh_byte_out[i][5*d +: d]),
        .o6(sh_byte_out[i][6*d +: d]),
        .o7(sh_byte_out[i][7*d +: d])
    );
end
endgenerate

// Assign output

generate
for(i=0;i<16;i=i+1) begin: byte_out
    assign sh_state_out[8*d*i +: 8*d] = sh_byte_out[i];
end
endgenerate



endmodule
