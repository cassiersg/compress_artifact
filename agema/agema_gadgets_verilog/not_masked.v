module not_masked #(parameter low_latency=1, parameter security_order=1, parameter pipeline=1) (a, b);

input [security_order:0] a;
output [security_order:0] b;

assign b[0] = ~a[0];
assign b[security_order:1] = a[security_order:1];

endmodule
