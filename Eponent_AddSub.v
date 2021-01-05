module Exponent_diff(diff_E, sign, E1, E2);
// result: abs(E1 - E2), sign(E1 - E2)
	output [7:0] diff_E;
	output sign;
	input [7:0] E1, E2;
	wire [7:0] xor_delta_E;
	wire [7:0] delta_E;
	
	Fast_Adder8 stage0(delta_E[7:0], cout, E1, ~E2, 1'b1);
	HalfAdder stage1(sign, c, 1'b1, cout);
	xor(xor_delta_E[0], delta_E[0], sign);
	xor(xor_delta_E[1], delta_E[1], sign);
	xor(xor_delta_E[2], delta_E[2], sign);
	xor(xor_delta_E[3], delta_E[3], sign);
	xor(xor_delta_E[4], delta_E[4], sign);
	xor(xor_delta_E[5], delta_E[5], sign);
	xor(xor_delta_E[6], delta_E[6], sign);
	xor(xor_delta_E[7], delta_E[7], sign);
	Increase8 stage2(diff_E, c_ignore, xor_delta_E, sign);
endmodule 

module Exponent_main(X, Y, deltaE8, pre_E, E1, E2, one_M1, one_M2);
// main of Exponent processing
	output [23:0] X, Y;
	output [7:0] pre_E;
	output deltaE8;
	input [7:0] E1, E2;
	input [23:0] one_M1, one_M2;
	wire [7:0] diff_E;
	wire [23:0] connect;
	
	Exponent_diff stage0(diff_E, deltaE8, E1, E2);
	mux2to1_8bit stage1(pre_E, deltaE8, E1, E2);
	mux2to1_24bit stage2_1(X, deltaE8, one_M1, one_M2);
	mux2to1_24bit stage2_2(connect, deltaE8, one_M2, one_M1);
	shift_right24 stage2_3(Y, connect, diff_E);
endmodule 