module CPU(
    input reset, clk,

    input UART_RX,
    output UART_TX,
    output [7:0] led,
    input [7:0] switch,
    output [11:0] digi
);
reg [31:0] PC;
wire [31:0] PC_plus_4;
wire [31:0] ConBA;
wire [31:0] JT;
wire [31:0] ILLOP;
wire [31:0] XADR;
wire [2:0] PCSrc;
reg [31:0] PC_next;

wire [31:0] Instruct;
wire [15:0] Imm16;
wire [4:0] Shamt;
wire [4:0] Rd, Rt, Rs;

wire IRQ;
wire [1:0] RegDst;
wire RegWr;
wire ALUSrc1, ALUSrc2;
wire [5:0] ALUFun;
wire MemWr, MemRd;
wire [1:0] MemToReg;
wire EXTOp;
wire LUOp;

wire [31:0] DataBusA, DataBusB;
reg [31:0] DataBusC;
reg [4:0] AddrC;

wire [31:0] LUOut, EXTOut;

wire [31:0] ALUIn1, ALUIn2, ALUOut;

wire [31:0] MemOut1, MemOut2, MemOut; // 数据存储器 外设

assign PC_plus_4 = {PC[31], PC[30:0]+31'd4}; // 监督位不变？？？
assign ILLOP = 32'h80000004;
assign XADR = 32'h80000008;
always @(*) begin
    case (PCSrc)
        0: PC_next <= PC_plus_4;
        1: PC_next <= ALUOut[0] ? ConBA : PC_plus_4;
        2: PC_next <= {PC_plus_4[31:28] ,JT, 2'b0};
        3: PC_next <= DataBusA; // $ra
        4: PC_next <= ILLOP; // interrupt
        5: PC_next <= XADR; // exception
        default: PC_next <= 0;
    endcase
end

always @(negedge reset or posedge clk)
    if (~reset) PC <= 32'h80000000; // kernel mode
    else PC <= PC_next;

ROM rom(PC[30:0], Instruct);
assign JT = Instruct[25:0],
       Imm16 = Instruct[15:0],
       Shamt = Instruct[10:6],
       Rd = Instruct[15:11],
       Rt = Instruct[20:16],
       Rs = Instruct[25:21];

Control control(Instruct, IRQ, PCSrc, RegDst, RegWr, ALUSrc1, ALUSrc2, ALUFun, MemWr, MemRd, MemToReg, EXTOp, LUOp);

always @(*) begin
    case (RegDst)
        0: AddrC <= Rd;
        1: AddrC <= Rt;
        2: AddrC <= 5'd31; // $ra
        3: AddrC <= 5'd26; // Xp $26
    endcase
end
RegFile regfile(reset, clk, RegWr, Rs, Rt, AddrC, DataBusC, DataBusA, DataBusB);

assign EXTOut = EXTOp ? {{16{Imm16[15]}}, Imm16} : {16'b0, Imm16},
       LUOut = LUOp ?  {Imm16, 16'b0} : EXTOut,
       ConBA = PC_plus_4+(EXTOut<<2);

assign ALUIn1 = ALUSrc1 ? Shamt : DataBusA,
       ALUIn2 = ALUSrc2 ? LUOut : DataBusB;
ALU alu(ALUIn1, ALUIn2, ALUFun, ALUOut);

DataMem datamem(reset, clk, MemRd, MemWr, ALUOut, DataBusB, MemOut1);
Peripheral periph(reset, sysclk, MemRd, MemWr, ALUOut, DataBusC, MemOut2, UART_RX, UART_TX, led, switch, digi, IRQ, PC[31]);
assign MemOut = ALUOut[30] ? MemOut2 : MemOut1; // 外设映射地址第30位是1
always @(*) begin
    case (MemToReg)
        0: DataBusC <= ALUOut;
        1: DataBusC <= MemOut;
        2: DataBusC <= PC_plus_4;
        default: DataBusC <= 32'b0;
    endcase
end
endmodule