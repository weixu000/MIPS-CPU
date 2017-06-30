`timescale 1ns / 1ps
module UART_tb;//测试
reg UART_RX;
wire gclk;
reg reset;
reg sysclk;
wire RX_STATUS;
wire[7:0]RX_DATA;
wire[7:0]TX_DATA;
wire TX_STATUS;
wire TX_EN;
wire UART_TX;
wire start;
initial
begin
	reset=0;
	#10 reset=1;
	sysclk=0;
	UART_RX=1;
	#308330 reset=1;
	repeat(10)
	#20833 UART_RX=~UART_RX;
end

always
begin
	#1 sysclk=~sysclk;
end

initial repeat(10)
begin
	#20833 UART_RX=~UART_RX;
end
UART_generator x1(gclk,sysclk,reset);
UART_Receiver x2(RX_STATUS,RX_DATA,sysclk,gclk,UART_RX,reset);
UART_Controller x3(TX_DATA,TX_EN,TX_STATUS,RX_STATUS,sysclk,RX_DATA,reset);
UART_Sender x4(UART_TX,TX_STATUS,TX_EN,TX_DATA,sysclk,gclk,reset);
endmodule