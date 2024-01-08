module buf_clk(input wire C, input wire D, output wire Q);
reg t;
always @(posedge C) t <= D;
assign Q = t;
endmodule
