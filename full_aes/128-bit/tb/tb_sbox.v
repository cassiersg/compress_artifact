`timescale 1ns/1ps
module tb_sbox();

`include "MSKand_HPC2.vh"

localparam T = 2.0;
localparam Td = T/2.0;

`ifdef FUNCT_SIMU
    localparam d = 4;
`else
    localparam d = 2;
`endif

// General signals
reg clk;
reg rst;

// Reference signals
reg [7:0] in_ref;
wire [7:0] out_ref;

// Dut signals
reg inverse;
reg enable;
reg valid_in;
wire [8*d-1:0] in_sh;
wire [8*d-1:0] out_sh;
wire [7:0] out_sh_rec;
wire valid_out;
wire nr0, nr2, nr3 ,nr4; 

// Randomness busses
reg [9*hpc2rnd-1:0] rnd_bus0;
reg [3*hpc2rnd-1:0] rnd_bus2;
reg [4*hpc2rnd-1:0] rnd_bus3;
reg [18*hpc2rnd-1:0] rnd_bus4;

localparam am_32_andp = hpc2rnd/32;

// Create and recombine the sharing
genvar i;
generate
for(i=0;i<8;i=i+1) begin:sharing
    assign in_sh[i*d+1 +: d-1] = 0;
    assign in_sh[i*d] = in_ref[i];
    assign out_sh_rec[i] = ^out_sh[i*d +: d];
end
endgenerate

// Create clock
always@(*) #Td clk<=~clk;


// dut ref
sbox_bp_umsk dutref(
    .in(in_ref),
    .out(out_ref),
    .inverse(inverse)
);

// dut
bp_aes_sbox_msk_dual #(.d(d))
dut(
    .clk(clk),
    .enable(enable),
    .rst(rst),
    .i0(in_sh[0*d +: d]),
    .i1(in_sh[1*d +: d]),
    .i2(in_sh[2*d +: d]),
    .i3(in_sh[3*d +: d]),
    .i4(in_sh[4*d +: d]),
    .i5(in_sh[5*d +: d]),
    .i6(in_sh[6*d +: d]),
    .i7(in_sh[7*d +: d]),
    .inverse(inverse),
    .valid_in(valid_in),
    .o0(out_sh[0*d +: d]),
    .o1(out_sh[1*d +: d]),
    .o2(out_sh[2*d +: d]),
    .o3(out_sh[3*d +: d]),
    .o4(out_sh[4*d +: d]),
    .o5(out_sh[5*d +: d]),
    .o6(out_sh[6*d +: d]),
    .o7(out_sh[7*d +: d]),
    .valid_out(valid_out),
    .need_rnd_bus0(nr0),
    .need_rnd_bus2(nr2),
    .need_rnd_bus3(nr3),
    .need_rnd_bus4(nr4),
    .rnd_bus0(rnd_bus0),
    .rnd_bus2(rnd_bus2),
    .rnd_bus3(rnd_bus3),
    .rnd_bus4(rnd_bus4)
);

integer n = 0;
`ifdef FUNCT_SIMU
    integer maxn = 256;
`else
    integer maxn = 1;
`endif
integer seed = 0;
integer am_success = 0;

// Randomness busses
genvar ir;
generate
for(ir=0;ir<9*hpc2rnd;ir=ir+1) begin:rnd0
    always@(posedge clk)  rnd_bus0[ir] <= $dist_uniform(seed,0,1);    
end
for(ir=0;ir<3*hpc2rnd;ir=ir+1) begin:rnd2
    always@(posedge clk)  rnd_bus2[ir] <= $dist_uniform(seed,0,1);    
end
for(ir=0;ir<4*hpc2rnd;ir=ir+1) begin:rnd3
    always@(posedge clk)  rnd_bus3[ir] <= $dist_uniform(seed,0,1);    
end
for(ir=0;ir<18*hpc2rnd;ir=ir+1) begin:rnd4
    always@(posedge clk)  rnd_bus4[ir] <= $dist_uniform(seed,0,1);    
end
endgenerate


initial begin
`ifdef VCD_PATH
    $dumpfile(`VCD_PATH);
`else
    $dumpfile("a.vcd");
`endif
    $dumpvars(0,tb_sbox);

    clk = 1;
    enable = 1;
    valid_in = 0;

`ifdef INVERSE
    inverse = 1;
`else
    inverse = 0;
`endif

    #0.01;

    $display("--> Simulation init done.");

    // reset sequence
    rst = 1;
    #(2*T);
    rst = 0;
    #T;

    $display("--> Simulation reset done.");
    $display("--> Simulation running...");

    for (n=0;n<maxn;n=n+1) begin
        in_ref = n[7:0];
        valid_in = 1;
        #T;
        valid_in = 0;
        while(valid_out!=1) begin
            #T;
        end
        if(out_ref==out_sh_rec) begin
            am_success = am_success + 1;
        end else begin
            $display("--> Failure for input %02x",n[7:0]);
            $display("Output expected: %02x",out_ref);
            $display("Output dut: %02x",out_sh_rec);
            $finish;
        end
        #T;
    end
    
    #(T);
    $display("Success for all cases."); 

    $finish;
end






endmodule
