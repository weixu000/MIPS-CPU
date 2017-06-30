`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/30 16:41:05
// Design Name: 
// Module Name: Peripheraltb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Peripheraltb;
reg reset,rd,wr,UART_RX,sysclk,PC_31;
reg [31:0] wdata,addr;
reg [7:0] switch;
wire [31:0] rdata;
wire [7:0] led;
wire [11:0] digi;
wire  irqout;
wire UART_TX;
initial
begin
    PC_31<=0;
    reset<=0;
    #1 reset<=1;
	UART_RX <=1;
	wr<=0;
	rd<=0;;
	repeat(10)
    #20833 UART_RX=~UART_RX;
	#100000 rd<=1;
	addr<=32'h4000001c;
	#100000
	rd<=0;
	wr<=1;
	addr<=32'h40000018;	
	wdata<=32'd15;//0f
	#100 wr<=0;
	addr<=0;
end
initial
  begin
    sysclk<=0;
    while(1)
	#1 sysclk<=~sysclk;
 end

Peripheral x (reset,sysclk,rd,wr,addr,wdata,UART_RX,UART_TX,rdata,led,switch,digi,irqout,PC_31);
endmodule
