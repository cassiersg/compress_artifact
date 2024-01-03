module tb_aes();

localparam T = 2.0;
localparam Td = T/2.0;

reg [127:0] key_in, state_in;
reg [7:0] RCON;
wire [127:0] state_out, key_out;
aes_round_umsk dut(
    .state_in(state_in),
    .key_in(key_in),
    .RCON(RCON),
    .state_out(state_out),
    .key_out(key_out)
);

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0,tb_aes);

    #T;

    key_in = 128'h3c4fcf09_8815f7ab_a6d2ae28_16157e2b;  
    state_in = 128'h340737e0_a2983131_8d305a88_a8f64332;  
    RCON = 8'h01;

    #T;

    $finish();
    
end




endmodule
