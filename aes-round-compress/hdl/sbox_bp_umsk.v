module sbox_bp_umsk(
    input [7:0] in,
    output [7:0] out
);

wire [7:0] u;

// reverse endianess
assign u[0] = in[7];
assign u[1] = in[6];
assign u[2] = in[5];
assign u[3] = in[4];
assign u[4] = in[3];
assign u[5] = in[2];
assign u[6] = in[1];
assign u[7] = in[0];

// Top linear transform forward
wire t1f = u[0] ^ u[3];
wire t2f = u[0] ^ u[5];
wire t3f = u[0] ^ u[6];
wire t4f = u[3] ^ u[5];
wire t5f = u[4] ^ u[6];
wire t6f = t1f ^ t5f;
wire t7f = u[1] ^ u[2];

wire t8f = u[7] ^ t6f;
wire t9f = u[7] ^ t7f;
wire t10f = t6f ^ t7f;
wire t11f = u[1] ^ u[5];
wire t12f = u[2] ^ u[5];
wire t13f = t3f ^ t4f;
wire t14f = t6f ^ t11f;

wire t15f = t5f ^ t11f;
wire t16f = t5f ^ t12f;
wire t17f = t9f ^ t16f;
wire t18f = u[3] ^ u[7];
wire t19f = t7f ^ t18f;
wire t20f = t1f ^ t19f;
wire t21f = u[6] ^ u[7];

wire t22f = t7f ^ t21f;
wire t23f = t2f ^ t22f;
wire t24f = t2f ^ t10f;
wire t25f = t20f ^ t17f;
wire t26f = t3f ^ t16f;
wire t27f = t1f ^ t12f;

// Top linear transform wire t1 = t1f;
wire t2 = t2f;
wire t3 = t3f;
wire t4 = t4f;
wire t6 = t6f;
wire t8 = t8f;
wire t9 = t9f;
wire t10 = t10f;
wire t13 = t13f;
wire t14 = t14f;
wire t15 = t15f;
wire t16 = t16f;
wire t17 = t17f;
wire t19 = t19f;
wire t20 = t20f;
wire t22 = t22f;
wire t23 = t23f;
wire t24 = t24f;
wire t25 = t25f;
wire t26 = t26f;
wire t27 = t27f;

// Shared part
wire d = u[7];

wire m1 = t13 & t6;
wire m2 = t23 & t8;
wire m3 = t14 ^ m1;
wire m4 = t19 & d;
wire m5 = m4 ^ m1;
wire m6 = t3 & t16;
wire m7 = t22 & t9;
wire m8 = t26 ^ m6;
wire m9 = t20 & t17;
wire m10 = m9 ^ m6;
wire m11 = t1 & t15;
wire m12 = t4 & t27;
wire m13 = m12 ^ m11; 
wire m14 = t2 & t10;
wire m15 = m14 ^ m11;
wire m16 = m3 ^ m2;

wire m17 = m5 ^ t24;
wire m18 = m8 ^ m7;
wire m19 = m10 ^ m15;
wire m20 = m16 ^ m13;
wire m21 = m17 ^ m15;
wire m22 = m18 ^ m13;
wire m23 = m19 ^ t25;
wire m24 = m22 ^ m23;
wire m25 = m22 & m20;
wire m26 = m21 ^ m25;
wire m27 = m20 ^ m21;
wire m28 = m23 ^ m25;
wire m29 = m28 & m27;
wire m30 = m26 & m24;
wire m31 = m20 & m23;
wire m32 = m27 & m31;

wire m33 = m27 ^ m25; 
wire m34 = m21 & m22;
wire m35 = m24 & m34;
wire m36 = m24 ^ m25;
wire m37 = m21 ^ m29;
wire m38 = m32 ^ m33;
wire m39 = m23 ^ m30;
wire m40 = m35 ^ m36;
wire m41 = m38 ^ m40;
wire m42 = m37 ^ m39;
wire m43 = m37 ^ m38;
wire m44 = m39 ^ m40;
wire m45 = m42 ^ m41;
wire m46 = m44 & t6;
wire m47 = m40 & t8;
wire m48 = m39 & d; 

wire m49 = m43 & t16; 
wire m50 = m38 & t9;
wire m51 = m37 & t17;
wire m52 = m42 & t15;
wire m53 = m45 & t27;
wire m54 = m41 & t10;
wire m55 = m44 & t13;
wire m56 = m40 & t23;
wire m57 = m39 & t19;
wire m58 = m43 & t3;
wire m59 = m38 & t22;
wire m60 = m37 & t20;
wire m61 = m42 & t1;
wire m62 = m45 & t4;
wire m63 = m41 & t2;

// Bottom linear transform forward
wire l0 = m61 ^ m62;
wire l1 = m50 ^ m56;
wire l2 = m46 ^ m48;
wire l3 = m47 ^ m55;
wire l4 = m54 ^ m58;
wire l5 = m49 ^ m61;
wire l6 = m62 ^ l5;
wire l7 = m46 ^ l3;
wire l8 = m51 ^ m59;
wire l9 = m52 ^ m53;

wire l10 = m53 ^ l4;
wire l11 = m60 ^ l2;
wire l12 = m48 ^ m51;
wire l13 = m50 ^ l0;
wire l14 = m52 ^ m61;
wire l15 = m55 ^ l1;
wire l16 = m56 ^ l0;
wire l17 = m57 ^ l1;
wire l18 = m58 ^ l8;
wire l19 = m63 ^ l4;

wire l20 = l0 ^ l1;
wire l21 = l1 ^ l7;
wire l22 = l3 ^ l12;
wire l23 = l18 ^ l2;
wire l24 = l15 ^ l9;
wire l25 = l6 ^ l10;
wire l26 = l7 ^ l9;
wire l27 = l8 ^ l10;
wire l28 = l11 ^ l14;
wire l29 = l11 ^ l17;

wire s0 = l6 ^ l24;
wire s1 = ~(l16 ^ l26); 
wire s2 = ~(l19 ^ l28);
wire s3 = l6 ^ l21;
wire s4 = l20 ^ l22;
wire s5 = l25 ^ l29;
wire s6 = ~(l13 ^ l27);
wire s7 = ~(l6 ^ l23);

// Output muxes

assign out[7] = s0;
assign out[6] = s1;
assign out[5] = s2;
assign out[4] = s3;
assign out[3] = s4;
assign out[2] = s5;
assign out[1] = s6;
assign out[0] = s7;


endmodule
