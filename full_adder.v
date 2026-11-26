module full_adder (
    input  a, b, carry_in,
    output sum, carry_out
);
    wire a_xor_b, a_and_b, xor_and_cin;

    xor g_xor1 (a_xor_b, a, b);
    xor g_xor2 (sum, a_xor_b, carry_in);
    and g_and1 (a_and_b, a, b);
    and g_and2 (xor_and_cin, a_xor_b, carry_in);
    or  g_or   (carry_out, a_and_b, xor_and_cin);
endmodule