module nor_HPC2 #(parameter security_order=1, parameter pipeline=1) (a, b, r, clk, c);

localparam rnd = security_order*(security_order+1)/2;


input wire [security_order:0] a, b;
input wire [rnd-1:0] r;
input wire clk;
output wire [security_order:0] c;

wire [security_order:0] na, nb;
assign na[0] = ~a[0];
assign na[security_order:1] = a[security_order:1];
assign nb[0] = ~b[0];
assign nb[security_order:1] = b[security_order:1];

and_HPC2 #(security_order, pipeline) and_inner(na, nb, r, clk, c);

endmodule
