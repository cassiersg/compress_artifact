(* fv_prop = "PINI", fv_strat = "flatten" *)
module MSKaes_128bits_pipe_ctrl
#
(
    parameter LATENCY = 6 
)
(
    input clk,
    input nrst,
    input [7:0] RCON_in,
    output [7:0] RCON_delayed,
    output [7:0] RCON_out
);

// Delay pipeline for RCON
genvar i;
generate
for(i=0;i<LATENCY;i=i+1) begin: ctrl_stage
    wire [7:0] D;
    reg [7:0] Q;
    always@(posedge clk) 
    if(~nrst) begin
        Q <= 0;
    end else begin
        Q <= D;
    end
    if (i==0) begin
        assign D = RCON_in; 
    end else begin
        assign D = ctrl_stage[i-1].Q;
    end
end
endgenerate
assign RCON_delayed = ctrl_stage[LATENCY-1].Q;

// LFSR update function for the next value
wire [7:0] shifted_RCON = {RCON_delayed[6:0],1'b0};
wire [7:0] masked_0x1b = {8{RCON_delayed[7]}} & 8'h1b;
assign RCON_out = shifted_RCON ^ masked_0x1b;


endmodule
