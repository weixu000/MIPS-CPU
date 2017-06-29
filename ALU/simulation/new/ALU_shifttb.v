`timescale 1ns / 1ps
module ALU_shifttb;
wire[31:0]S;
reg[31:0]A,B;
reg[1:0]ALUFun;
initial
begin
A<=32'd3;
B<=32'b1111_1111_1111_1111_1111_1111_1111_1111;
ALUFun<=2'b11;
end
ALU_shift x4(S,A,B,ALUFun);
endmodule
