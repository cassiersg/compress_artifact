module nand_HPC2 #(parameter security_order=1, parameter pipeline=1) (a, b, r, clk, c);

localparam rnd = security_order*(security_order+1)/2;


input wire [security_order:0] a, b;
input wire [rnd-1:0] r;
input wire clk;
output wire [security_order:0] c;

wire [security_order:0] nc;

and_HPC2 #(security_order, pipeline) and_inner(a, b, r, clk, nc);

assign c[0] = ~nc[0];
assign c[security_order:1] = nc[security_order:1];

endmodule
