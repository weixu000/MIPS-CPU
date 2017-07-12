module Harzard(
    input [5:0] opcode, funct,
    input [2:0] PCSrc,

    input [4:0] ID_Rt, ID_Rs,
    input ID_ALUSrc1, ID_ALUSrc2,
    input Branch,

    input [4:0] EX_Rt,
    input EX_MemRd,

    input IRQ, ID_NoIRQ,

    output reg [1:0] IF_ID_Src,
    output reg IF_NoIRQ,
               ID_EX_Stall,
               PCHold,
    output IRQ_h
);
assign IRQ_h = IRQ && 
               !(ID_NoIRQ
               ||(opcode==0&&(funct==6'h08||funct==6'h09)) //jr jalr
               ||(opcode==6'h04||opcode==6'h05||opcode==6'h06||opcode==6'h07||opcode==6'h01) // b
               ||(opcode==6'h02||opcode==6'h03)); //j  jal

always @(*) begin
    // 中断，异常
    if (PCSrc==4 || PCSrc==5) begin
        IF_ID_Src <= 1; //stall
        IF_NoIRQ <= 0;
        ID_EX_Stall <= 0; // 中断会保存PC_4到$26
        PCHold <= 0;
    end else
    // load-use
    if (EX_MemRd &&
       ((ID_ALUSrc1==0 && ID_Rs==EX_Rt)
      ||(ID_ALUSrc2==0 && ID_Rt==EX_Rt))) begin
        IF_ID_Src <= 2; //hold
        IF_NoIRQ <= 0;
        ID_EX_Stall <= 1;
        PCHold <= 1;
    end else
    // j
    if (PCSrc==2 || PCSrc==3) begin
        IF_ID_Src <= 1; //stall
        IF_NoIRQ <= 1;
        ID_EX_Stall <= 0;
        PCHold <= 0;
    end else
    // b
    if (PCSrc==1 && Branch) begin
        IF_ID_Src <= 1; //stall
        IF_NoIRQ <= 1;
        ID_EX_Stall <= 0;
        PCHold <= 0;
    end else begin
        IF_ID_Src <= 0;
        IF_NoIRQ <= 0;
        ID_EX_Stall <= 0;
        PCHold <= 0;
    end
end
endmodule