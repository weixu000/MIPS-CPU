module CPU(
    input reset, clk
);
    wire [31:0] PC_plus_4;
    assign PC_plus_4 = PC + 32'd4;
    wire [31:0] ConBA;
    wire [31:0] JT;
    wire [31:0] ILLOP;
    assign ILLOP = 32'h80000004;
    wire [31:0] XADR;
    assign XADR = 32'h80000008;

    wire [31:0] PC_next;
    always @(*) begin
        case (PCSrc)
            0: PC_next <= PC_plus_4;
            1: PC_next <= ALUOut[0] ? ConBA : PC_plus_4;
            2: PC_next <= JT;
            3: PC_next <= DataBusA;
            4: PC_next <= ILLOP;
            5: PC_next <= XADR;
            default: PC_next<=0;
        endcase
    end

    reg [31:0] PC;
    always @(posedge reset or posedge clk)
      if (reset)
          PC <= 32'h00000000;
      else
          PC <= PC_next;

    wire [31:0] Instruct;
    ROM rom(PC, Instruct);
    wire [15:0] Imm16;
    wire [4:0] Shamt;
    wire [4:0] Rd, Rt, Rs;
    assign JT = Instruct[25:0],
           Imm16 = Instruct[15:0],
           Shamt = Instruct[10:6],
           Rd = Instruct[15:11],
           Rt = Instruct[20:16],
           Rs = Instruct[25:21];

    wire [31:0] Instruct;
    wire [2:0] PCSrc;
    wire [1:0] RegDst;
    wire RegWr;
    wire ALUSrc1, ALUSrc2;
    wire [5:0] ALUFun;
    wire Sign;
    wire MemWr, MemRd;
    wire [1:0] MemToReg;
    wire EXTOp;
    wire LUOp;
    Control control([31:0] Instruct, [2:0] PCSrc, [1:0] RegDst, RegWr, ALUSrc1, ALUSrc2, [5:0] ALUFun, Sign, MemWr, MemRd, [1:0] MemToReg, EXTOp, LUOp);

    wire [31:0] DataBusA, DataBusB, DataBusC;
    wire [4:0] AddrC;
    always @(*) begin
        case (RegDst)
            0: AddrC <= rd;
            1: AddrC <= Rt;
            2: AddrC <= 5'd31 // $ra
            3: AddrC <= 5'd26 // Xp $26
        endcase
    end
    RegFile regfile(reset, clk, RegWr, Rs, Rt, AddrC, DataBusC, DataBusA, DataBusB);

    wire [31:0] LUOut , EXTOut;
    assign EXTOut = EXTOp ? {{16{Imm16[15]}},Imm16} : {16'b0, Imm16},
           LUOut = LUOp ?  {Imm16, 16'b0} : EXTOp,
           ConBA = PC_plus_4+EXTOut<<2;

    wire [31:0] ALUIn1, ALUIn2, ALUOut;
    assign ALUIn1 = ALUSrc1 ? Shamt : DataBusA,
           ALUIn2 = ALUSrc2 ? LUOut : DataBusB;
    ALU alu(ALUIn1, ALUIn2, ALUFun, Sign, ALUOut, , , ); // Z,V,N not used

    wire [31:0] MemOut;
    DataMem mem (reset, clk, MemRd, MemWr, ALUOut, DataBusB, MemOut);
    always @(*) begin
        case (MemToReg)
            0: DataBusC <= ALUOut;
            1: DataBusC <= MemOut;
            2: DataBusC <= PC_plus_4;
            default: DataBusC<=32'b0;
        endcase
    end
endmodule