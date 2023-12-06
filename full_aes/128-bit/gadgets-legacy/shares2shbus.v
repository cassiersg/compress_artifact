module shares2shbus
#
(
    parameter d = 2,
    parameter count = 8
)
(
    shares,
    shbus
);

// IOs
input [d*count-1:0] shares;
output [d*count-1:0] shbus;

genvar i,j;
generate
for(i=0;i<count;i=i+1) begin: bit_wiring
    for(j=0;j<d;j=j+1) begin: share_wiring
        assign shbus[d*i + j] = shares[count*j + i];
    end
end
endgenerate


endmodule
