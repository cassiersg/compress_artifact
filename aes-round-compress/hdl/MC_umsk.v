
// Perform the xtime operation of AES
module xtime
(
    input [7:0] x,
    output [7:0] y
);
wire b7 = x[7];
wire [7:0] xshifted = {x[6:0],1'b0};
wire [7:0] cst_0x1b = 8'h1b;
wire [7:0] masked_0x1b = {8{b7}} & cst_0x1b;
assign y = xshifted ^ masked_0x1b;
endmodule

// For a given value over GF(256), compute the results of the 
// multipliction with 02 and 03 (used in MC)
module MC_mul
(
    input [7:0] v,
    output [7:0] vx2,
    output [7:0] vx3
);
xtime X2_inst(
    .x(v),
    .y(vx2)
);
assign vx3 = vx2 ^ v;
endmodule


// Perform the MC for a single column
module MC_single_column(
    input [7:0] in0,
    input [7:0] in1,
    input [7:0] in2,
    input [7:0] in3,
    output [7:0] out0,
    output [7:0] out1,
    output [7:0] out2,
    output [7:0] out3
);
wire [7:0] inX2 [3:0];
wire [7:0] inX3 [3:0];
MC_mul muli0(.v(in0),.vx2(inX2[0]),.vx3(inX3[0]));
MC_mul muli1(.v(in1),.vx2(inX2[1]),.vx3(inX3[1]));
MC_mul muli2(.v(in2),.vx2(inX2[2]),.vx3(inX3[2]));
MC_mul muli3(.v(in3),.vx2(inX2[3]),.vx3(inX3[3]));

assign out0 = inX2[0] ^ inX3[1] ^ in2 ^ in3;
assign out1 = in0 ^ inX2[1] ^ inX3[2] ^ in3;
assign out2 = in0 ^ in1 ^ inX2[2] ^ inX3[3];
assign out3 = inX3[0] ^ in1 ^ in2 ^ inX2[3];

endmodule

// Perform the MC for the full state
module MC_umsk(
    input [127:0] state_in,
    output [127:0] state_out
);

// Byte representation
wire [7:0] state_in_bytes [15:0];
wire [7:0] state_out_bytes [15:0];
genvar i;
generate
for(i=0; i<16;i=i+1) begin: state_byte
    assign state_in_bytes[i] = state_in[8*i +: 8];
    assign state_out[8*i +: 8] = state_out_bytes[i];
end
endgenerate

// Apply MC on every columns
generate
for(i=0;i<4;i=i+1) begin: colMC
    MC_single_column MC_mod(
        .in0(state_in_bytes[0+4*i]),
        .in1(state_in_bytes[1+4*i]),
        .in2(state_in_bytes[2+4*i]),
        .in3(state_in_bytes[3+4*i]),
        .out0(state_out_bytes[0+4*i]),
        .out1(state_out_bytes[1+4*i]),
        .out2(state_out_bytes[2+4*i]),
        .out3(state_out_bytes[3+4*i])
    );
end
endgenerate


endmodule
