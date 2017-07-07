module ALUIn_Forwarding(
    // EX->EX
    input [31:0] MEM_PC_4;
    input [4:0] MEM_Rd, MEM_Rt;
    input [31:0] MEM_ALUOut;
    input [1:0] MEM_RegDst;
    input MEM_RegWr;
    input [1:0] MEM_MemToReg;

    // MEM->EX
    input [31:0] WB_PC_4;
    input [4:0] WB_Rd, WB_Rt;
    input [1:0] WB_RegDst;
    input [1:0] WB_MemToReg;
    input WB_RegWr;
    input [31:0] WB_ALUOut, WB_MemOut;

    input [4:0] ALUIn_reg; // 原来寄存器编号
    input [31:0] ALUIn_prev; // 原来寄存器内容
    output reg [31:0] ALUIn_forw; // forward以后的信号
);
always @(*) begin
    if (MEM_RegWr && MEM_MemToReg==0
        && ( (MEM_RegDst==0 && ALUIn_reg==MEM_Rd && MEM_Rd!=0)
           ||(MEM_RegDst==1 && ALUIn_reg==MEM_Rt && MEM_Rd!=0)
           ||(MEM_RegDst==2 && ALUIn_reg==5'd31)
           ||(MEM_RegDst==3 && ALUIn_reg==5'd26))) begin
        ALUIn_forw <= MEM_ALUOut; // 上一指令保存ALUOut?
    end else // MEM_RegWr && MEM_MemToReg==1上一个指令要读内存，没法转发
    if (MEM_RegWr && MEM_MemToReg==2
        && ( (MEM_RegDst==0 && ALUIn_reg==MEM_Rd && MEM_Rd!=0)
           ||(MEM_RegDst==1 && ALUIn_reg==MEM_Rt && MEM_Rd!=0)
           ||(MEM_RegDst==2 && ALUIn_reg==5'd31)
           ||(MEM_RegDst==3 && ALUIn_reg==5'd26))) begin
        ALUIn_forw <= MEM_PC_4; // 上一指令保存PC_4?
    end else
    if (WB_RegWr && WB_MemToReg==0
        && ( (WB_RegDst==0 && ALUIn_reg==WB_Rd && WB_Rd!=0)
           ||(WB_RegDst==1 && ALUIn_reg==WB_Rt && WB_Rd!=0)
           ||(WB_RegDst==2 && ALUIn_reg==5'd31)
           ||(WB_RegDst==3 && ALUIn_reg==5'd26))) begin
        ALUIn_forw <= WB_ALUOut; // 上上条指令保存ALUOut?
    end else
    if (WB_RegWr && WB_MemToReg==1
        && ( (WB_RegDst==0 && ALUIn_reg==WB_Rd && WB_Rd!=0)
           ||(WB_RegDst==1 && ALUIn_reg==WB_Rt && WB_Rd!=0)
           ||(WB_RegDst==2 && ALUIn_reg==5'd31)
           ||(WB_RegDst==3 && ALUIn_reg==5'd26))) begin
        ALUIn_forw <= WB_MemOut; // 上上条指令保存MemOut?
    end else
    if (WB_RegWr && WB_MemToReg==2
    && ( (WB_RegDst==0 && ALUIn_reg==WB_Rd && WB_Rd!=0)
       ||(WB_RegDst==1 && ALUIn_reg==WB_Rt && WB_Rd!=0)
       ||(WB_RegDst==2 && ALUIn_reg==5'd31)
       ||(WB_RegDst==3 && ALUIn_reg==5'd26))) begin
        ALUIn_forw <= WB_PC_4; // 上上条指令保存PC_4?
    end else
        ALUIn_forw <= ALUIn_prev;
end
endmodule

module EX_DataBusB_Forwarding(
    // MEM->EX
    input [31:0] WB_PC_4;
    input [4:0] WB_Rd, WB_Rt;
    input [1:0] WB_RegDst;
    input [1:0] WB_MemToReg;
    input WB_RegWr;
    input [31:0] WB_ALUOut, WB_MemOut;

    input [4:0] EX_DataBusB_reg; // 原来寄存器编号
    input [31:0] EX_DataBusB_prev; // 原来寄存器内容
    output reg [31:0] EX_DataBusB_forw; // forward以后的信号
);
always @(*) begin
    if (WB_RegWr && WB_MemToReg==0
        && ( (WB_RegDst==0 && EX_DataBusB_reg==WB_Rd && WB_Rd!=0)
           ||(WB_RegDst==1 && EX_DataBusB_reg==WB_Rt && WB_Rd!=0)
           ||(WB_RegDst==2 && EX_DataBusB_reg==5'd31)
           ||(WB_RegDst==3 && EX_DataBusB_reg==5'd26))) begin
        EX_DataBusB_forw <= WB_ALUOut; // 上上条指令保存ALUOut?
    end else
    if (WB_RegWr && WB_MemToReg==1
        && ( (WB_RegDst==0 && EX_DataBusB_reg==WB_Rd && WB_Rd!=0)
           ||(WB_RegDst==1 && EX_DataBusB_reg==WB_Rt && WB_Rd!=0)
           ||(WB_RegDst==2 && EX_DataBusB_reg==5'd31)
           ||(WB_RegDst==3 && EX_DataBusB_reg==5'd26))) begin
        EX_DataBusB_forw <= WB_MemOut; // 上上条指令保存MemOut?
    end else
    if (WB_RegWr && WB_MemToReg==2
    && ( (WB_RegDst==0 && EX_DataBusB_reg==WB_Rd && WB_Rd!=0)
       ||(WB_RegDst==1 && EX_DataBusB_reg==WB_Rt && WB_Rd!=0)
       ||(WB_RegDst==2 && EX_DataBusB_reg==5'd31)
       ||(WB_RegDst==3 && EX_DataBusB_reg==5'd26))) begin
        EX_DataBusB_forw <= WB_PC_4; // 上上条指令保存PC_4?
    end else
        EX_DataBusB_forw <= EX_DataBusB_prev;
end
endmodule

module MEM_DataBusB_Forwarding(
    // MEM->MEM
    input [31:0] WB_PC_4;
    input [4:0] WB_Rd, WB_Rt;
    input [1:0] WB_RegDst;
    input [1:0] WB_MemToReg;
    input WB_RegWr;
    input [31:0] WB_ALUOut, WB_MemOut;

    input [4:0] MEM_DataBusB_reg; // 原来寄存器编号
    input [31:0] MEM_DataBusB_prev; // 原来寄存器内容
    output reg [31:0] MEM_DataBusB_forw; // forward以后的信号
);
always @(*) begin
    if (WB_RegWr && WB_MemToReg==0
        && ( (WB_RegDst==0 && MEM_DataBusB_reg==WB_Rd && WB_Rd!=0)
           ||(WB_RegDst==1 && MEM_DataBusB_reg==WB_Rt && WB_Rd!=0)
           ||(WB_RegDst==2 && MEM_DataBusB_reg==5'd31)
           ||(WB_RegDst==3 && MEM_DataBusB_reg==5'd26))) begin
        MEM_DataBusB_forw <= WB_ALUOut; // 上条指令保存ALUOut?
    end else
    if (WB_RegWr && WB_MemToReg==1
        && ( (WB_RegDst==0 && MEM_DataBusB_reg==WB_Rd && WB_Rd!=0)
           ||(WB_RegDst==1 && MEM_DataBusB_reg==WB_Rt && WB_Rd!=0)
           ||(WB_RegDst==2 && MEM_DataBusB_reg==5'd31)
           ||(WB_RegDst==3 && MEM_DataBusB_reg==5'd26))) begin
        MEM_DataBusB_forw <= WB_MemOut; // 上条指令保存MemOut?
    end else
    if (WB_RegWr && WB_MemToReg==2
    && ( (WB_RegDst==0 && MEM_DataBusB_reg==WB_Rd && WB_Rd!=0)
       ||(WB_RegDst==1 && MEM_DataBusB_reg==WB_Rt && WB_Rd!=0)
       ||(WB_RegDst==2 && MEM_DataBusB_reg==5'd31)
       ||(WB_RegDst==3 && MEM_DataBusB_reg==5'd26))) begin
        MEM_DataBusB_forw <= WB_PC_4; // 上条指令保存PC_4?
    end else
        MEM_DataBusB_forw <= MEM_DataBusB_prev;
end
endmodule