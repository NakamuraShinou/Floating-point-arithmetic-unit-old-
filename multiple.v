module number_detect(zero, inf, NaN, normal, E, F);
	output zero, inf, NaN, normal;
	input [7:0] E;
	input [22:0] F;
	wire E_zero, E_max, F_zero, F_nonzero;
	
	nor(E_zero, E[7], E[6], E[5], E[4], E[3], E[2], E[1], E[0]);
	and(E_max, E[7], E[6], E[5], E[4], E[3], E[2], E[1], E[0]);
	nor(F_zero, F[0], F[1], F[2], F[3], F[4], F[5], F[6], F[7], F[8], F[9], F[10], F[11], F[12], F[13], F[14], F[15], F[16], F[17], F[18], F[19], F[20], F[21], F[22]);
	or(F_nonzero, F[0], F[1], F[2], F[3], F[4], F[5], F[6], F[7], F[8], F[9], F[10], F[11], F[12], F[13], F[14], F[15], F[16], F[17], F[18], F[19], F[20], F[21], F[22]);
	and(zero, E_zero, F_zero);
	and(inf, E_max, F_zero);
	and(NaN, E_max, F_nonzero);
	nor(normal, zero, inf, NaN);
endmodule

module and_1bit_vs_25bit(OUT, num25, flag);
	output [24:0] OUT;
	input [24:0] num25;
	input flag;
	
	and(OUT[0], num25[0], flag);
	and(OUT[1], num25[1], flag);
	and(OUT[2], num25[2], flag);
	and(OUT[3], num25[3], flag);
	and(OUT[4], num25[4], flag);
	and(OUT[5], num25[5], flag);
	and(OUT[6], num25[6], flag);
	and(OUT[7], num25[7], flag);
	and(OUT[8], num25[8], flag);
	and(OUT[9], num25[9], flag);
	and(OUT[10], num25[10], flag);
	and(OUT[11], num25[11], flag);
	and(OUT[12], num25[12], flag);
	and(OUT[13], num25[13], flag);
	and(OUT[14], num25[14], flag);
	and(OUT[15], num25[15], flag);
	and(OUT[16], num25[16], flag);
	and(OUT[17], num25[17], flag);
	and(OUT[18], num25[18], flag);
	and(OUT[19], num25[19], flag);
	and(OUT[20], num25[20], flag);
	and(OUT[21], num25[21], flag);
	and(OUT[22], num25[22], flag);
	and(OUT[23], num25[23], flag);
	and(OUT[24], num25[24], flag);
endmodule

module Fraction_component(OUT, num1, num2, flag);
	output [24:0] OUT;
	input [24:0] num1, num2;
	input flag;
	wire [24:0] temp;
	wire cout;
	
	and_1bit_vs_25bit stage0(temp, num1, flag);
	Adder25 stage1(OUT, cout, temp, num2, 1'b0);
endmodule

module Exponent_compute(E, E1, E2);
	output [7:0] E;
	input [7:0] E1, E2;
	wire [8:0] temp;
	wire [7:0] w_E;

	Fast_Adder8 e1puse2(temp[7:0], temp[8], E1, E2, 1'b0);
	Adder9 e1e2diff127_1({sw1, w_E}, cout, temp, 9'b110000000, 1'b1);
	HalfAdder e1e2diff127_2(sw2, c, 1'b1, cout);
	mux4to1_8bit select(E, {sw2, sw1}, w_E, 8'b11111111, 8'b0, 8'b0);
endmodule 

module Fraction_compute(F, cout, F1, F2);
	output [22:0] F;
	output cout;
	input [24:0] F1, F2;
	wire [24:0] temp, temp0, temp1, temp2,temp3,temp4,temp5,temp6,temp7,temp8,temp9,temp10, temp11,temp12,temp13,temp14,temp15,temp16,temp17,temp18, temp19, temp20,temp21, temp22, temp23, temp_sum;
	
	and_1bit_vs_25bit stage0(temp0, F1, F2[0]);
	Fraction_component f0(temp1, F1, {1'b0,temp0[24:1]}, F2[1]);
	Fraction_component f1(temp2, F1, {1'b0,temp1[24:1]}, F2[2]);
	Fraction_component f2(temp3, F1, {1'b0,temp2[24:1]}, F2[3]);
	Fraction_component f3(temp4, F1, {1'b0,temp3[24:1]}, F2[4]);
	Fraction_component f4(temp5, F1, {1'b0,temp4[24:1]}, F2[5]);
	Fraction_component f5(temp6, F1, {1'b0,temp5[24:1]}, F2[6]);
	Fraction_component f6(temp7, F1, {1'b0,temp6[24:1]}, F2[7]);
	Fraction_component f7(temp8, F1, {1'b0,temp7[24:1]}, F2[8]);
	Fraction_component f8(temp9, F1, {1'b0,temp8[24:1]}, F2[9]);
	Fraction_component f9(temp10, F1, {1'b0,temp9[24:1]}, F2[10]);
	Fraction_component f10(temp11, F1, {1'b0,temp10[24:1]}, F2[11]);
	Fraction_component f11(temp12, F1, {1'b0,temp11[24:1]}, F2[12]);
	Fraction_component f12(temp13, F1, {1'b0,temp12[24:1]}, F2[13]);
	Fraction_component f13(temp14, F1, {1'b0,temp13[24:1]}, F2[14]);
	Fraction_component f14(temp15, F1, {1'b0,temp14[24:1]}, F2[15]);
	Fraction_component f15(temp16, F1, {1'b0,temp15[24:1]}, F2[16]);
	Fraction_component f16(temp17, F1, {1'b0,temp16[24:1]}, F2[17]);
	Fraction_component f17(temp18, F1, {1'b0,temp17[24:1]}, F2[18]);
	Fraction_component f18(temp19, F1, {1'b0,temp18[24:1]}, F2[19]);
	Fraction_component f19(temp20, F1, {1'b0,temp19[24:1]}, F2[20]);
	Fraction_component f20(temp21, F1, {1'b0,temp20[24:1]}, F2[21]);
	Fraction_component f21(temp22, F1, {1'b0,temp21[24:1]}, F2[22]);
	Fraction_component f22(temp23, F1, {1'b0,temp22[24:1]}, F2[23]);
	Fraction_component f23({temp_sum[24], cout, temp_sum[22:0]}, F1, {1'b0,temp23[24:1]}, F2[24]);
	mux2to1_24bit choose_Value({F,c}, cout, {temp_sum[21:0], 2'b0}, {temp_sum[22:0], 1'b0});
endmodule 