module sign(s, s1, s2, not_add_sub, greater, deltaE8);
	output s;
	input s1, s2, not_add_sub, greater, deltaE8;
	
	assign s = ((~deltaE8)&&(((~greater)&&(s2^not_add_sub))||(s1&&greater))) || (deltaE8&&((greater&&(s2^not_add_sub))||(s1&&(~greater))));
endmodule

module Compute_main(pre_M, OV, s, op, X, Y, s1, s2, not_add_sub, deltaE8);
// main of computing processing
	output [23:0] pre_M;
	output OV, s, op;
	input [23:0] X, Y;
	input s1, s2, not_add_sub, deltaE8;
	wire greater;
	wire [23:0] OUT_X, OUT_Y, xor_OUT_Y;
	
	
	comparator24 compare(greater, X, Y);
	sign sign_value(s, s1, s2, not_add_sub, greater, deltaE8);
	mux2to1_24bit selection0(OUT_X, greater, Y, X);
	mux2to1_24bit selection1(OUT_Y, greater, X, Y);
	Fast_Adder24 add(pre_M, OV, OUT_X, xor_OUT_Y, op);
	assign op = s1 ^ s2 ^ not_add_sub;
	
	xor(xor_OUT_Y[0], OUT_Y[0], op);
	xor(xor_OUT_Y[1], OUT_Y[1], op);
	xor(xor_OUT_Y[2], OUT_Y[2], op);
	xor(xor_OUT_Y[3], OUT_Y[3], op);
	xor(xor_OUT_Y[4], OUT_Y[4], op);
	xor(xor_OUT_Y[5], OUT_Y[5], op);
	xor(xor_OUT_Y[6], OUT_Y[6], op);
	xor(xor_OUT_Y[7], OUT_Y[7], op);
	xor(xor_OUT_Y[8], OUT_Y[8], op);
	xor(xor_OUT_Y[9], OUT_Y[9], op);
	xor(xor_OUT_Y[10], OUT_Y[10], op);
	xor(xor_OUT_Y[11], OUT_Y[11], op);
	xor(xor_OUT_Y[12], OUT_Y[12], op);
	xor(xor_OUT_Y[13], OUT_Y[13], op);
	xor(xor_OUT_Y[14], OUT_Y[14], op);
	xor(xor_OUT_Y[15], OUT_Y[15], op);
	xor(xor_OUT_Y[16], OUT_Y[16], op);
	xor(xor_OUT_Y[17], OUT_Y[17], op);
	xor(xor_OUT_Y[18], OUT_Y[18], op);
	xor(xor_OUT_Y[19], OUT_Y[19], op);
	xor(xor_OUT_Y[20], OUT_Y[20], op);
	xor(xor_OUT_Y[21], OUT_Y[21], op);
	xor(xor_OUT_Y[22], OUT_Y[22], op);
	xor(xor_OUT_Y[23], OUT_Y[23], op);
endmodule 