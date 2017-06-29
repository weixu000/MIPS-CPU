module Control(
    input [31:0] Instruct,
    input IRQ,
    output [2:0] PCSrc,
    output [1:0] RegDst,
    output RegWr,
    output ALUSrc1, ALUSrc2,
    output [5:0] ALUFun,
    output Sign,
    output MemWr, MemRd,
    output [1:0] MemToReg,
    output EXTOp,
    output LUOp
);
wire [5:0] opcode, funct;
assign opcode = Instruct[31:26],
       funct = Instruct[5:0];
endmodule