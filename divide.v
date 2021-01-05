module divide_component(result_bit, A_next, A, B);
	// A/B
	output result_bit;
	output [24:0] A_next;
	input [24:0] A;
	input [23:0] B;
	wire AgtB;
	wire [23:0] temp;
	
	comparator25 compare(AgtB, A, {1'b0, B});
	mux2to1 b0(result_bit, AgtB, 1'b0, 1'b1);
	mux2to1_24bit b1(temp, AgtB, 24'b0, B);
	Adder25 add(A_next[24:1], c, A, ~temp, 1'b1);
	assign A_next[0] = 1'b0;
endmodule 

module exponentOfDivide(E, E1, E2);
	output [7:0] E;
	input [7:0] E1, E2;
	wire [8:0] temp;
	wire [7:0] w_E;

	Fast_Adder8 e1puse2(temp[7:0], temp[8], E1, 8'b01111111, 1'b0);
	Adder9 e1e2diff127_1({sw1, w_E}, cout, temp, {1'b1, ~E2}, 1'b1);
	HalfAdder e1e2diff127_2(sw2, c, 1'b1, cout);
	mux4to1_8bit select(E, {sw2, sw1}, w_E, 8'b11111111, 8'b0, 8'b0);
endmodule 

module divide_process(divide_result, NaN, A, B);
	output [31:0] divide_result;
	output NaN;
	input [31:0] A, B;
	wire switch;
	wire [30:0] w_result;
	wire [24:0] next0, next1, next2, next3, next4, next5, next6, next7, next8, next9, next10, next11, next12, next13, next14, next15, next16, next17, next18, next19, next20, next21, next22;
	
	exponentOfDivide ex(w_result[30:23], A[30:23], B[30:23]);
	divide_component d0(switch, next0, {1'b0, 1'b1, A[22:0]}, {1'b1, B[22:0]});
	divide_component d1(w_result[22], next1, next0, {1'b1, B[22:0]});
	divide_component d2(w_result[21], next2, next1, {1'b1, B[22:0]});
	divide_component d3(w_result[20], next3, next2, {1'b1, B[22:0]});
	divide_component d4(w_result[19], next4, next3, {1'b1, B[22:0]});
	divide_component d5(w_result[18], next5, next4, {1'b1, B[22:0]});
	divide_component d6(w_result[17], next6, next5, {1'b1, B[22:0]});
	divide_component d7(w_result[16], next7, next6, {1'b1, B[22:0]});
	divide_component d8(w_result[15], next8, next7, {1'b1, B[22:0]});
	divide_component d9(w_result[14], next9, next8, {1'b1, B[22:0]});
	divide_component d10(w_result[13], next10, next9, {1'b1, B[22:0]});
	divide_component d11(w_result[12], next11, next10, {1'b1, B[22:0]});
	divide_component d12(w_result[11], next12, next11, {1'b1, B[22:0]});
	divide_component d13(w_result[10], next13, next12, {1'b1, B[22:0]});
	divide_component d14(w_result[9], next14, next13, {1'b1, B[22:0]});
	divide_component d15(w_result[8], next15, next14, {1'b1, B[22:0]});
	divide_component d16(w_result[7], next16, next15, {1'b1, B[22:0]});
	divide_component d17(w_result[6], next17, next16, {1'b1, B[22:0]});
	divide_component d18(w_result[5], next18, next17, {1'b1, B[22:0]});
	divide_component d19(w_result[4], next19, next18, {1'b1, B[22:0]});
	divide_component d20(w_result[3], next20, next19, {1'b1, B[22:0]});
	divide_component d21(w_result[2], next21, next20, {1'b1, B[22:0]});
	divide_component d22(w_result[1], next22, next21, {1'b1, B[22:0]});
	divide_component d23(w_result[0], next, next22, {1'b1, B[22:0]});
	mux2to1_24bit choose_value({c, divide_result[22:0]}, switch, {1'b0, w_result[21:0], 1'b0}, {1'b0, w_result[22:0]});
	Decrease8 dec(divide_result[30:23], NaN, w_result[30:23], ~switch);
	xor(divide_result[31], A[31], B[31]);
endmodule 