module xor_HPC3 #(parameter security_order=1, parameter pipeline=1) (a, b, c);
input wire [security_order:0] a, b;
output wire [security_order:0] c;
assign c = a ^ b;
endmodule
