`timescale 1ns / 1ps
module UART_Receiver(count,start,RX_STATUS,RX_DATA,sysclk,gclk,UART_RXD,reset);
output reg RX_STATUS;
output reg[7:0]RX_DATA;
input sysclk,gclk,UART_RXD,reset;
output integer count;//计数变量
output reg start;
reg [7:0]DATA;//缓存数据
always@(posedge sysclk or negedge reset)
 if(~reset)
   RX_STATUS<=0;
 else if(count==32'd160)
   RX_STATUS<=1;
 else
   RX_STATUS<=0;
always @(posedge gclk or negedge reset)
  if(~reset)
    count<=0;
  else if(~start)
    count<=0;
  else
    count<=count+1;
always@(posedge sysclk or negedge reset)
 if(~reset)
    start<=0;
 else if(~start&&UART_RXD==0)
    start<=1;
 else if(count==32'd160)
    start<=0;
always@(posedge sysclk)
    case(count)
    24:DATA[0]<=UART_RXD;
    40:DATA[1]<=UART_RXD;
    56:DATA[2]<=UART_RXD;
    72:DATA[3]<=UART_RXD;
    88:DATA[4]<=UART_RXD;
    104:DATA[5]<=UART_RXD;
    120:DATA[6]<=UART_RXD;
    136:DATA[7]<=UART_RXD;
    endcase
always@(posedge sysclk)
    if(count==32'd160)
    RX_DATA<=DATA;
    
endmodule
