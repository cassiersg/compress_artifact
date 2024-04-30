// Straight translation of Canright's S-box in verilog, with inverse.

// multiplication in GF(2^2) using normal basis (Omega^2, Omega)
module G4_mul(input wire [1:0] x, input wire [1:0] y, output wire [1:0] z);
    wire a, b, c, d, e;
    assign a = x[1];
    assign b = x[0];
    assign c = y[1];
    assign d = y[0];
    assign e = (a ^ b) & (c ^ d);
    assign z[1] = (a & c) ^ e;
    assign z[0] = (b & d) ^ e;
endmodule

// scaling by N = Omega^2 in GF(2^2) using normal basis (Omega^2, Omega)
module G4_scl_N(input wire [1:0] x, output wire [1:0] z);
    wire a, b;
    assign a = x[1];
    assign b = x[0];
    assign z[1] =  b;
    assign z[0] = a ^ b;
endmodule

// scaling by N^2 = Omega in GF(2^2) using normal basis (Omega^2, Omega)
module G4_scl_N2(input wire [1:0] x, output wire [1:0] z);
    wire a, b;
    assign a = x[1];
    assign b = x[0];
    assign z[1] = a ^ b;
    assign z[0] = a;
endmodule

// squaring in GF(2^2), using normal basis (Omega^2, Omega)
// NOTE: inverse is identical
module G4_sq(input wire [1:0] x, output wire [1:0] z);
    wire a, b;
    assign a = x[1];
    assign b = x[0];
    assign z[1] = b;
    assign z[0] = a;
endmodule

// multiplication in GF(2^4) using normal basis (alpha^8, alpha^2)
module G16_mul(input wire [3:0] x, input wire [3:0] y, output wire [3:0] z);
    wire [1:0] a, b, c, d, e, e_scl, p, q;
    assign a = x[3:2];
    assign b = x[1:0];
    assign c = y[3:2];
    assign d = y[1:0];
    G4_mul mul1(.x(a ^ b), .y(c ^ d), .z(e));
    G4_scl_N scl_N(.x(e), .z(e_scl));
    G4_mul mul2(.x(a), .y(c), .z(p));
    G4_mul mul3(.x(b), .y(d), .z(q));
    assign z[3:2] = p ^ e_scl;
    assign z[1:0] = q ^ e_scl;
endmodule

// square & scale by nu in GF(2^4)/Gf(2^2), normal basis (alpha^8, alpha^2)
module G16_sq_scl(input wire [3:0] x, output wire [3:0] z);
    wire [1:0] a, b, p, q, q2;
    assign a = x[3:2];
    assign b = x[1:0];
    G4_sq sq1(.x(a ^ b), .z(p));
    G4_sq sq2(.x(b), .z(q));
    G4_scl_N2 scl_N2(.x(q), .z(q2));
    assign z[3:2] = p;
    assign z[1:0] = q2;
endmodule

// inverse in GF(2^4) using normal basis (alpha^8, alpha^2)
module G16_inv(input wire [3:0] x, output wire [3:0] z);
    wire [1:0] a, b, c, c2, d, e, p, q;
    assign a = x[3:2];
    assign b = x[1:0];
    G4_sq sq(.x(a ^ b), .z(c));
    G4_scl_N scl_N(.x(c), .z(c2));
    G4_mul mul1(.x(a), .y(b), .z(d));
    G4_sq inv(.x(c2 ^ d), .z(e)); // inverse, but same as square
    G4_mul mul2(.x(e), .y(b), .z(p));
    G4_mul mul3(.x(e), .y(a), .z(q));
    assign z[3:2] = p;
    assign z[1:0] = q;
endmodule

// inverse in GF(2^8) using normal basis (d^16, d)
module G256_inv(input wire [7:0] x, output wire [7:0] z);
    wire [3:0] a, b, c, d, e, p, q;
    assign a = x[7:4];
    assign b = x[3:0];
    G16_sq_scl sq_scl(.x(a ^ b), .z(c));
    G16_mul mul1(.x(a), .y(b), .z(d));
    G16_inv inv(.x(c ^ d), .z(e));
    G16_mul mul2(.x(e), .y(b), .z(p));
    G16_mul mul3(.x(e), .y(a), .z(q));
    assign z[7:4] = p;
    assign z[3:0] = q;
