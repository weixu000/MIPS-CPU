`timescale 1ns / 1ps
module ALU_shift(S, A, B, ALUFun);
output reg [31:0] S;
input [31:0] A,B;
input [1:0] ALUFun;

always@(*)
    case(ALUFun)
        2'b00: S <= B<<A[4:0];
        2'b01: S <= B>>A[4:0];
        2'b11: S <= {{31{B[31]}}, B}>>A[4:0];
        default: S <= 0;
    endcase
endmodule
