`timescale 1ns / 1ps
module Test_Receiver;
reg UART_RXD;
wire gclk;
reg reset;
reg sysclk;
wire RX_STATUS;
wire[7:0]RX_DATA;
wire[31:0]count;
wire start;
initial
begin
	reset=0;
	#10 reset=1;
	sysclk=0;
	UART_RXD=1;
end

always
begin
	#1 sysclk=~sysclk;
end

initial repeat(10)
begin
	#20833 UART_RXD=~UART_RXD;
end
UART_generator x1(gclk,sysclk,reset);
UART_Receiver x2(count,start,RX_STATUS,RX_DATA,sysclk,gclk,UART_RXD,reset);
endmodule