(* fv_prop = "PINI", fv_strat = "composite", fv_order=d *)
module MSKaes_128bits_MC
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

// Create the instances of Mixcolumn multiplication
generate
for(i=0;i<4;i=i+1) begin: mulcol
    MSKaesMC #(.d(d))
    mulMC(
        .a0(sh_byte_in[i*4+0]),
        .a1(sh_byte_in[i*4+1]),
        .a2(sh_byte_in[i*4+2]),
        .a3(sh_byte_in[i*4+3]),
        .b0(sh_byte_out[i*4+0]),
        .b1(sh_byte_out[i*4+1]),
        .b2(sh_byte_out[i*4+2]),
        .b3(sh_byte_out[i*4+3])
    );
end
endgenerate


// Re-create output bus
generate
for(i=0;i<16;i=i+1) begin: byte_out
    assign sh_state_out[8*d*i +: 8*d] = sh_byte_out[i];
end
endgenerate

endmodule
