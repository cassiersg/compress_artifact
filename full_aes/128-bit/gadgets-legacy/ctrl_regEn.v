// register with enable signal for control signal propagation
(* fv_strat = "flatten" *)
module ctrl_regEn
#(
    parameter l = 1
)
(
    clk,
    en,
    rst,
    in,
    out
);

(* fv_type = "clock" *) input clk;
(* fv_type = "control" *) input en;
(* fv_type = "control" *) input rst;
(* fv_type = "control" *) input [l-1:0] in;
(* fv_type = "control" *) output [l-1:0] out;

reg [l-1:0] reg_val;
always@(posedge clk)
if(rst) begin
    reg_val <= 0;
end else if(en) begin
    reg_val <= in;
end else begin
    reg_val <= reg_val;
end


assign out = reg_val;


endmodule
