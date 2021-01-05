module Add_sub(result, N1, N2, not_add_sub);
	output [31:0] result;
	wire NaN, zero;
	input [31:0] N1, N2;
	input not_add_sub;
	wire [7:0] pre_E;
	wire [23:0] pre_M, X, Y;
	wire deltaE8, op, OV;
	wire isZero, isInf, isNaN, isNormal;
	wire [3:0] type_N1, type_N2;
	wire [1:0] s;
	wire [31:0] zero_result, w_result, nan_result; 
	wire [30:0] inf_result;
	
	assign zero_result = 32'b0;
	assign nan_result = 32'b01111111111111111111111111111111;
	assign inf_result = 31'b1111111100000000000000000000000;
	
	assign isZero = (type_N1[0]&&type_N2[0])||zero;
	assign isInf = (type_N1[1]&&type_N2[1]&&(~(N1[31]^N2[31]^not_add_sub)))||(type_N1[1]&&type_N2[0])||(type_N1[1]&&type_N2[3])||(type_N2[1]&&type_N1[0])||(type_N2[1]&&type_N1[3]);
	assign isNaN = type_N1[2]||type_N2[2]||NaN||(type_N1[1]&&type_N2[1]&&(N1[31]^N2[31]^not_add_sub));
	nor(isNormal, isZero, isInf, isNaN);
	encoder4to2 encode(s, {isZero, isInf, isNaN, isNormal});
	number_detect num_detect1(type_N1[0], type_N1[1], type_N1[2], type_N1[3], N1[30:23], N1[22:0]);
	number_detect num_detect2(type_N2[0], type_N2[1], type_N2[2], type_N2[3], N2[30:23], N2[22:0]);
	
	Exponent_main ex(X, Y, deltaE8, pre_E, N1[30:23], N2[30:23], {1'b1, N1[22:0]}, {1'b1, N2[22:0]});
	Compute_main compute(pre_M, OV, w_result[31], op, X, Y, N1[31], N2[31], not_add_sub, deltaE8);
	Adjust_main adjust(w_result[30:23], w_result[22:0], NaN, zero, pre_E, pre_M, OV, op);
	
	mux4to1_32bit choose_value(result, s, w_result, nan_result, {w_result[31], inf_result}, zero_result);
endmodule

module multiple_main(result, N1, N2);
	output [31:0] result;
	input [31:0] N1, N2;
	wire temp, cout, isZero, isInf, isNaN, isNormal;
	wire [7:0] frac;
	wire [3:0] type_N1, type_N2;
	wire [1:0] s;
	wire [31:0] zero_result, mul_result, nan_result; 
	wire [30:0] inf_result;
	
	assign zero_result = 32'b0;
	assign nan_result = 32'b01111111111111111111111111111111;
	assign inf_result = 31'b1111111100000000000000000000000;
	
	number_detect num_detect1(type_N1[0], type_N1[1], type_N1[2], type_N1[3], N1[30:23], N1[22:0]);
	number_detect num_detect2(type_N2[0], type_N2[1], type_N2[2], type_N2[3], N2[30:23], N2[22:0]);
	assign isZero = (type_N1[0] && type_N2[0])||(type_N1[0]&&type_N2[3])||(type_N1[3]&&type_N2[0]);
	assign isInf = (type_N1[1]&&type_N2[3])||(type_N1[3]&&type_N2[1])||(type_N1[1]&&type_N2[1]);
	assign isNaN = (type_N1[2]||type_N2[2])||(type_N1[0]&&type_N2[1])||(type_N1[1]&&type_N2[0]);
	nor(isNormal, isZero, isNaN, isInf);
	encoder4to2 encode(s, {isZero, isInf, isNaN, isNormal});
	
	Fraction_compute frac_compute(mul_result[22:0], cout, {2'b01, N1[22:0]}, {2'b01, N2[22:0]});
	Exponent_compute ex_compute(frac, N1[30:23], N2[30:23]);
	Increase8 inc(mul_result[30:23], c, frac, cout);
	xor(mul_result[31], N1[31], N2[31]);

	mux4to1_32bit choose_Value(result, s, mul_result, nan_result, {mul_result[31], inf_result}, zero_result);
endmodule

module divide_main(result, N1, N2);
// N1 / N2
	output [31:0] result;
	input [31:0] N1, N2;
	wire NaN;
	wire [3:0] type_N1, type_N2;
	wire [1:0] s;
	wire [31:0] zero_result, div_result, nan_result; 
	wire [30:0] inf_result;
	
	assign zero_result = 32'b0;
	assign nan_result = 32'b01111111111111111111111111111111;
	assign inf_result = 31'b1111111100000000000000000000000;
	
	number_detect num_detect1(type_N1[0], type_N1[1], type_N1[2], type_N1[3], N1[30:23], N1[22:0]);
	number_detect num_detect2(type_N2[0], type_N2[1], type_N2[2], type_N2[3], N2[30:23], N2[22:0]);
	assign isZero = (type_N1[0]&&type_N2[3])||(type_N1[3]&&type_N2[1]);
	assign isInf = (type_N1[1]&&type_N2[3]);
	assign isNaN = (type_N1[2]||type_N2[2])||(type_N1[1]&&type_N2[0])||(type_N1[3]&&type_N2[0])||(type_N1[0]&&type_N2[0])||(type_N1[2]&&type_N2[0])||(type_N1[1]&&type_N2[1])||(type_N1[0]&&type_N2[1])||(type_N1[0]&&type_N2[2]);
	nor(isNormal, isZero, isNaN, isInf);
	encoder4to2 encode(s, {isZero, isInf, isNaN, isNormal});
	
	divide_process div(div_result, NaN, N1, N2);
	
	mux4to1_32bit choose_value(result, s, div_result, nan_result, {div_result[31], inf_result}, zero_result);
endmodule

module root_square_main(result, X);
	output [31:0] result;
	input [31:0] X;
	wire [3:0] type_X;
	wire [1:0] s;
	wire [31:0] zero_result, root_result, nan_result; 
	wire [30:0] inf_result;
	
	assign zero_result = 32'b0;
	assign nan_result = 32'b01111111111111111111111111111111;
	assign inf_result = 31'b1111111100000000000000000000000;
	
	number_detect num_detect(type_X[0], type_X[1], type_X[2], type_X[3], X[30:23], X[22:0]);
	assign isZero = type_X[0];
	assign isInf = type_X[1] && (~X[31]);
	assign isNaN = type_X[2] || X[31];
	nor(isNormal, isZero, isNaN, isInf);
	encoder4to2 encode(s, {isZero, isInf, isNaN, isNormal});
	
	root_square_process root(root_result, X);
	
	mux4to1_32bit choose_Value(result, s, root_result, nan_result, {root_result[31], inf_result}, zero_result);
endmodule
	
module FPAUnit(result, N1, N2, operator); // (result, X)
	output [31:0] result;
	input [31:0] N1, N2;
	input [1:0] operator; // 00 - add, 01 - sub, 10 - mul, 11 - div
	wire [31:0] add_sub_value, mul_value, div_value;
	
	Add_sub add_sub(add_sub_value, N1, N2, operator[0]);
	multiple_main mul(mul_value, N1, N2);
	divide_main div(div_value, N1, N2);
	
	mux4to1_32bit choose_result(result, operator, add_sub_value, add_sub_value, mul_value, div_value);
endmodule 