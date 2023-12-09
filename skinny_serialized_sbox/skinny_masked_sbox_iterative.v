`ifndef DEFAULTSHARES
`define DEFAULTSHARES 2
`endif
module MSKsbox #(parameter d = `DEFAULTSHARES)(in, en2, en3, en4, en5, sel1a1, sel2a1, sel1b1, sel2b1, sel1x1, sel2x1, sel1a2, sel1b2, sel1x2, sel2a2, sel2b2, sel2x2, rnd, clk, out);
localparam and_pini_mul_nrnd = d*(d-1)/2;
localparam and_pini_nrnd = and_pini_mul_nrnd;
input  [8*d-1:0] in;
input [2*and_pini_nrnd-1:0] rnd;
input clk;
output [8*d-1:0] out;
input en2, en3, en4, en5, sel1a1, sel2a1, sel1b1, sel2b1, sel1x1, sel2x1, sel1a2, sel1b2, sel1x2, sel2a2, sel2b2, sel2x2;

wire [d-1:0] in8, in1, in2, in3, in4, in5, in6, in7, in3_F, in3_FF, ina_1, ina_2, inb_1, inb_2, inv_a_1, inv_a_2, inv_b_1, inv_b_2, inxor_1, inxor_2, nand_1, nand_2;
wire [d-1:0] out0, out1, out2, out3, out4, out5, out6, out7, out1_F;
wire [d-1:0] mux1a1_out, mux2a1_out, mux1b1_out, mux2b1_out, mux1x1_out, mux2x1_out, mux1a2_out, mux2a2_out, mux1b2_out, mux2b2_out, mux1x2_out, mux2x2_out;
wire [d-1:0] in1_F, in1_FF,in1_FFF, in2_F, in2_FF, in2_FFF, in2_FFFF, in2_FFFFF, in2_FFFFFF, in2_FFFFFFF, in3_FFF, in3_FFFF, in3_FFFFF, in3_FFFFFF, in3_FFFFFFF;
wire [d-1:0] in4_F, in4_FF, in4_FFF, in4_FFFF, in4_FFFFF, in4_FFFFFF, in5_F, in5_FF, in5_FFF, in6_F, in6_FF, in6_FFF, in6_FFFF, in6_FFFFF, in7_F, in7_FF, in7_FFF, in7_FFFF;
wire [d-1:0] in8_F, in8_FF, in8_FFF, in8_FFFF, in8_FFFFF, in8_FFFFFF;
assign in1 = in[0 +: d];
assign in2 = in[d +: d];
assign in3 = in[2*d +: d];
assign in4 = in[3*d +: d];
assign in5 = in[4*d +: d];
assign in6 = in[5*d +: d];
assign in7 = in[6*d +: d];
assign in8 = in[7*d +: d];

// Module 1

MSKinv #(d) inv1 (ina_1, inv_a_1);
MSKinv #(d) inv2 (inb_1, inv_b_1);
MSKand_hpc2 #(d) andg1(inv_a_1, inv_b_1, rnd[0 +: and_pini_nrnd], clk, nand_1);
MSKxor #(d) xorg1(nand_1, inxor_1, out1);

// Module 2
MSKinv #(d) inv3 (ina_2, inv_a_2);
MSKinv #(d) inv4 (inb_2, inv_b_2);
MSKand_hpc2 #(d) andg2(inv_a_2, inv_b_2, rnd[and_pini_nrnd-1 +: and_pini_nrnd], clk, nand_2);
MSKxor #(d) xorg2(nand_2, inxor_2, out2);

// Regs

MSKreg #(d) reg_in1_F (clk, in1, in1_F);
MSKreg #(d) reg_in1_FF (clk, in1_F, in1_FF);
MSKreg #(d) reg_in1_FFF (clk, in1_FF, in1_FFF);

MSKreg #(d) reg_in2_F (clk, in2, in2_F);
MSKreg #(d) reg_in2_FF (clk, in2_F, in2_FF);
MSKreg #(d) reg_in2_FFF (clk, in2_FF, in2_FFF);
MSKreg #(d) reg_in2_FFFF (clk, in2_FFF, in2_FFFF);
MSKreg #(d) reg_in2_FFFFF (clk, in2_FFFF, in2_FFFFF);

MSKreg #(d) reg_in3_F (clk, in3, in3_F);
MSKreg #(d) reg_in3_FF (clk, in3_F, in3_FF);
MSKreg #(d) reg_in3_FFF (clk, in3_FF, in3_FFF);
MSKreg #(d) reg_in3_FFFF (clk, in3_FFF, in3_FFFF);
MSKreg #(d) reg_in3_FFFFF (clk, in3_FFFF, in3_FFFFF);
MSKreg #(d) reg_in3_FFFFFF (clk, in3_FFFFF, in3_FFFFFF);
MSKreg #(d) reg_in3_FFFFFFF (clk, in3_FFFFFF, in3_FFFFFFF);

