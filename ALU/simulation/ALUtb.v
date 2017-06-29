`timescale 1ns / 1ps
module alu_tb;
 //仿真所有支持的操作
  reg [31:0]a,b;
  reg [5:0]alufun;
  reg sign;
  wire [31:0]res;
  
  initial
    begin
      a<=32'h5;
      b<=32'h0;
      sign<=1;
      alufun<=6'b000000;
      #100 alufun<=6'b000001;
      #100 alufun<=6'b011000;
      #100 alufun<=6'b011110;
      #100 alufun<=6'b010110;
      #100 alufun<=6'b010001;
      #100 alufun<=6'b011010;
      #100 alufun<=6'b100000;
      #100 alufun<=6'b100001;
      #100 alufun<=6'b100011;
      #100 alufun<=6'b110011;
      #100 alufun<=6'b110001;
      #100 alufun<=6'b110101;
      #100 alufun<=6'b111101;
      #100 alufun<=6'b111011;
      #100 alufun<=6'b111111;
      end
  
 ALU alu(.A(a),.B(b),.ALUFun(alufun),.Sign(sign),.Z(res));

endmodule

