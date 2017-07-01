`timescale 1ns / 1ps
module CPU_tb;
reg reset, clk;
CPU cpu(reset, clk, 0, , ,0, );

initial begin
    reset = 1;
    clk = 1;
    #5 reset = 0;
    #5 reset = 1;
    forever #5 clk = ~clk;
end
endmodule