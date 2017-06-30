`timescale 1ns / 1ps
module ALU_bitoptb;
reg[31:0] A,B;
reg[3:0] ALUFun;
wire [31:0]S;
initial
begin
A<=32'd1;
B<=32'd1;
ALUFun<=4'b1000;
end
ALU_bitop x2(.S(S),.A(A),.B(B),.ALUFun(ALUFun));
endmodule
