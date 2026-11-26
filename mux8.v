module mux8 (
    input  [7:0] in,
    input  [2:0] sel,
    output       out
);
    wire l0_a, l0_b, l0_c, l0_d, l1_a, l1_b;

    mux2 m0 (in[0], in[1], sel[0], l0_a);
    mux2 m1 (in[2], in[3], sel[0], l0_b);
    mux2 m2 (in[4], in[5], sel[0], l0_c);
    mux2 m3 (in[6], in[7], sel[0], l0_d);

    mux2 m4 (l0_a, l0_b, sel[1], l1_a);
    mux2 m5 (l0_c, l0_d, sel[1], l1_b);

    mux2 m6 (l1_a, l1_b, sel[2], out);
endmodule