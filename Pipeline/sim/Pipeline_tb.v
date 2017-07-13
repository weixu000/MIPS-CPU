`timescale 1ns / 1ps
module Pipeline_tb;
reg reset, UART_RX, sysclk;
reg [7:0] switch;
wire [7:0] led;
wire [11:0] digi;
wire UART_TX;

initial begin
    reset <= 0;
    #1 reset <= 1;
	UART_RX <= 1;
    #89562
	repeat(10)
    #20833 UART_RX=~UART_RX;
    #50007
    #20833 UART_RX=0;
    #20833 UART_RX=1;
    #20833 UART_RX=1;
    #20833 UART_RX=1;
    #20833 UART_RX=1;
    #20833 UART_RX=1;
    #20833 UART_RX=1;
    #20833 UART_RX=1;
    #20833 UART_RX=1;
    #20833 UART_RX=1;
end
initial begin
    sysclk <= 0;
    while(1)
	#1 sysclk <= ~sysclk;
end
top t(reset, sysclk, UART_RX, UART_TX, led, 8'b0, digi);
endmodule
