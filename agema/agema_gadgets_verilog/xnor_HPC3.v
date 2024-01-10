module xnor_HPC3 #(parameter security_order=1, parameter pipeline=1) (a, b, c);
input wire [security_order:0] a, b;
output wire [security_order:0] c;
assign c[0] = ~a[0] ^ b[0];
assign c[security_order:1] = a[security_order:1] ^ b[security_order:1];
endmodule
