module CPU(
    input reset, clk,

    input UART_RX,
    output UART_TX,
    output [7:0] led,
    input [7:0] switch,
    output [11:0] digi
);
reg [31:0] PC;
wire [31:0] IF_PC_4;
wire [31:0] ConBA;
wire [25:0] JT;
wire [31:0] ILLOP;
wire [31:0] XADR;
wire [2:0] PCSrc;
reg [31:0] PC_next;
wire [31:0] IF_Instruct;
wire IF_ID_Stall, ID_EX_Stall;
wire IF_ID_Hold, PCHold;

wire [31:0] ID_PC_4, ID_Instruct;
wire [15:0] Imm16;
wire [4:0] ID_Shamt;
wire [4:0] ID_Rd, ID_Rt, ID_Rs;
wire [5:0] opcode, funct;
wire IRQ;
wire EXTOp, LUOp;
wire ID_ALUSrc1, ID_ALUSrc2;
wire [1:0] ID_RegDst;
wire ID_RegWr;
wire [5:0] ID_ALUFun;
wire ID_MemWr, ID_MemRd;
wire [1:0] ID_MemToReg;
wire [31:0] ID_DataBusA, ID_DataBusB;
wire [31:0] ID_DataBusA_forw, ID_DataBusB_forw;
wire [31:0] ID_LUOut, EXTOut;
wire Branch;

wire [31:0] EX_PC_4;
wire [4:0] EX_Shamt;
wire [4:0] EX_Rd, EX_Rt, EX_Rs;
wire [31:0] EX_DataBusA, EX_DataBusB;
wire [31:0] EX_DataBusA_forw, EX_DataBusB_forw;
wire EX_ALUSrc1, EX_ALUSrc2;
wire [1:0] EX_RegDst;
wire EX_RegWr;
wire [5:0] EX_ALUFun;
wire EX_MemWr, EX_MemRd;
wire [1:0] EX_MemToReg;
wire [31:0] EX_LUOut;
wire [31:0] ALUIn1, ALUIn2, EX_ALUOut;

wire [31:0] MEM_PC_4;
wire [4:0] MEM_Rd, MEM_Rt;
wire [31:0] MEM_ALUOut;
wire [31:0] MEM_DataBusB, MEM_DataBusB_forw;
wire [1:0] MEM_RegDst;
wire MEM_RegWr;
wire MEM_MemWr, MEM_MemRd;
wire [1:0] MEM_MemToReg;
wire [31:0] MemOut1, MemOut2, MEM_MemOut; // 数据存储器 外设

wire [31:0] WB_PC_4;
wire [4:0] WB_Rd, WB_Rt;
wire [1:0] WB_RegDst;
wire WB_RegWr;
wire [1:0] WB_MemToReg;
wire [31:0] WB_ALUOut, WB_MemOut;
reg [31:0] WB_DataBusC;
reg [4:0] WB_AddrC;

