
// pipeline and latency are dummy
module mux2_masked
#(parameter latency=1, parameter security_order=1, parameter pipeline=1)
(
  s, a, b, c
);
input wire s;
input wire [security_order:0] a;
input wire [security_order:0] b;
output wire [security_order:0] c;

assign c = s ? a : b;

endmodule

