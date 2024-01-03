module SR_umsk(
    input [127:0] state_in,
    output [127:0] state_out
);

genvar i;
wire [7:0] state_bytes_in [15:0];
wire [7:0] state_bytes_out [15:0];

// Rely on byte representation
generate
for(i=0; i<16;i=i+1) begin: byte_in
    assign state_bytes_in[i] = state_in[8*i +: 8]; 
    assign state_out[8*i +: 8] = state_bytes_out[i];
end
endgenerate

// Apply the permutation
genvar j;
generate
for(i=0;i<4;i=i+1) begin: row
    for(j=0;j<4;j=j+1) begin: col
        //integer byte_index = 4*j + i;
        //integer new_byte_index = (byte_index + i*4) % 16;
        assign state_bytes_out[4*j+i] = state_bytes_in[(4*j+i+i*4)%16];
    end
end
endgenerate


endmodule
