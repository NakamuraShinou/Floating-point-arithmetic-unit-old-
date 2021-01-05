module Adjust_E(E, NaN1, zero, pre_E, numbit_toshift, OV, op);
	output [7:0] E;
	output NaN1, zero;
	input [7:0] pre_E, numbit_toshift;
	input OV, op;
	wire [7:0] E_0, E_1;
	
	Increase8 inc_exponent(E_0, NaN1, pre_E, OV);
	Fast_Adder8 stage0(E_1, cout, pre_E, ~numbit_toshift, 1'b1);
	HalfAdder stage1(zero, c, 1'b1, cout);
	mux2to1_8bit choose_E(E, op, E_0, E_1);
endmodule

module Adjust_M(M, numbit_toshift, pre_M, OV, op);
	output [22:0] M;
	output [7:0] numbit_toshift;
	input [23:0] pre_M;
	input OV, op;
	wire [23:0] sh_M;
	
	shift_left24 shift_left(sh_M, pre_M, numbit_toshift);
	encoder_numbit_toshift num_shift(numbit_toshift[4:0], pre_M);
	mux4to1_23bit shiftvalue(M, {OV, op}, pre_M[22:0], sh_M[22:0], pre_M[23:1], sh_M[22:0]);
	assign numbit_toshift[7:5] = 3'b0;
endmodule

module Adjust_main(E, M, NaN, zero, pre_E, pre_M, OV, op);
	output [7:0] E;
	output [22:0] M;
	output NaN, zero;
	input [7:0] pre_E;
	input [23:0] pre_M;
	input OV, op;
	wire [7:0] numbit;
	wire NaN1, NaN2, w1, w2;
	
	Adjust_E adjust_e(E, NaN1, zero, pre_E, numbit, OV, op);	
	Adjust_M adjust_m(M, numbit, pre_M, OV, op);
	and(w1, E[0], E[1], E[2], E[3], E[4], E[5], E[6], E[7]);
	or(w2, M[0], M[1], M[2], M[3], M[4], M[5], M[6], M[7], M[8], M[9], M[10], M[11], M[12], M[13], M[14], M[15], M[16], M[17], M[18], M[19], M[20], M[21], M[22]);
	and(NaN2, w1, w2);
	or(NaN, NaN1, NaN2);
endmodule 