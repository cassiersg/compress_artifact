module nand_HPC3 #(parameter security_order=1, parameter pipeline=1) (a, b, r, clk, c);

localparam half_rnd = security_order*(security_order+1)/2;


input wire [security_order:0] a, b;
input wire [2*half_rnd-1:0] r;
input wire clk;
output wire [security_order:0] c;

wire [security_order:0] na;
assign na[0] = ~a[0];
assign na[security_order:1] = a[security_order:1];

and_HPC3 #(security_order, pipeline) and_inner(na, b, r, clk, c);

endmodule
