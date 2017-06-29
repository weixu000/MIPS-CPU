`timescale 1ns / 1ps
module ALU_bitop(S,A,B,ALUFun);
output reg[31:0]S;
input [31:0]A,B;
input [3:0]ALUFun;

always@(*)
 case(ALUFun)
   4'b1000: S<=A&B;
   4'b1110:S<=A|B;
   4'b0110:S<=A^B;
   4'b0001:S<=~(A|B);
   4'b1010:S<=A;
   default:S<=0;
   endcase
endmodule
