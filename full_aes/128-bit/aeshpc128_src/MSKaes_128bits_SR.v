(* fv_prop = "PINI", fv_strat = "composite", fv_order=d*)
module MSKaes_128bits_SR
#
(
    parameter d = 2
)
(
    sh_state_in,
    sh_state_out
);

// IOs
(* fv_type="sharing", fv_latency=0, fv_count=128 *)
input [128*d-1:0] sh_state_in;
(* fv_type="sharing", fv_latency=0, fv_count=128 *)
output [128*d-1:0] sh_state_out;

// Byte matrix representation
genvar i;
wire [8*d-1:0] sh_byte_in [15:0];
wire [8*d-1:0] sh_byte_out [15:0];

generate
for(i=0;i<16;i=i+1) begin: byte_in
    assign sh_byte_in[i] = sh_state_in[8*d*i +: 8*d];
end
endgenerate

// Apply the shift row application
assign sh_byte_out[0] = sh_byte_in[0];
assign sh_byte_out[1] = sh_byte_in[5];
assign sh_byte_out[2] = sh_byte_in[10];
assign sh_byte_out[3] = sh_byte_in[15];

assign sh_byte_out[4] = sh_byte_in[4];
assign sh_byte_out[5] = sh_byte_in[9];
assign sh_byte_out[6] = sh_byte_in[14];
assign sh_byte_out[7] = sh_byte_in[3];

assign sh_byte_out[8] = sh_byte_in[8];
assign sh_byte_out[9] = sh_byte_in[13];
assign sh_byte_out[10] = sh_byte_in[2];
assign sh_byte_out[11] = sh_byte_in[7];

assign sh_byte_out[12] = sh_byte_in[12];
assign sh_byte_out[13] = sh_byte_in[1];
assign sh_byte_out[14] = sh_byte_in[6];
assign sh_byte_out[15] = sh_byte_in[11];

// Recombine output bus
generate
for(i=0;i<16;i=i+1) begin: byte_out
    assign sh_state_out[8*d*i +: 8*d] = sh_byte_out[i];
end
endgenerate


endmodule
