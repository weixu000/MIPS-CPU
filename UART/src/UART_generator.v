module UART_generator(gclk,sysclk,reset);
output reg gclk;
input sysclk,reset;
localparam divide=81;//分频
integer count;//计数变量

always @(posedge sysclk or negedge reset)
  if(~reset)
    begin
    count<=0;
    gclk<=0;
    end
  else 
    if(count==divide)
       begin
       gclk<=~gclk;
       count<=0;
       end
    else
       count<=count+1;
     
   
endmodule
