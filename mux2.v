module mux2 (
    input  in0,
    input  in1,
    input  sel,
    output out
);
    wire sel_n, in0_gated, in1_gated;

    not g_inv  (sel_n, sel);
    and g_and0 (in0_gated, in0, sel_n);
    and g_and1 (in1_gated, in1, sel);
    or  g_or   (out, in0_gated, in1_gated);
endmodule