module t_FPAU;

reg [31:0]N1,N2;
reg [1:0]operator;
wire [31:0]result;

FPAUnit fp(result, N1, N2, operator);

initial begin
	N1=32'h20348276;
	N2=32'h39187364;
	operator = 2'b00;
#100 
	N1=32'h20348276;
	N2=32'h39187364;
	operator = 2'b01;
#100
$finish;
end
endmodule
