`timescale 1ns / 1ps
module Control_tb;
reg [31:0] Instruct;
reg IRQ;
wire [2:0] PCSrc;
wire [1:0] RegDst;
wire RegWr;
wire ALUSrc1, ALUSrc2;
wire [5:0] ALUFun;
wire MemWr, MemRd;
wire [1:0] MemToReg;
wire EXTOp;
wire LUOp;
Control control(Instruct, IRQ, PCSrc, RegDst, RegWr, ALUSrc1, ALUSrc2, ALUFun, MemWr, MemRd, MemToReg, EXTOp, LUOp);

initial begin
    IRQ = 0;
    Instruct = 0;
    $monitor("%d", Instruct);
    #5 Instruct[31:26] = 6'h00;
       Instruct[5:0] = 6'h20;
    #5 Instruct[31:26] = 6'h00;
       Instruct[5:0] = 6'h21;
    #5 Instruct[31:26] = 6'h00;
       Instruct[5:0] = 6'h22;
    #5 Instruct[31:26] = 6'h00;
       Instruct[5:0] = 6'h23;
    #5 Instruct[31:26] = 6'h00;
       Instruct[5:0] = 6'h24;
    #5 Instruct[31:26] = 6'h00;
       Instruct[5:0] = 6'h25;
    #5 Instruct[31:26] = 6'h00;
       Instruct[5:0] = 6'h26;
    #5 Instruct[31:26] = 6'h00;
       Instruct[5:0] = 6'h27;
    #5 Instruct[31:26] = 6'h00;
       Instruct[5:0] = 6'h00;
    #5 Instruct[31:26] = 6'h00;
       Instruct[5:0] = 6'h02;
    #5 Instruct[31:26] = 6'h00;
       Instruct[5:0] = 6'h03;
    #5 Instruct[31:26] = 6'h00;
       Instruct[5:0] = 6'h2A;
    #5 Instruct[31:26] = 6'h00;
       Instruct[5:0] = 6'h2B;
    #5 Instruct[31:26] = 6'h00;
       Instruct[5:0] = 6'h08;
    #5 Instruct[31:26] = 6'h00;
       Instruct[5:0] = 6'h09;

    #5 Instruct[31:26] = 6'h23;
    #5 Instruct[31:26] = 6'h2B;
    #5 Instruct[31:26] = 6'h0F;
    #5 Instruct[31:26] = 6'h08;
    #5 Instruct[31:26] = 6'h09;
    #5 Instruct[31:26] = 6'h0C;
    #5 Instruct[31:26] = 6'h0A;
    #5 Instruct[31:26] = 6'h0B;
    #5 Instruct[31:26] = 6'h04;
    #5 Instruct[31:26] = 6'h05;
    #5 Instruct[31:26] = 6'h06;
    #5 Instruct[31:26] = 6'h07;
    #5 Instruct[31:26] = 6'h01;
    #5 Instruct[31:26] = 6'h02;
    #5 Instruct[31:26] = 6'h03;
end
endmodule