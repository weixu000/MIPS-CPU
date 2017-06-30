`timescale 1ns / 1ps
module digitial_scan(digi1,digi2,digi3,digi4,digi_in);
//确保小数点不亮，输出改为8位
output [7:0]digi1,digi2,digi3,digi4;
input [11:0]digi_in;
assign digi1=(digi_in[11:8]==4'b1110)?digi_in[7:0]:8'b1111_1111;
assign digi2=(digi_in[11:8]==4'b1101)?digi_in[7:0]:8'b1111_1111;
assign digi3=(digi_in[11:8]==4'b1011)?digi_in[7:0]:8'b1111_1111;
assign digi4=(digi_in[11:8]==4'b0111)?digi_in[7:0]:8'b1111_1111;
endmodule
