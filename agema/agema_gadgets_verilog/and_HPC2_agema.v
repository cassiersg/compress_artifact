module and_HPC2_agema #(parameter security_order=1, parameter pipeline=1) (a, b, r, clk, c);

localparam rnd = security_order*(security_order+1)/2;

input wire [security_order:0] a, b;
input wire [rnd-1:0] r;
input wire clk;
output wire [security_order:0] c;

function integer ij2idx(input integer i, input integer j);
    if (i < j) begin
        ij2idx = (rnd - (security_order-i)*(security_order-i+1)/2) + (j-i)-1;
    end else begin
        ij2idx = (rnd - (security_order-j)*(security_order-j+1)/2) + (i-j)-1;
    end
endfunction

genvar I, J;

for (I=0; I <= security_order; I = I+1) begin: i_gen
    wire [security_order:0] z;
    reg mul_s1_out, mul_s2_out;
    always @(posedge clk) begin
        mul_s1_out <= a[I] & b[I];
        mul_s2_out <= mul_s1_out;
    end
    assign z[I] = mul_s2_out;
    reg a_reg;
    always @(posedge clk) a_reg <= a[I];
    for (J = 0; J <= security_order; J = J+1) begin: j_gen
        if (J != I) begin
            reg s_out, p_0_out, p_1_out;
            wire s_in = b[J] ^ r[ij2idx(I, J)];
            wire p_0_in= (~a[I]) & r[ij2idx(I, J)];
            wire p_1_in = s_out & a_reg;
            always @(posedge clk) begin
                p_0_out <= p_0_in;
                p_1_out <= p_1_in;
                s_out <= s_in;
            end
            assign z[J] = p_0_out ^ p_1_out;
        end
    end
    assign c[I] = ^z;
end

endmodule
