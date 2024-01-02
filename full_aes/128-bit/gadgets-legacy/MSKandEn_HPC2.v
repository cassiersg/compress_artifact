(* fv_prop = "PINI", fv_strat = "assumed", fv_order=d *)
module MSKandEn_HPC2 #(parameter d=2) (ina, inb, rnd, clk, out, en);

`include "MSKand_hpc2.vh"

(* syn_keep = "true", keep = "true", S = "TRUE", DONT_TOUCH = "TRUE", fv_type = "sharing", fv_latency = 1 *) input  [d-1:0] ina;
(* syn_keep = "true", keep = "true", S = "TRUE", DONT_TOUCH = "TRUE", fv_type = "sharing", fv_latency = 0 *) input  [d-1:0] inb;
(* syn_keep = "true", keep = "true", S = "TRUE", DONT_TOUCH = "TRUE", fv_type = "random", fv_count = 1, fv_rnd_lat_0 = 0, fv_rnd_count_0 = hpc2rnd *) input [hpc2rnd-1:0] rnd;
(* fv_type = "clock" *) input clk;
(* syn_keep = "true", keep = "true", S = "TRUE", DONT_TOUCH = "TRUE", fv_type = "sharing", fv_latency = 2 *) output [d-1:0] out;
(* fv_type = "control" *) input en;   
                                      
genvar i,j;

// unpack vector to matrix --> easier for randomness handling
reg [hpc2rnd-1:0] rnd_prev;
always @(posedge clk)
if(en) begin
    rnd_prev <= rnd;
end /*else begin
    rnd_prev <= rnd_prev;
end */

wire [d-1:0] rnd_mat [d-1:0]; 
wire [d-1:0] rnd_mat_prev [d-1:0]; 
for(i=0; i<d; i=i+1) begin: igen
    assign rnd_mat[i][i] = 0;
    assign rnd_mat_prev[i][i] = 0;
    for(j=i+1; j<d; j=j+1) begin: jgen
        assign rnd_mat[j][i] = rnd[((i*d)-i*(i+1)/2)+(j-1-i)];
        //assign rnd_mat[i][j] = rnd_mat[j][i];
        // Changed for Verilator efficient simulation -> Avoid UNOPFLAT Warning (x2 simulation perfs enabled)
        assign rnd_mat[i][j] = rnd[((i*d)-i*(i+1)/2)+(j-1-i)];
        assign rnd_mat_prev[j][i] = rnd_prev[((i*d)-i*(i+1)/2)+(j-1-i)];
        //assign rnd_mat_prev[i][j] = rnd_mat_prev[j][i];
        // Changed for Verilator efficient simulation -> Avoid UNOPFLAT Warning (x2 simulation perfs enabled)
        assign rnd_mat_prev[i][j] = rnd_prev[((i*d)-i*(i+1)/2)+(j-1-i)];
    end
end

(* syn_keep = "true", keep = "true", S = "TRUE", DONT_TOUCH = "TRUE", keep = "true" *) wire [d-1:0] not_ina = ~ina;
(* syn_preserve = "true", preserve = "true" , keep = "true" , S = "TRUE", DONT_TOUCH = "TRUE" *) reg [d-1:0] inb_prev;
always @(posedge clk) 
if(en) begin
    inb_prev <= inb;
end /*else begin
    inb_prev <= inb_prev;
end */

for(i=0; i<d; i=i+1) begin: ParProdI
    (* syn_preserve = "true", preserve = "true" , keep = "true" , S = "TRUE", DONT_TOUCH = "TRUE" *) reg [d-2:0] u, v, w;
    (* syn_preserve = "true", preserve = "true" , keep = "true" , S = "TRUE", DONT_TOUCH = "TRUE" *) reg aibi;
    (* syn_keep = "true", keep = "true" , S = "TRUE", DONT_TOUCH = "TRUE" *) wire aibi_comb = ina[i] & inb_prev[i];
    always @(posedge clk) 
    if(en) begin
        aibi <= aibi_comb;
    end /*else begin
        aibi <= aibi;
    end */
    assign out[i] = aibi ^ ^u ^ ^w;
    for(j=0; j<d; j=j+1) begin: ParProdJ
        if (i != j) begin: NotEq
            localparam j2 = j < i ?  j : j-1;
            (* syn_keep = "true", keep = "true" , S = "TRUE", DONT_TOUCH = "TRUE" *) wire u_j2_comb = not_ina[i] & rnd_mat_prev[i][j];
            (* syn_keep = "true", keep = "true" , S = "TRUE", DONT_TOUCH = "TRUE" *) wire v_j2_comb = inb[j] ^ rnd_mat[i][j];
            (* syn_keep = "true", keep = "true" , S = "TRUE", DONT_TOUCH = "TRUE" *) wire w_j2_comb = ina[i] & v[j2];
            always @(posedge clk)
            if(en) begin
                u[j2] <= u_j2_comb;
                v[j2] <= v_j2_comb;
                w[j2] <= w_j2_comb;
            end /*else begin
                u[j2] <= u[j2]; 
                v[j2] <= v[j2];
                w[j2] <= w[j2];
            end */
        end
    end
end

endmodule
