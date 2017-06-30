`timescale 1ns / 1ps
module Test_add;
reg [31:0]A,B;
reg ALUFun,Sign;
wire [31:0]S;
wire Z,V,N;
initial 
begin
	A=32'b0111_1111_1111_1111_1111_1111_1111_1111;
	B=32'b0111_1111_1111_1111_1111_1111_1111_1111;
	Sign=1;
	ALUFun=1;
end
ALU_arithmetic x1(.Z(Z),.V(V),.N(N),.S(S),.A(A),.B(B),.ALUFun(ALUFun),.Sign(Sign));
endmodule
