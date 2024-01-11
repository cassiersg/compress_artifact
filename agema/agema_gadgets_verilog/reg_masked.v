
// pipeline and latency are dummy
module reg_masked
#(parameter latency=1, parameter security_order=1, parameter pipeline=1)
(
    clk, D, Q
);
input wire clk;
input wire [security_order:0] D;
output wire [security_order:0] Q;
reg [security_order:0] t;
always @(posedge clk) t <= D;
assign Q = t;
endmodule

