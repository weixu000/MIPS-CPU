`timescale 1ns / 1ps
module UART_Controller(TX_DATA,TX_EN,TX_STATUS,RX_STATUS,sysclk,RX_DATA,reset);
output reg[7:0]TX_DATA;
output reg TX_EN;
input TX_STATUS,RX_STATUS,sysclk,reset;
input[7:0]RX_DATA;
reg flag;//标志位，确保在RX_DATA有有效值时才被传到TX_DATA
always@(posedge sysclk or negedge reset)
 if(~reset)
   TX_EN<=0;
 else if(TX_STATUS&&flag)
   TX_EN<=1;
 else
   TX_EN<=0;
always@(posedge TX_EN or negedge reset)
 if(~reset)
    TX_DATA<=8'b1111_1111;
 else if(flag)
    TX_DATA<=RX_DATA;
 else
    TX_DATA<=8'b1111_1111;
always@(posedge TX_STATUS or posedge RX_STATUS or negedge reset)
 if(~reset)
   flag<=0;
 else if(RX_STATUS)
   flag<=1;
 else if(TX_STATUS)
   flag<=0; 
endmodule
