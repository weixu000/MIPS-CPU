`timescale 1ns / 1ps
module UART_Controller(TX_DATA,TX_EN,TX_STATUS,RX_STATUS,sysclk,RX_DATA,reset);
output [7:0]TX_DATA;
output TX_EN;
input TX_STATUS,RX_STATUS,sysclk,reset;
input[7:0]RX_DATA;

always@(posedge sysclk or negedge reset)
 if(~reset)
   
endmodule
