`timescale 1ns / 1ps
module UART_generatortb;
wire gclk;
reg sysclk;
reg reset;
initial
fork
sysclk<=0;
reset<=0;
forever #1 sysclk<=~sysclk;
#1 reset<=1;
join
 UART_generator x1(gclk,sysclk,reset);
endmodule
