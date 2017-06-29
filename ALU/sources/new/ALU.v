`timescale 1ns / 1ps
module ALU(Z,A,B,Sign,ALUFun);
//严格按照指导书上要求实现，需注意lez、ltz、gtz默认操作数B是0
output [31:0]Z;
input [5:0]ALUFun;
input [31:0]A,B;
input Sign;
wire zero;
wire V;
wire [31:0]res1,res2,res3,res4;
assign Z=(ALUFun[5:4]==2'b00)?res1:
         (ALUFun[5:4]==2'b01)?res2:
         (ALUFun[5:4]==2'b10)?res3:
         (ALUFun[5:4]==2'b11)?res4:
         32'b0;
ALU_algorithm x1(.Z(zero),.V(V),.N(N),.S(res1),.A(A),.B(B),.Sign(Sign),.ALUFun(ALUFun[0]));//算数操作
ALU_bitop x2(.S(res2),.A(A),.B(B),.ALUFun(ALUFun[3:0]));//位运算操作
ALU_shift x3(.S(res3),.A(A),.B(B),.ALUFun(ALUFun[1:0]));//移位运算操作
ALU_Cmp x4(.S(res4),.Z(zero),.V(V),.N(N),.ALUFun(ALUFun[3:1]));//关系运算操作
endmodule