endmodule

// convert to new basis in GF(2^8), A2X (polynomial to normal)
module G256_newbasis_A2X(input wire [7:0] x, output wire [7:0] z);
    assign z = 
        ({8{x[0]}} & 8'hFF)
        ^ ({8{x[1]}} & 8'hA9)
        ^ ({8{x[2]}} & 8'h81)
        ^ ({8{x[3]}} & 8'h09)
        ^ ({8{x[4]}} & 8'h48)
        ^ ({8{x[5]}} & 8'hF2)
        ^ ({8{x[6]}} & 8'hF3)
        ^ ({8{x[7]}} & 8'h98)
        ;
endmodule

// convert to new basis in GF(2^8) X2S (normal to polynomial with permutation)
module G256_newbasis_X2S(input wire [7:0] x, output wire [7:0] z);
    assign z = 
        ({8{x[0]}} & 8'h24)
        ^ ({8{x[1]}} & 8'h03)
        ^ ({8{x[2]}} & 8'h04)
        ^ ({8{x[3]}} & 8'hDC)
        ^ ({8{x[4]}} & 8'h0B)
        ^ ({8{x[5]}} & 8'h9E)
        ^ ({8{x[6]}} & 8'h2D)
        ^ ({8{x[7]}} & 8'h58)
        ;
endmodule

// convert to new basis in GF(2^8) X2S (normal to polynomial with permutation)
module G256_newbasis_S2X(input wire [7:0] x, output wire [7:0] z);
    assign z = 
        ({8{x[0]}} & 8'h53)
        ^ ({8{x[1]}} & 8'h51)
        ^ ({8{x[2]}} & 8'h04)
        ^ ({8{x[3]}} & 8'h12)
        ^ ({8{x[4]}} & 8'hEB)
        ^ ({8{x[5]}} & 8'h05)
        ^ ({8{x[6]}} & 8'h79)
        ^ ({8{x[7]}} & 8'h8C)
        ;
endmodule

// convert to new basis in GF(2^8) X2S (normal to polynomial with permutation)
module G256_newbasis_X2A(input wire [7:0] x, output wire [7:0] z);
    assign z = 
        ({8{x[0]}} & 8'h60)
        ^ ({8{x[1]}} & 8'hDE)
        ^ ({8{x[2]}} & 8'h29)
        ^ ({8{x[3]}} & 8'h68)
        ^ ({8{x[4]}} & 8'h8C)
        ^ ({8{x[5]}} & 8'h6E)
        ^ ({8{x[6]}} & 8'h78)
        ^ ({8{x[7]}} & 8'h64)
        ;
endmodule

// AES S-box
module Sbox(input wire [7:0] i, output wire [7:0] o);
    wire [7:0] t, u, v;
    G256_newbasis_A2X a2x(.x(i), .z(t));
    G256_inv inv(.x(t), .z(u));
    G256_newbasis_X2S x2s(.x(u), .z(v));
    assign o = v ^ 8'h63;
endmodule

// AES inverse S-box
module iSbox(input wire [7:0] i, output wire [7:0] o);
    wire [7:0] t, u, v;
    // t = G256_newbasis( n ^ 0x63, S2X );
    G256_newbasis_S2X s2x(.x(i^8'h63), .z(t));
    // t = G256_inv( t );
    G256_inv inv(.x(t), .z(u));
    // t = G256_newbasis( t, X2A );
    G256_newbasis_X2A x2a(.x(u), .z(v));
    // return 
    assign o = v;
endmodule

`ifdef behavioral
`timescale 1ns/1ps
module tb_dual();
reg [7:0] xin;
wire [7:0] yin;
wire [7:0] xout;

Sbox sb(.i(xin),.o(yin));
iSbox isb(.i(yin),.o(xout));

integer i;
initial begin
    // Open vcd file
    $dumpfile("log.vcd");
    $dumpvars(0,tb_dual);
    for (i=0;i<256;i=i+1) begin
        xin = i;
        #1;
        if (xout!==xin) begin
            $display("An error occured.");
            $display("iSB(%d) = %d != %d",yin,xout,xin);
            $finish();
        end
    end
    $display("SUCCESS");
end
endmodule
`endif
