module root_square_component(X_nplus1, X_n, num_to_compute);
	wire [31:0] div_value;
	wire [31:0] temp;
	output [31:0] X_nplus1;
	input [31:0] X_n, num_to_compute;
		
	divide_main div(div_value, num_to_compute, X_n);
	Add_sub add(temp, X_n, div_value, 1'b0);
	Decrease8 dec(X_nplus1[30:23], cout, temp[30:23], 1'b1);
	assign X_nplus1[31] = temp[31];
	assign X_nplus1[22:0] = temp[22:0];
endmodule
	
module root_square_process(result, X);
	output [31:0] result;
	input [31:0] X;
	wire [31:0] X1,X2,X3,X4,X5,X6,X7,X8,X9;
	
	root_square_component phase1(X1, 32'b00111111100000000000000000000000, X);
	root_square_component phase2(X2, X1, X);
	root_square_component phase3(X3, X2, X);
	root_square_component phase4(X4, X3, X);
	root_square_component phase5(X5, X4, X);
	root_square_component phase6(X6, X5, X);
	root_square_component phase7(X7, X6, X);
	root_square_component phase8(X8, X7, X);
	root_square_component phase9(X9, X8, X);
	root_square_component phase10(result, X9, X);
endmodule 