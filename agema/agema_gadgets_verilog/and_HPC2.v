module and_HPC2 #(parameter security_order=1, parameter pipeline=1) (a, b, r, clk, c);

localparam rnd = security_order*(security_order+1)/2;


input wire [security_order:0] a, b;
input wire [rnd-1:0] r;
input wire clk;
output wire [security_order:0] c;

`define HPC_FV

`ifdef HPC_FV
    wire [security_order:0] ar;
    MSKreg #(.d(security_order+1)) areg(.clk(clk), .in(a), .out(ar));
    MSKand_hpc2 #(.d(security_order+1)) and_inner(ar, b, r, clk, c);
`else
    and_HPC2_agema #(security_order, pipeline) and_inner(a, b, r, clk, c);
`endif

endmodule
