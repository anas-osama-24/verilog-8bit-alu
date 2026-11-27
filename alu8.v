module alu8 (
    input  [7:0] a, b,
    input  [2:0] op,
    output [7:0] result,
    output       zero,
    output       carry
);
    wire [7:0] add_sub_result;
    wire [7:0] and_result, or_result, xor_result, not_result;
    wire [7:0] shr_result, shl_result;
    wire       adder_carry, is_arith;

    // arithmetic: op[0] = 1 only for SUB (op = 001)
    adder_sub8 add_sub (
        .a(a), .b(b), .sub(op[0]),
        .sum(add_sub_result), .carry_out(adder_carry)
    );

    // carry only for ADD (000) and SUB (001)
    nor g_arith (is_arith, op[2], op[1]);
    and g_carry (carry, adder_carry, is_arith);

    // logic, one gate per bit
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : logic_slice
            and g_and (and_result[i], a[i], b[i]);
            or  g_or  (or_result[i],  a[i], b[i]);
            xor g_xor (xor_result[i], a[i], b[i]);
            not g_not (not_result[i], a[i]);
        end
    endgenerate

    // shifts
    barrel_shifter_right shifter_r (
        .data_in(a), .shift_amt(b[2:0]), .data_out(shr_result)
    );

    barrel_shifter_left shifter_l (
        .data_in(a), .shift_amt(b[2:0]), .data_out(shl_result)
    );

    // result select, one 8:1 mux per bit
    generate
        for (i = 0; i < 8; i = i + 1) begin : result_slice
            mux8 result_mux (
                .in  ({shl_result[i], shr_result[i], not_result[i], xor_result[i],
                       or_result[i],  and_result[i], add_sub_result[i], add_sub_result[i]}),
                .sel (op),
                .out (result[i])
            );
        end
    endgenerate

    // zero flag
    nor g_zero (zero, result[0], result[1], result[2], result[3],
                      result[4], result[5], result[6], result[7]);
endmodule