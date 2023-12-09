// Module to perform the key scheduling
(* fv_prop = "PINI", fv_strat = "flatten" *)
module MSKaes_128bits_KS
#
(
    parameter d = 2
)
(
    // Global
    clk,
    nrst,
    // Data
    sh_key_in,
    sh_key_out,
    // Randomness
    rnd_bus0w,
    rnd_bus1w,
    rnd_bus2w,
    // Control
    data_in_valid,
    rcon_update,
    rcon_rst
);

// `include "MSKand_hpc2.vh"
`include "aes_bp.vh"

// IOs
input clk;
input nrst;

input [128*d-1:0] sh_key_in;
output [128*d-1:0] sh_key_out;

input [4*rnd_bus0-1:0] rnd_bus0w;
input [4*rnd_bus1-1:0] rnd_bus1w;
input [4*rnd_bus2-1:0] rnd_bus2w;

input data_in_valid;
input rcon_update;
input rcon_rst;

// Byte matrix representation
genvar i;
wire [8*d-1:0] sh_byte_in [15:0];
wire [8*d-1:0] sh_byte_out [15:0];

generate
for(i=0;i<16;i=i+1) begin: byte_in
    assign sh_byte_in[i] = sh_key_in[8*d*i +: 8*d];
end
endgenerate

// Rcon
wire [8*d-1:0] rcon_sh;
MSKaes_rcon #(.d(d))
rcon_unit(
    .clk(clk),
    .rst(rcon_rst),
    .update(rcon_update),
    .mask_rcon(1'b1),
    .sh_rcon(rcon_sh)
);

// Sbox for the key scheduling
wire [8*d-1:0] sh_byte_to_sb [3:0];
wire [8*d-1:0] sh_byte_from_sb [3:0];


generate
for(i=0;i<4;i=i+1) begin: sb_inst
    gen_bp_sbox #(.d(d))
    sbox_unit(
        .clk(clk),
        .i0(sh_byte_to_sb[i][0*d +: d]),
        .i1(sh_byte_to_sb[i][1*d +: d]),
        .i2(sh_byte_to_sb[i][2*d +: d]),
        .i3(sh_byte_to_sb[i][3*d +: d]),
        .i4(sh_byte_to_sb[i][4*d +: d]),
        .i5(sh_byte_to_sb[i][5*d +: d]),
        .i6(sh_byte_to_sb[i][6*d +: d]),
        .i7(sh_byte_to_sb[i][7*d +: d]),
        .rnd_bus0w(rnd_bus0w[i*rnd_bus0 +: rnd_bus0]),
        .rnd_bus1w(rnd_bus1w[i*rnd_bus1 +: rnd_bus1]),
        .rnd_bus2w(rnd_bus2w[i*rnd_bus2 +: rnd_bus2]),
        .o0(sh_byte_from_sb[i][0*d +: d]),
        .o1(sh_byte_from_sb[i][1*d +: d]),
        .o2(sh_byte_from_sb[i][2*d +: d]),
        .o3(sh_byte_from_sb[i][3*d +: d]),
        .o4(sh_byte_from_sb[i][4*d +: d]),
        .o5(sh_byte_from_sb[i][5*d +: d]),
        .o6(sh_byte_from_sb[i][6*d +: d]),
        .o7(sh_byte_from_sb[i][7*d +: d])
    );
end
endgenerate

// Constant used at the input of the SBox
wire [8*d-1:0] cst_zeros_byte;
MSKcst #(.d(d),.count(8))
cst_0(
    .cst(8'b0),
    .out(cst_zeros_byte)
);

// Assign input of Sbox: apply shift to last row first
MSKmux #(.d(d),.count(8))
muxb_SB0(
    .sel(data_in_valid),
    .in_true(sh_byte_in[13]),
    .in_false(cst_zeros_byte),
    .out(sh_byte_to_sb[0])
);

MSKmux #(.d(d),.count(8))
muxb_SB1(
    .sel(data_in_valid),
    .in_true(sh_byte_in[14]),
    .in_false(cst_zeros_byte),
    .out(sh_byte_to_sb[1])
);

MSKmux #(.d(d),.count(8))
muxb_SB2(
    .sel(data_in_valid),
    .in_true(sh_byte_in[15]),
    .in_false(cst_zeros_byte),
    .out(sh_byte_to_sb[2])
);

MSKmux #(.d(d),.count(8))
muxb_SB3(
    .sel(data_in_valid),
    .in_true(sh_byte_in[12]),
    .in_false(cst_zeros_byte),
    .out(sh_byte_to_sb[3])
);

//// Compute the new first column
wire [8*d-1:0] sh_byte_added_rcon;
MSKxor #(.d(d), .count(8))
xor_rcon(
    .ina(sh_byte_from_sb[0]),
    .inb(rcon_sh),
    .out(sh_byte_added_rcon)
);

MSKxor #(.d(d), .count(8))
xor_00(
    .ina(sh_byte_added_rcon),
    .inb(sh_byte_in[0]),
    .out(sh_byte_out[0])
);

MSKxor #(.d(d), .count(8))
xor_10(
    .ina(sh_byte_from_sb[1]),
    .inb(sh_byte_in[1]),
    .out(sh_byte_out[1])
);

MSKxor #(.d(d), .count(8))
xor_20(
    .ina(sh_byte_from_sb[2]),
    .inb(sh_byte_in[2]),
    .out(sh_byte_out[2])
);

MSKxor #(.d(d), .count(8))
xor_30(
    .ina(sh_byte_from_sb[3]),
    .inb(sh_byte_in[3]),
    .out(sh_byte_out[3])
);

// Compute the others columns
genvar j;
generate
for(i=0;i<3;i=i+1) begin: column_add
    for(j=0;j<4;j=j+1) begin: byte_add
        MSKxor #(.d(d), .count(8))
        xor_col(
            .ina(sh_byte_out[4*i+j]),
            .inb(sh_byte_in[4*(i+1)+j]),
            .out(sh_byte_out[4*(i+1)+j])
        );
    end
end
endgenerate

// Recombine bus
generate
for(i=0;i<16;i=i+1) begin: rec_bus
    assign sh_key_out[8*d*i +: 8*d] = sh_byte_out[i];
end
endgenerate


endmodule
