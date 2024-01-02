(* fv_prop = "PINI", fv_strat = "flatten", fv_order=d *)
module MSKaes_rcon
#
(
    parameter d = 2
)
(
    (* fv_type="clock" *)
    input clk,
    (* fv_type="control" *)
    input rst,
    // Update the rcon value
    (* fv_type="control" *)
    input update,
    (* fv_type="control" *)
    input mask_rcon,
    // RCON as a sharing 
    (* fv_type="sharing", fv_latency=0, fv_count=8 *)
    output [8*d-1:0] sh_rcon
);

//// Unshared rcon
reg [7:0] rcon, next_rcon;
always@(posedge clk) begin
    rcon <= next_rcon;
end

always@(*)
if(rst) begin
    next_rcon = 8'h01;
end else if(update) begin
    if(rcon[7]) begin
        next_rcon = 8'h1b;
    end else begin
        next_rcon = rcon << 1;
    end
end else begin
    next_rcon = rcon;
end

//// Output mux
wire [7:0] out_rcon;
assign out_rcon = rcon & {8{mask_rcon}};

//// Sharing
MSKcst #(.d(d),.count(8))
cst_sh_rcon(
    .cst(out_rcon),
    .out(sh_rcon)
);


endmodule
