module shbus2shares
#
(
    parameter d = 2,
    parameter count = 8
)
(
    shbus,
    shares
);

// IOs
input [d*count-1:0] shbus;
output [d*count-1:0] shares;

genvar i,j;
generate
for(i=0;i<count;i=i+1) begin: bit_wiring
    for(j=0;j<d;j=j+1) begin: share_wiring
        assign shares[count*j + i] = shbus[d*i + j];
    end
end
endgenerate


endmodule
