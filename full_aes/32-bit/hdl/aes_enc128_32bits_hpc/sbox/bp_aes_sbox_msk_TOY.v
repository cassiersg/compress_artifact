module bp_aes_sbox_msk_TOY
#
(
    parameter d=2,
    parameter OUT_LAT = 4 
)
(
    	// Circuit inputs IOs
	clk,
	i0,
	i1,
	i2,
	i3,
	i4,
	i5,
	i6,
	i7,
	rnd_bus0,
	rnd_bus2,
	rnd_bus3,
	rnd_bus4,
	// Circuit outputs IOs
	o0,
	o1,
	o2,
	o3,
	o4,
	o5,
	o6,
	o7
);

`include "MSKand_hpc2.vh"

// Inputs ports
input clk;
input [d-1:0] i0;
input [d-1:0] i1;
input [d-1:0] i2;
input [d-1:0] i3;
input [d-1:0] i4;
input [d-1:0] i5;
input [d-1:0] i6;
input [d-1:0] i7;
input [9*hpc2rnd-1:0] rnd_bus0;
input [3*hpc2rnd-1:0] rnd_bus2;
input [4*hpc2rnd-1:0] rnd_bus3;
input [18*hpc2rnd-1:0] rnd_bus4;

// Outputs ports
output [d-1:0] o0;
output [d-1:0] o1;
output [d-1:0] o2;
output [d-1:0] o3;
output [d-1:0] o4;
output [d-1:0] o5;
output [d-1:0] o6;
output [d-1:0] o7;

wire [7:0] in_sh0;
wire [7:0] out_sh0;

assign in_sh0[0] = ^i0;
assign in_sh0[1] = ^i1;
assign in_sh0[2] = ^i2;
assign in_sh0[3] = ^i3;
assign in_sh0[4] = ^i4;
assign in_sh0[5] = ^i5;
assign in_sh0[6] = ^i6;
assign in_sh0[7] = ^i7;

// Apply a umsk sbox directly on a single share
sbox_bp_umsk toy_sbox(
    .in(in_sh0),
    .out(out_sh0),
    .inverse(1'b0)
);

genvar i;
generate 
for(i=0;i<OUT_LAT;i=i+1) begin: stage
    wire [7:0] sin;
    reg [7:0] sout;

    always@(posedge clk) begin
        sout <= sin;
    end

    if(i==0) begin
        assign sin = out_sh0;
    end else begin
        assign sin = stage[i-1].sout;
    end
end
endgenerate

wire [7:0] lout_sh0 = stage[OUT_LAT-1].sout;

wire [d-1:0] zero = 0;

assign o0 = {zero,lout_sh0[0]};
assign o1 = {zero,lout_sh0[1]};
assign o2 = {zero,lout_sh0[2]};
assign o3 = {zero,lout_sh0[3]};
assign o4 = {zero,lout_sh0[4]};
assign o5 = {zero,lout_sh0[5]};
assign o6 = {zero,lout_sh0[6]};
assign o7 = {zero,lout_sh0[7]};

endmodule
