module adder_sub8 (
    input  [7:0] a, b,
    input        sub,
    output [7:0] sum,
    output       carry_out
);
    wire [7:0] b_xor_sub;
    wire [8:0] carry;

    assign carry[0] = sub;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_slice
            xor x (b_xor_sub[i], b[i], sub);
            full_adder fa (
                .a         (a[i]),
                .b         (b_xor_sub[i]),
                .carry_in  (carry[i]),
                .sum       (sum[i]),
                .carry_out (carry[i+1])
            );
        end
    endgenerate

    assign carry_out = carry[8];
endmodule