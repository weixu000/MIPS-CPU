`timescale 1ns / 1ps
module ALU_Cmp(S,Z,V,N,ALUFun);
output reg[31:0]S;
input Z,V,N;
input [2:0]ALUFun;

always@(*)
   if(~V)
     case(ALUFun)
     3'b001:S<={31'b0,Z};
     3'b000:S<={31'b0,~Z};
     3'b010:S<={31'b0,N};
     3'b110:S<={31'b0,N|Z};
     3'b101:S<={31'b0,N};
     3'b111:S<={31'b0,(~N)&(~Z)};
     default: S<=0;
     endcase
    else
      S<=0;
endmodule
