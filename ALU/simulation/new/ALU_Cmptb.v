`timescale 1ns / 1ps
module ALU_Cmptb;
reg Z,V,N;
reg[2:0]ALUFun;
wire [31:0]S;
initial
begin
Z<=0;
V<=0;
N<=0;
ALUFun<=3'b010;
end
 ALU_Cmp x3(S,Z,V,N,ALUFun);
endmodule
