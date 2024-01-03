module KS_round(
    input [127:0] kin,
    output [127:0] kout,
    input [7:0] RCON
);

genvar i;
wire [7:0] k_bytes_in [15:0];
wire [7:0] k_bytes_out [15:0];

// Rely on byte representation
generate
for(i=0; i<16;i=i+1) begin: byte_in
    assign k_bytes_in[i] = kin[8*i +: 8]; 
    assign kout[8*i +: 8] = k_bytes_out[i];
end
endgenerate

// Sbox for last column
wire [7:0] lcol_SB [3:0];
sbox_bp_umsk lcol_SB0(.in(k_bytes_in[12]),.out(lcol_SB[0]));
sbox_bp_umsk lcol_SB1(.in(k_bytes_in[13]),.out(lcol_SB[1]));
sbox_bp_umsk lcol_SB2(.in(k_bytes_in[14]),.out(lcol_SB[2]));
sbox_bp_umsk lcol_SB3(.in(k_bytes_in[15]),.out(lcol_SB[3]));

// RCON addition
wire [7:0] lcol_SB_RCON[3:0];
assign lcol_SB_RCON[0] = lcol_SB[0] ^ RCON;
assign lcol_SB_RCON[1] = lcol_SB[1];
assign lcol_SB_RCON[2] = lcol_SB[2];
assign lcol_SB_RCON[3] = lcol_SB[3];

// Next round key generation
assign k_bytes_out[0] = lcol_SB_RCON[0] ^ k_bytes_in[0];
assign k_bytes_out[1] = lcol_SB_RCON[1] ^ k_bytes_in[1];
assign k_bytes_out[2] = lcol_SB_RCON[2] ^ k_bytes_in[2];
assign k_bytes_out[3] = lcol_SB_RCON[3] ^ k_bytes_in[3];

generate
for (i=1;i<4;i=i+1) begin: nkey_col
    assign k_bytes_out[0+4*i] = k_bytes_out[0+4*(i-1)] ^ k_bytes_in[0+4*i]; 
    assign k_bytes_out[1+4*i] = k_bytes_out[1+4*(i-1)] ^ k_bytes_in[1+4*i]; 
    assign k_bytes_out[2+4*i] = k_bytes_out[2+4*(i-1)] ^ k_bytes_in[2+4*i]; 
    assign k_bytes_out[3+4*i] = k_bytes_out[3+4*(i-1)] ^ k_bytes_in[3+4*i]; 
end
endgenerate

endmodule
