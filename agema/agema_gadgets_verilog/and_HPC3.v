module and_HPC3 #(parameter security_order=1, parameter pipeline=1) (a, b, r, clk, c);

localparam half_rnd = security_order*(security_order+1)/2;


input wire [security_order:0] a, b;
input wire [2*half_rnd-1:0] r;
input wire clk;
output wire [security_order:0] c;

`define HPC_FV

`ifdef HPC_FV
    MSKand_hpc3 #(.d(security_order+1)) and_inner(a, b, r, clk, c);
`else
    and_HPC_agema #(security_order, pipeline) and_inner(a, b, r, clk, c);
`endif

endmodule