// IF
assign IF_PC_4 = {PC[31], PC[30:0]+31'd4}; // 监督位不变
assign ILLOP = 32'h80000004;
assign XADR = 32'h80000008;
always @(*) begin
    case (PCSrc)
        0: PC_next <= IF_PC_4;
        1: PC_next <= Branch ? ConBA : IF_PC_4; // 应该在ID段加判断
        2: PC_next <= {IF_PC_4[31:28] ,JT, 2'b0};
        3: PC_next <= ID_DataBusA; // 跳转到寄存器
        4: PC_next <= ILLOP; // interrupt
        5: PC_next <= XADR; // exception
        default: PC_next <= 0;
    endcase
end
always @(negedge reset or posedge clk)
    if (~reset) PC <= 32'h80000000;
    else PC <= PCHold ? PC : PC_next;
ROM rom(PC[30:0], IF_Instruct);

// ID
IF_ID IF_ID_reg(reset, clk, IF_ID_Stall, IF_ID_Hold,
                IF_PC_4, IF_Instruct,
                ID_PC_4, ID_Instruct);
assign JT = ID_Instruct[25:0],
       Imm16 = ID_Instruct[15:0],
       ID_Shamt = ID_Instruct[10:6],
       ID_Rd = ID_Instruct[15:11],
       ID_Rt = ID_Instruct[20:16],
       ID_Rs = ID_Instruct[25:21],
       opcode = ID_Instruct[31:26],
       funct = ID_Instruct[5:0];
Control control(opcode, funct, IRQ, PCSrc, ID_RegDst, ID_RegWr, ID_ALUSrc1, ID_ALUSrc2, ID_ALUFun, ID_MemWr, ID_MemRd, ID_MemToReg, EXTOp, LUOp);
RegFile regfile(reset, clk, WB_RegWr, ID_Rs, ID_Rt, WB_AddrC, WB_DataBusC, ID_DataBusA, ID_DataBusB);
assign EXTOut = EXTOp ? {{16{Imm16[15]}}, Imm16} : {16'b0, Imm16},
       ID_LUOut = LUOp ?  {Imm16, 16'b0} : EXTOut,
       ConBA = ID_PC_4+(EXTOut<<2); // 分支指令转到这里，应该用ID_PC_4，还需修改
AheadBranch ab(ID_DataBusA_forw, ID_DataBusB_forw, ID_ALUFun, Branch);
AheadBranch_Forwarding ab_F1(MEM_PC_4, MEM_Rd, MEM_Rt, MEM_ALUOut, MEM_RegDst, MEM_RegWr, MEM_MemToReg,
                             EX_PC_4,  EX_Rd,  EX_Rt,  EX_RegDst, EX_RegWr, EX_MemToReg,
                             ID_Rs, ID_DataBusA, ID_DataBusA_forw);
AheadBranch_Forwarding ab_F2(MEM_PC_4, MEM_Rd, MEM_Rt, MEM_ALUOut, MEM_RegDst, MEM_RegWr, MEM_MemToReg,
                             EX_PC_4,  EX_Rd,  EX_Rt,  EX_RegDst, EX_RegWr, EX_MemToReg,
                             ID_Rt, ID_DataBusB, ID_DataBusB_forw);
Harzard harzard(PCSrc, ID_Rt, ID_Rs, ID_ALUSrc1, ID_ALUSrc2, Branch,
                EX_Rt, EX_MemRd,
                IF_ID_Stall, IF_ID_Hold, ID_EX_Stall, PCHold);

// EX
ID_EX ID_EX_Reg(reset, clk,ID_EX_Stall,
                ID_PC_4, ID_Shamt, ID_Rd, ID_Rt, ID_Rs, ID_DataBusA, ID_DataBusB, ID_ALUSrc1, ID_ALUSrc2, ID_RegDst, ID_RegWr, ID_ALUFun, ID_MemWr, ID_MemRd, ID_MemToReg, ID_LUOut,
                EX_PC_4, EX_Shamt, EX_Rd, EX_Rt, EX_Rs, EX_DataBusA, EX_DataBusB, EX_ALUSrc1, EX_ALUSrc2, EX_RegDst, EX_RegWr, EX_ALUFun, EX_MemWr, EX_MemRd, EX_MemToReg, EX_LUOut);
assign ALUIn1 = EX_ALUSrc1 ? EX_Shamt : EX_DataBusA_forw,
       ALUIn2 = EX_ALUSrc2 ? EX_LUOut : EX_DataBusB_forw;
ALU alu(ALUIn1, ALUIn2, EX_ALUFun, EX_ALUOut);
ALUIn_Forwarding ALUIn_F1(MEM_PC_4, MEM_Rd, MEM_Rt, MEM_ALUOut, MEM_RegDst,  MEM_RegWr, MEM_MemToReg,
                          WB_PC_4,  WB_Rd,  WB_Rt,  WB_RegDst,  WB_MemToReg, WB_RegWr,  WB_ALUOut, WB_MemOut,
                          EX_Rs, EX_DataBusA, EX_DataBusA_forw);
ALUIn_Forwarding ALUIn_F2(MEM_PC_4, MEM_Rd, MEM_Rt, MEM_ALUOut, MEM_RegDst,  MEM_RegWr, MEM_MemToReg,
                          WB_PC_4,  WB_Rd,  WB_Rt,  WB_RegDst,  WB_MemToReg, WB_RegWr,  WB_ALUOut, WB_MemOut,
                          EX_Rt, EX_DataBusB, EX_DataBusB_forw);

// MEM
EX_MEM EX_MEM_reg(reset, clk, EX_PC_4,  EX_Rd,  EX_Rt,  EX_ALUOut,  EX_DataBusB_forw,  EX_RegDst,  EX_RegWr,  EX_MemWr,  EX_MemRd,  EX_MemToReg,
                              MEM_PC_4, MEM_Rd, MEM_Rt, MEM_ALUOut, MEM_DataBusB,      MEM_RegDst, MEM_RegWr, MEM_MemWr, MEM_MemRd, MEM_MemToReg);
DataMem datamem(reset, clk, MEM_MemRd, MEM_MemWr, MEM_ALUOut, MEM_DataBusB, MemOut1);
Peripheral periph(reset, clk, MEM_MemRd, MEM_MemWr, MEM_ALUOut, MEM_DataBusB, MemOut2, UART_RX, UART_TX, led, switch, digi, IRQ, MEM_PC_4[31]); // PC[31]姑且用MEM_PC_4[31]
assign MEM_MemOut = MEM_ALUOut[30] ? MemOut2 : MemOut1;
MEM_DataBusB_Forwarding MEM_DataBusB_F (WB_PC_4, WB_Rd, WB_Rt, WB_RegDst, WB_MemToReg, WB_RegWr, WB_ALUOut, WB_MemOut,
                                        MEM_Rt, MEM_DataBusB, MEM_DataBusB_forw);

// WB
MEM_WB MEM_WB_reg(reset, clk, MEM_PC_4, MEM_Rd, MEM_Rt, MEM_RegDst, MEM_RegWr, MEM_MemToReg, MEM_ALUOut, MEM_MemOut,
                              WB_PC_4,  WB_Rd,  WB_Rt,  WB_RegDst,  WB_RegWr,  WB_MemToReg,  WB_ALUOut,  WB_MemOut);
always @(*) begin
    case (WB_MemToReg)
        0: WB_DataBusC <= WB_ALUOut;
        1: WB_DataBusC <= WB_MemOut;
        2: WB_DataBusC <= WB_PC_4;
        default: WB_DataBusC <= 32'b0;
    endcase
end
always @(*) begin
    case (WB_RegDst)
        0: WB_AddrC <= WB_Rd;
        1: WB_AddrC <= WB_Rt;
        2: WB_AddrC <= 5'd31; // $ra
        3: WB_AddrC <= 5'd26; // Xp $26
    endcase
end
endmodule