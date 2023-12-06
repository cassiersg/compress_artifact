`timescale 1ns/1ps
module tb_MC();

localparam T=2.0;
localparam Td = T/2.0;

localparam d = 5;

reg [32-1:0] ref_in;
wire [32*d-1:0] sh_in, sh_out;

// Sharing of input
genvar i,j,k;
generate
if(d>1) begin
    for(i=0;i<32;i=i+1) begin: sh_bit
        assign sh_in[i*d] = ref_in[i];
        assign sh_in[i*d + 1 +: d-1] = {(d-1){1'b0}};
    end
end else begin
    for(i=0;i<32;i=i+1) begin: sh_bit
        assign sh_in[i] = ref_in[i];
    end
end
endgenerate

// Sharing of input
wire [8*d-1:0] sh_a0, sh_a1, sh_a2, sh_a3;
generate
for(i=0;i<8;i=i+1) begin: bits_inpus
    for(j=0;j<d;j=j+1) begin: sharea0
        assign sh_a0[d*i+j] = sh_in[d*i+j];
    end
    for(j=0;j<d;j=j+1) begin: sharea1
        assign sh_a1[d*i+j] = sh_in[8*d+d*i+j];
    end
    for(j=0;j<d;j=j+1) begin: sharea2
        assign sh_a2[d*i+j] = sh_in[16*d+d*i+j];
    end
    for(j=0;j<d;j=j+1) begin: sharea3
        assign sh_a3[d*i+j] = sh_in[24*d+d*i+j];
    end
end
endgenerate

// output
wire [8*d-1:0] b0,b1,b2,b3;
MSKaesMC #(.d(d))
dut(
    .a0(sh_a0),
    .a1(sh_a1),
    .a2(sh_a2),
    .a3(sh_a3),
    .b0(b0),
    .b1(b1),
    .b2(b2),
    .b3(b3)
);


wire [7:0] b0ref, b1ref, b2ref, b3ref;
MSKaesMC #(.d(1))
ref(
    .a0(ref_in[0 +: 8]),
    .a1(ref_in[8 +: 8]),
    .a2(ref_in[8 +: 8]),
    .a3(ref_in[8 +: 8]),
    .b0(b0ref),
    .b1(b1ref),
    .b2(b2ref),
    .b3(b3ref)
);


wire [7:0] rec0, rec1, rec2, rec3;
wire [7:0] reca0, reca1, reca2, reca3;
generate
for(i=0;i<8;i=i+1) begin: rec_bit
    assign rec0[i] = ^(b0[d*i +: d]);
    assign rec1[i] = ^(b1[d*i +: d]);
    assign rec2[i] = ^(b2[d*i +: d]);
    assign rec3[i] = ^(b3[d*i +: d]);

    assign reca0[i] = ^(sh_a0[d*i +: d]);
    assign reca1[i] = ^(sh_a1[d*i +: d]);
    assign reca2[i] = ^(sh_a2[d*i +: d]);
    assign reca3[i] = ^(sh_a3[d*i +: d]);
end
endgenerate

initial begin
    $dumpfile("log.vcd");
    $dumpvars(0,tb_MC);
    ref_in = {8'h45, 8'h53, 8'h13, 8'hdb};
    #T;
    $finish;
end
endmodule