MSKreg #(d) reg_in4_F (clk, in4, in4_F);
MSKreg #(d) reg_in4_FF (clk, in4_F, in4_FF);
MSKreg #(d) reg_in4_FFF (clk, in4_FF, in4_FFF);
MSKreg #(d) reg_in4_FFFF (clk, in4_FFF, in4_FFFF);
MSKreg #(d) reg_in4_FFFFF (clk, in4_FFFF, in4_FFFFF);
MSKreg #(d) reg_in4_FFFFFF (clk, in4_FFFFF, in4_FFFFFF);

MSKreg #(d) reg_in5_F (clk, in5, in5_F);
MSKreg #(d) reg_in5_FF (clk, in5_F, in5_FF);
MSKreg #(d) reg_in5_FFF (clk, in5_FF, in5_FFF);

MSKreg #(d) reg_in6_F (clk, in6, in6_F);
MSKreg #(d) reg_in6_FF (clk, in6_F, in6_FF);
MSKreg #(d) reg_in6_FFF (clk, in6_FF, in6_FFF);
MSKreg #(d) reg_in6_FFFF (clk, in6_FFF, in6_FFFF);
MSKreg #(d) reg_in6_FFFFF (clk, in6_FFFF, in6_FFFFF);

MSKreg #(d) reg_in7_F (clk, in7, in7_F);
MSKreg #(d) reg_in7_FF (clk, in7_F, in7_FF);
MSKreg #(d) reg_in7_FFF (clk, in7_FF, in7_FFF);
MSKreg #(d) reg_in7_FFFF (clk, in7_FFF, in7_FFFF);

MSKreg #(d) reg_in8_F (clk, in8, in8_F);
MSKreg #(d) reg_in8_FF (clk, in8_F, in8_FF);
MSKreg #(d) reg_in8_FFF (clk, in8_FF, in8_FFF);
MSKreg #(d) reg_in8_FFFF (clk, in8_FFF, in8_FFFF);
MSKreg #(d) reg_in8_FFFFF (clk, in8_FFFF, in8_FFFFF);
MSKreg #(d) reg_in8_FFFFFF (clk, in8_FFFFF, in8_FFFFFF);

MSKregEn #(d) reg_o_0 (clk, en2, out1, out[7*d-1 : 6*d]);
MSKregEn #(d) reg_o_1 (clk, en2, out2, out[6*d-1 : 5*d]);
MSKregEn #(d) reg_o_2 (clk, en3, out1, out[3*d-1 : 2*d]);
MSKregEn #(d) reg_o_3 (clk, en4, out2, out[8*d-1 : 7*d]);
MSKregEn #(d) reg_o_4 (clk, en4, out1, out[4*d-1 : 3*d]);
MSKregEn #(d) reg_o_5 (clk, en5, out2, out[2*d-1 : d]);
MSKregEn #(d) reg_o_6 (clk, en5, out1, out[5*d-1:4*d]);
assign out[d-1 : 0] = out2;

// Muxs

//  Stage 1
MSKmux #(d) mux1a1 (sel1a1, in3_FF, in8_F, mux1a1_out);
MSKmux #(d) mux2a1 (sel1a1, out2, out[6*d-1:5*d], mux2a1_out);
MSKmux #(d) mux3a1 (sel2a1, mux2a1_out, mux1a1_out, ina_1);

MSKmux #(d) mux1b1 (sel1b1, in2_F, in7, mux1b1_out);
MSKmux #(d) mux2b1 (sel1b1, out[7*d-1:6*d], in4_FF, mux2b1_out);
MSKmux #(d) mux3b1 (sel2b1, mux2b1_out, mux1b1_out, inb_1);

MSKmux #(d) mux1x1 (sel1x1, in7_FFF, in5_FF, mux1x1_out);
MSKmux #(d) mux2x1 (sel1x1, in4_FFFFF, in2_FFFF, mux2x1_out);
MSKmux #(d) mux3x1 (sel2x1, mux2x1_out, mux1x1_out, inxor_1);
//  Stage 2
MSKmux #(d) mux1a2 (sel1a2, out[7*d-1:6*d], in4_F, mux1a2_out);
MSKmux #(d) mux2a2 (sel1a2, out2 , out2, mux2a2_out); //out2 = out[8*d-1:7*d]
MSKmux #(d) mux3a2 (sel2a2, mux2a2_out, mux1a2_out, ina_2);

MSKmux #(d) mux1b2 (sel1b2, out2, in3, mux1b2_out); //out2 = out[6*d-1:5*d]
MSKmux #(d) mux2b2 (sel1b2, out1, out1, mux2b2_out); //out1 = out[4*d-1:3*d]
MSKmux #(d) mux3b2 (sel2b2, mux2b2_out, mux1b2_out, inb_2);

MSKmux #(d) mux1x2 (sel1x2, in6_FFFF, in1_FF, mux1x2_out);
MSKmux #(d) mux2x2 (sel1x2, in3_FFFFFF, in8_FFFFF, mux2x2_out);
MSKmux #(d) mux3x2 (sel2x2, mux2x2_out, mux1x2_out, inxor_2);


endmodule
