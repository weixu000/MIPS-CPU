module Harzard(
    input [2:0] PCSrc,

    input [4:0] ID_Rt, ID_Rs,
    input ID_ALUSrc1, ID_ALUSrc2,
    input Branch,

    input [4:0] EX_Rt,
    input EX_MemRd,

    output reg IF_ID_Stall, IF_ID_Hold, ID_EX_Stall, PCHold
);
always @(*) begin
    if (EX_MemRd &&
       ((ID_ALUSrc1==0 && ID_Rs==EX_Rt)
      ||(ID_ALUSrc2==0 && ID_Rt==EX_Rt))) begin
        IF_ID_Stall <= 0;
        IF_ID_Hold <= 1;
        ID_EX_Stall <= 1;
        PCHold <= 1;
    end else
    if (PCSrc==2 || PCSrc==3) begin
        IF_ID_Stall <= 1;
        IF_ID_Hold <= 0;
        ID_EX_Stall <= 0;
        PCHold <= 0;
    end else
    if (PCSrc==1 || Branch) begin
        IF_ID_Stall <= 1;
        IF_ID_Hold <= 0;
        ID_EX_Stall <= 0;
        PCHold <= 0;
    end else begin
        IF_ID_Stall <= 0;
        IF_ID_Hold <= 0;
        ID_EX_Stall <= 0;
        PCHold <= 0;
    end
end
endmodule