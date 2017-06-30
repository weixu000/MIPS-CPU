`timescale 1ns / 1ps
module UART_Sender(UART_TX,TX_STATUS,TX_EN,TX_DATA,sysclk,gclk,reset);
output reg UART_TX,TX_STATUS;
input[7:0]TX_DATA;
input sysclk,gclk,TX_EN,reset;
 integer count;//¼ÆÊý

always @(posedge sysclk or negedge reset)
 if(~reset)
   TX_STATUS<=1;
 else 
   if(TX_EN) 
      TX_STATUS<=0;
   else if(count==32'd160)
      TX_STATUS<=1;
always @(posedge gclk or negedge reset or posedge TX_STATUS)
 if(~reset)
   count<=0;
 else if(TX_STATUS)
      count<=0;
 else
   count<=count+1;
always@(posedge sysclk)
   case(count)
   8:UART_TX<=0;
   24:UART_TX<=TX_DATA[0];
   40:UART_TX<=TX_DATA[1];
   56:UART_TX<=TX_DATA[2];
   72:UART_TX<=TX_DATA[3];
   88:UART_TX<=TX_DATA[4];
   104:UART_TX<=TX_DATA[5];
   120:UART_TX<=TX_DATA[6];
   136:UART_TX<=TX_DATA[7];
   152:UART_TX<=1;
   endcase
   
endmodule
