module ALUIn_Forwarding(
    // EX->EX
    input [31:0] MEM_PC_4,
    input [4:0] MEM_Rd, MEM_Rt,
    input [31:0] MEM_ALUOut,
    input [1:0] MEM_RegDst,
    input MEM_RegWr,
    input [1:0] MEM_MemToReg,

    // MEM->EX
    input [31:0] WB_PC_4,
    input [4:0] WB_Rd, WB_Rt,
    input [1:0] WB_RegDst,
    input [1:0] WB_MemToReg,
    input WB_RegWr,
    input [31:0] WB_ALUOut, WB_MemOut,

    input [4:0] ALUIn_reg, // 原来寄存器编号
    input [31:0] ALUIn_prev, // 原来寄存器内容
    output reg [31:0] ALUIn_forw // forward以后的信号
);
always @(*) begin
    if (MEM_RegWr && MEM_MemToReg==0 && ALUIn_reg!=0
        && ( (MEM_RegDst==0 && ALUIn_reg==MEM_Rd)
           ||(MEM_RegDst==1 && ALUIn_reg==MEM_Rt)
           ||(MEM_RegDst==2 && ALUIn_reg==5'd31)
           ||(MEM_RegDst==3 && ALUIn_reg==5'd26))) begin
        ALUIn_forw <= MEM_ALUOut; // 上一指令保存ALUOut?
    end else // MEM_RegWr && MEM_MemToReg==1上一个指令要读内存，没法转发
    if (MEM_RegWr && MEM_MemToReg==2 && ALUIn_reg!=0
        && ( (MEM_RegDst==0 && ALUIn_reg==MEM_Rd)
           ||(MEM_RegDst==1 && ALUIn_reg==MEM_Rt)
           ||(MEM_RegDst==2 && ALUIn_reg==5'd31)
           ||(MEM_RegDst==3 && ALUIn_reg==5'd26))) begin
        ALUIn_forw <= MEM_PC_4; // 上一指令保存PC_4?
    end else
    if (WB_RegWr && WB_MemToReg==0 && ALUIn_reg!=0
        && ( (WB_RegDst==0 && ALUIn_reg==WB_Rd)
           ||(WB_RegDst==1 && ALUIn_reg==WB_Rt)
           ||(WB_RegDst==2 && ALUIn_reg==5'd31)
           ||(WB_RegDst==3 && ALUIn_reg==5'd26))) begin
        ALUIn_forw <= WB_ALUOut; // 上上条指令保存ALUOut?
    end else
    if (WB_RegWr && WB_MemToReg==1 && ALUIn_reg!=0
        && ( (WB_RegDst==0 && ALUIn_reg==WB_Rd)
           ||(WB_RegDst==1 && ALUIn_reg==WB_Rt)
           ||(WB_RegDst==2 && ALUIn_reg==5'd31)
           ||(WB_RegDst==3 && ALUIn_reg==5'd26))) begin
        ALUIn_forw <= WB_MemOut; // 上上条指令保存MemOut?
    end else
    if (WB_RegWr && WB_MemToReg==2 && ALUIn_reg!=0
    && ( (WB_RegDst==0 && ALUIn_reg==WB_Rd)
       ||(WB_RegDst==1 && ALUIn_reg==WB_Rt)
       ||(WB_RegDst==2 && ALUIn_reg==5'd31)
       ||(WB_RegDst==3 && ALUIn_reg==5'd26))) begin
        ALUIn_forw <= WB_PC_4; // 上上条指令保存PC_4?
    end else
        ALUIn_forw <= ALUIn_prev;
end
endmodule

module EX_DataBusB_Forwarding(
    // 上上条指令对DataBusB的改变
    input [31:0] WB_PC_4,
    input [4:0] WB_Rd, WB_Rt,
    input [1:0] WB_RegDst,
    input [1:0] WB_MemToReg,
    input WB_RegWr,
    input [31:0] WB_ALUOut, WB_MemOut,

    input [4:0] EX_DataBusB_reg, // 原来寄存器编号
    input [31:0] EX_DataBusB_prev, // 原来寄存器内容
    output reg [31:0] EX_DataBusB_forw // forward以后的信号
);
always @(*) begin
    if (WB_RegWr && WB_MemToReg==0 && EX_DataBusB_reg!=0
        && ( (WB_RegDst==0 && EX_DataBusB_reg==WB_Rd)
           ||(WB_RegDst==1 && EX_DataBusB_reg==WB_Rt)
           ||(WB_RegDst==2 && EX_DataBusB_reg==5'd31)
           ||(WB_RegDst==3 && EX_DataBusB_reg==5'd26))) begin
        EX_DataBusB_forw <= WB_ALUOut; // 上上条指令保存ALUOut?
    end else
    if (WB_RegWr && WB_MemToReg==1 && EX_DataBusB_reg!=0
        && ( (WB_RegDst==0 && EX_DataBusB_reg==WB_Rd)
           ||(WB_RegDst==1 && EX_DataBusB_reg==WB_Rt)
           ||(WB_RegDst==2 && EX_DataBusB_reg==5'd31)
           ||(WB_RegDst==3 && EX_DataBusB_reg==5'd26))) begin
        EX_DataBusB_forw <= WB_MemOut; // 上上条指令保存MemOut?
    end else
    if (WB_RegWr && WB_MemToReg==2 && EX_DataBusB_reg!=0
    && ( (WB_RegDst==0 && EX_DataBusB_reg==WB_Rd)
       ||(WB_RegDst==1 && EX_DataBusB_reg==WB_Rt)
       ||(WB_RegDst==2 && EX_DataBusB_reg==5'd31)
       ||(WB_RegDst==3 && EX_DataBusB_reg==5'd26))) begin
        EX_DataBusB_forw <= WB_PC_4; // 上上条指令保存PC_4?
    end else
        EX_DataBusB_forw <= EX_DataBusB_prev;
end
endmodule

module MEM_DataBusB_Forwarding(
    // 上上条指令对DataBusB的改变
    input [31:0] WB_PC_4,
    input [4:0] WB_Rd, WB_Rt,
    input [1:0] WB_RegDst,
    input [1:0] WB_MemToReg,
    input WB_RegWr,
    input [31:0] WB_ALUOut, WB_MemOut,

    input [4:0] MEM_DataBusB_reg, // 原来寄存器编号
    input [31:0] MEM_DataBusB_prev, // 原来寄存器内容
    output reg [31:0] MEM_DataBusB_forw // forward以后的信号
);
always @(*) begin
    if (WB_RegWr && WB_MemToReg==0 && MEM_DataBusB_reg!=0
        && ( (WB_RegDst==0 && MEM_DataBusB_reg==WB_Rd)
           ||(WB_RegDst==1 && MEM_DataBusB_reg==WB_Rt)
           ||(WB_RegDst==2 && MEM_DataBusB_reg==5'd31)
           ||(WB_RegDst==3 && MEM_DataBusB_reg==5'd26))) begin
        MEM_DataBusB_forw <= WB_ALUOut; // 上条指令保存ALUOut?
    end else
    if (WB_RegWr && WB_MemToReg==1 && MEM_DataBusB_reg!=0
        && ( (WB_RegDst==0 && MEM_DataBusB_reg==WB_Rd)
           ||(WB_RegDst==1 && MEM_DataBusB_reg==WB_Rt)
           ||(WB_RegDst==2 && MEM_DataBusB_reg==5'd31)
           ||(WB_RegDst==3 && MEM_DataBusB_reg==5'd26))) begin
        MEM_DataBusB_forw <= WB_MemOut; // 上条指令保存MemOut?
    end else
    if (WB_RegWr && WB_MemToReg==2 && MEM_DataBusB_reg!=0
        && ( (WB_RegDst==0 && MEM_DataBusB_reg==WB_Rd)
           ||(WB_RegDst==1 && MEM_DataBusB_reg==WB_Rt)
           ||(WB_RegDst==2 && MEM_DataBusB_reg==5'd31)
           ||(WB_RegDst==3 && MEM_DataBusB_reg==5'd26))) begin
        MEM_DataBusB_forw <= WB_PC_4; // 上条指令保存PC_4?
    end else
        MEM_DataBusB_forw <= MEM_DataBusB_prev;
end
endmodule

module AheadBranch_Forwarding(
    // 上上周期ALUOut，PC_4可以转发
    input [31:0] MEM_PC_4,
    input [4:0] MEM_Rd, MEM_Rt,
    input [31:0] MEM_ALUOut,
    input [1:0] MEM_RegDst,
    input MEM_RegWr,
    input [1:0] MEM_MemToReg,

    // 上上周期MEMOut不能转发

    // 上周期PC_4可以转发
    // 上周期ALUOut,MEMOut不能转发
    input [31:0] EX_PC_4,
    input [4:0] EX_Rd, EX_Rt,
    input [1:0] EX_RegDst,
    input EX_RegWr,
    input [1:0] EX_MemToReg

    input [4:0] In_reg, // 原来寄存器编号
    input [31:0] In_prev, // 原来寄存器内容
    output reg [31:0] In_forw // forward以后的信号
);
always @(*) begin
    if (MEM_RegWr && MEM_MemToReg==0 && In_reg!=0
        && ( (MEM_RegDst==0 && In_reg==MEM_Rd)
           ||(MEM_RegDst==1 && In_reg==MEM_Rt)
           ||(MEM_RegDst==2 && In_reg==5'd31)
           ||(MEM_RegDst==3 && In_reg==5'd26))) begin
        In_forw <= MEM_ALUOut; // 上上指令保存ALUOut?
    end else // MEM_RegWr && MEM_MemToReg==1上上个指令要读内存，没法转发
    if (MEM_RegWr && MEM_MemToReg==2 && In_reg!=0
        && ( (MEM_RegDst==0 && In_reg==MEM_Rd)
           ||(MEM_RegDst==1 && In_reg==MEM_Rt)
           ||(MEM_RegDst==2 && In_reg==5'd31)
           ||(MEM_RegDst==3 && In_reg==5'd26))) begin
        In_forw <= MEM_PC_4; // 上上指令保存PC_4?
    end else
    if (EX_RegWr && EX_MemToReg==2 && In_reg!=0
        && ( (EX_RegDst==0 && In_reg==EX_Rd)
           ||(EX_RegDst==1 && In_reg==EX_Rt)
           ||(EX_RegDst==2 && In_reg==5'd31)
           ||(EX_RegDst==3 && In_reg==5'd26))) begin
        In_forw <= MEM_PC_4; // 上上指令保存PC_4?
end
endmodule