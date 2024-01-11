module and_HPC3_agema #(parameter security_order=1, parameter pipeline=1) (a, b, r, clk, c);

localparam half_rnd = security_order*(security_order+1)/2;


input wire [security_order:0] a, b;
input wire [2*half_rnd-1:0] r;
input wire clk;
output wire [security_order:0] c;

wire [half_rnd-1:0] r1, r2;
assign r1 = r[0 +: half_rnd];
assign r2 = r[half_rnd +: half_rnd];


function integer ij2idx(input integer i, input integer j);
    if (i < j) begin
        ij2idx = (half_rnd - (security_order-i)*(security_order-i+1)/2) + (j-i)-1;
    end else begin
        ij2idx = (half_rnd - (security_order-j)*(security_order-j+1)/2) + (i-j)-1;
    end
endfunction

genvar I, J;

for (I=0; I <= security_order; I = I+1) begin: i_gen
    wire [security_order:0] z;
    reg mul_s1_out;
    always @(posedge clk) mul_s1_out <= a[I] & b[I];
    assign z[I] = mul_s1_out;
    reg a_reg;
    always @(posedge clk) a_reg <= a[I];
    for (J = 0; J <= security_order; J = J+1) begin: j_gen
        if (J != I) begin
            wire s_in = b[J] ^ r1[ij2idx(I, J)];
            wire p_0_in= ((~a[I]) & r1[ij2idx(I, J)]) ^ r2[ij2idx(I, J)];
            reg s_out, p_0_out;
            always @(posedge clk) begin
                p_0_out <= p_0_in;
                s_out <= s_in;
            end
            wire p_1_in = s_out & a_reg;
            assign z[J] = p_0_out ^ p_1_in;
        end
    end
    assign c[I] = ^z;
end

endmodule
