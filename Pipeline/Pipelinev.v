module CPU(
    input reset, clk,

    input UART_RX,
    output UART_TX,
    output [7:0] led,
    input [7:0] switch,
    output [11:0] digi
);
// IF
reg [31:0] PC;
wire [31:0] IF_PC_4;
wire [31:0] ConBA;
wire [25:0] JT;
wire [31:0] ILLOP;
wire [31:0] XADR;
wire [2:0] PCSrc;
reg [31:0] PC_next;
wire [31:0] IF_Instruct;
assign IF_PC_4 = {PC[31], PC[30:0]+31'd4}; // 监督位不变？？？
assign ILLOP = 32'h80000004;
assign XADR = 32'h80000008;
always @(*) begin
    case (PCSrc)
        0: PC_next <= IF_PC_4;
        1: PC_next <= ALUOut[0] ? ConBA : IF_PC_4;
        2: PC_next <= {IF_PC_4[31:28] ,JT, 2'b0};
        3: PC_next <= DataBusA; // $ra
        4: PC_next <= ILLOP; // interrupt
        5: PC_next <= XADR; // exception
        default: PC_next <= 0;
    endcase
end
always @(negedge reset or posedge clk)
    if (~reset) PC <= 32'h80000000; // kernel mode
    else PC <= PC_next;
ROM rom(PC[30:0], IF_Instruct);

// ID
wire [31:0] ID_PC_4, ID_Instruct;
IF_ID IF_ID_reg(reset, clk, IF_PC_4, IF_Instruct,
                            ID_PC_4, ID_Instruct);
wire [15:0] Imm16;
wire [4:0] Shamt;
wire [4:0] Rd, Rt, Rs;
wire [5:0] opcode, funct;
assign JT = Instruct[25:0],
       Imm16 = Instruct[15:0],
       Shamt = Instruct[10:6],
       Rd = Instruct[15:11],
       Rt = Instruct[20:16],
       Rs = Instruct[25:21],
       opcode = Instruct[31:26],
       funct = Instruct[5:0];

wire IRQ;
wire EXTOp;
wire LUOp;
wire ALUSrc1, ALUSrc2;
wire [1:0] ID_RegDst;
wire ID_RegWr;
wire [5:0] ID_ALUFun;
wire ID_MemWr, ID_MemRd;
wire [1:0] ID_MemToReg;
Control control(opcode, funct, IRQ, PCSrc, ID_RegDst, ID_RegWr, ALUSrc1, ALUSrc2, ID_ALUFun, ID_MemWr, ID_MemRd, ID_MemToReg, EXTOp, LUOp);

wire [31:0] DataBusA, ID_DataBusB;
reg [31:0] WB_DataBusC;
reg [4:0] WB_AddrC;
RegFile regfile(reset, clk, WB_RegWr, Rs, Rt, WB_AddrC, WB_DataBusC, DataBusA, ID_DataBusB);

wire [31:0] LUOut, EXTOut;
wire [31:0] ID_ALUIn1, ID_ALUIn2;
assign EXTOut = EXTOp ? {{16{Imm16[15]}}, Imm16} : {16'b0, Imm16},
       LUOut = LUOp ?  {Imm16, 16'b0} : EXTOut,
       ID_ALUIn1 = ALUSrc1 ? Shamt : DataBusA,
       ID_ALUIn2 = ALUSrc2 ? LUOut : DataBusB,
       ConBA = PC_plus_4+(EXTOut<<2);

// EX
wire [31:0] EX_DataBusB;
wire [31:0] EX_ALUIn1, EX_ALUIn2;
wire [1:0] EX_RegDst;
wire EX_RegWr;
wire [5:0] EX_ALUFun;
wire EX_MemWr, EX_MemRd;
wire [1:0] EX_MemToReg;
ID_EX ID_EX_Reg(reset, clk, ID_DataBusB, ID_ALUIn1, ID_ALUIn2, ID_RegDst, ID_RegWr, ID_ALUFun, ID_MemWr, ID_MemRd, ID_MemToReg,
                            EX_DataBusB, EX_ALUIn1, EX_ALUIn2, EX_RegDst, EX_RegWr, EX_ALUFun, EX_MemWr, EX_MemRd, EX_MemToReg);
wire [31:0] EX_ALUOut;
ALU alu(EX_ALUIn1, EX_ALUIn2, EX_ALUFun, EX_ALUOut);

// MEM
wire [31:0] MEM_ALUOut;
wire [31:0] MEM_DataBusB;
wire [1:0] MEM_RegDst;
wire MEM_RegWr;
wire MEM_MemWr, MEM_MemRd;
wire [1:0] MEM_MemToRe;
EX_MEM EX_MEM_reg(reset, clk, EX_ALUOut,  EX_DataBusB,  EX_RegDst,  EX_RegWr,  EX_MemWr,  EX_MemRd,  EX_MemToReg,
                              MEM_ALUOut, MEM_DataBusB, MEM_RegDst, MEM_RegWr, MEM_MemWr, MEM_MemRd, MEM_MemToReg);

wire [31:0] MemOut1, MemOut2, MEM_MemOut; // 数据存储器 外设
DataMem datamem(reset, clk, MEM_MemRd, MEM_MemWr, MEM_ALUOut, MEM_DataBusB, MemOut1);
Peripheral periph(reset, clk, MEM_MemRd, MEM_MemWr, MEM_ALUOut, MEM_DataBusB, MemOut2, UART_RX, UART_TX, led, switch, digi, IRQ, PC[31]); // PC[31]
assign MEM_MemOut = MEM_ALUOut[30] ? MemOut2 : MemOut1;

// WB
wire [1:0] WB_RegDst;
wire WB_RegWr;
wire [1:0] WB_MemToReg;
module EX_MEM(reset, clk, MEM_RegDst, MEM_RegWr, MEM_MemToReg,
                          WB_RegDst,  WB_RegWr,  WB_MemToReg);
always @(*) begin
    case (WB_MemToReg)
        0: WB_DataBusC <= ALUOut;
        1: WB_DataBusC <= MemOut;
        2: WB_DataBusC <= PC_plus_4;
        default: WB_DataBusC <= 32'b0;
    endcase
end
always @(*) begin
    case (WB_RegDst)
        0: WB_AddrC <= Rd;
        1: WB_AddrC <= Rt;
        2: WB_AddrC <= 5'd31; // $ra
        3: WB_AddrC <= 5'd26; // Xp $26
    endcase
end
endmodule