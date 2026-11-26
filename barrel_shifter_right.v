module barrel_shifter_right (
    input  [7:0] data_in,
    input  [2:0] shift_amt,
    output [7:0] data_out
);
    wire [7:0] after_shift1;
    wire [7:0] after_shift2;

    // stage 0: shift by 1
    mux2 s1_bit0 (data_in[0], data_in[1], shift_amt[0], after_shift1[0]);
    mux2 s1_bit1 (data_in[1], data_in[2], shift_amt[0], after_shift1[1]);
    mux2 s1_bit2 (data_in[2], data_in[3], shift_amt[0], after_shift1[2]);
    mux2 s1_bit3 (data_in[3], data_in[4], shift_amt[0], after_shift1[3]);
    mux2 s1_bit4 (data_in[4], data_in[5], shift_amt[0], after_shift1[4]);
    mux2 s1_bit5 (data_in[5], data_in[6], shift_amt[0], after_shift1[5]);
    mux2 s1_bit6 (data_in[6], data_in[7], shift_amt[0], after_shift1[6]);
    mux2 s1_bit7 (data_in[7], 1'b0,       shift_amt[0], after_shift1[7]);

    // stage 1: shift by 2
    mux2 s2_bit0 (after_shift1[0], after_shift1[2], shift_amt[1], after_shift2[0]);
    mux2 s2_bit1 (after_shift1[1], after_shift1[3], shift_amt[1], after_shift2[1]);
    mux2 s2_bit2 (after_shift1[2], after_shift1[4], shift_amt[1], after_shift2[2]);
    mux2 s2_bit3 (after_shift1[3], after_shift1[5], shift_amt[1], after_shift2[3]);
    mux2 s2_bit4 (after_shift1[4], after_shift1[6], shift_amt[1], after_shift2[4]);
    mux2 s2_bit5 (after_shift1[5], after_shift1[7], shift_amt[1], after_shift2[5]);
    mux2 s2_bit6 (after_shift1[6], 1'b0,            shift_amt[1], after_shift2[6]);
    mux2 s2_bit7 (after_shift1[7], 1'b0,            shift_amt[1], after_shift2[7]);

    // stage 2: shift by 4
    mux2 s4_bit0 (after_shift2[0], after_shift2[4], shift_amt[2], data_out[0]);
    mux2 s4_bit1 (after_shift2[1], after_shift2[5], shift_amt[2], data_out[1]);
    mux2 s4_bit2 (after_shift2[2], after_shift2[6], shift_amt[2], data_out[2]);
    mux2 s4_bit3 (after_shift2[3], after_shift2[7], shift_amt[2], data_out[3]);
    mux2 s4_bit4 (after_shift2[4], 1'b0,            shift_amt[2], data_out[4]);
    mux2 s4_bit5 (after_shift2[5], 1'b0,            shift_amt[2], data_out[5]);
    mux2 s4_bit6 (after_shift2[6], 1'b0,            shift_amt[2], data_out[6]);
    mux2 s4_bit7 (after_shift2[7], 1'b0,            shift_amt[2], data_out[7]);
endmodule