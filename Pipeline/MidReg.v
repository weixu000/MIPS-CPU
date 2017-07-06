module IF_ID(
    input reset, clk,

    input [31:0] IF_PC_4,
    input [31:0] IF_Instruct,

    output reg [31:0] ID_PC_4,
    output reg [31:0] ID_Instruct
);
always @(negedge reset or posedge clk) begin
    ID_PC_4 <= reset ? IF_PC_4 : 32'b0;
    ID_Instruct <= reset ? IF_Instruct : 32'b0;
end
endmodule

module ID_EX(
    input reset, clk,

    input [31:0] ID_DataBusB,
    input [31:0] ID_ALUIn1, ID_ALUIn2,
    input [1:0] ID_RegDst,
    input ID_RegWr,
    input [5:0] ID_ALUFun,
    input ID_MemWr, ID_MemRd,
    input [1:0] ID_MemToReg,

    output reg [31:0] EX_DataBusB,
    output reg [31:0] EX_ALUIn1, EX_ALUIn2,
    output reg [1:0] EX_RegDst,
    output reg EX_RegWr,
    output reg [5:0] EX_ALUFun,
    output reg EX_MemWr, EX_MemRd,
    output reg [1:0] EX_MemToReg
);
always @(negedge reset or posedge clk) begin
    EX_DataBusB <= reset ? ID_DataBusB : 32'b0;
    EX_ALUIn1 <= reset ? ID_ALUIn1 : 32'b0;
    EX_ALUIn2 <= reset ? ID_ALUIn2 : 32'b0;
    EX_RegDst <= reset ? ID_RegDst : 2'b0;
    EX_RegWr <= reset ? ID_RegWr : 1'b0;
    EX_ALUFun <= reset ? ID_ALUFun : 6'b0;
    EX_MemWr <= reset ? ID_MemWr : 1'b0;
    EX_MemRd <= reset ? ID_MemRd : 1'b0;
    EX_MemToReg <= reset ? ID_MemToReg : 2'b0;
end
endmodule

module EX_MEM(
    input reset, clk,

    input [31:0] EX_ALUOut,
    input [31:0] EX_DataBusB,
    input [1:0] EX_RegDst,
    input EX_RegWr,
    input EX_MemWr, EX_MemRd,
    input [1:0] EX_MemToReg,

    output reg [31:0] MEM_ALUOut,
    output reg [31:0] MEM_DataBusB,
    output reg [1:0] MEM_RegDst,
    output reg MEM_RegWr,
    output reg MEM_MemWr, MEM_MemRd,
    output reg [1:0] MEM_MemToReg
);
always @(negedge reset or posedge clk) begin
    MEM_ALUOut <= reset ? EX_ALUOut : 32'b0;
    MEM_DataBusB <= reset ? EX_DataBusB : 32'b0;
    MEM_RegDst <= reset ? EX_RegDst : 2'b0;
    MEM_RegWr <= reset ? EX_RegWr : 1'b0;
    MEM_MemWr <= reset ? EX_MemWr : 1'b0;
    MEM_MemRd <= reset ? EX_MemRd : 1'b0;
    MEM_MemToReg <= reset ? EX_MemToReg : 2'b0;
end
endmodule

module EX_MEM(
    input reset, clk,

    input [1:0] MEM_RegDst,
    input MEM_RegWr,
    input [1:0] MEM_MemToReg,

    output reg [1:0] WB_RegDst,
    output reg WB_RegWr,
    output reg [1:0] WB_MemToReg,
);
always @(negedge reset or posedge clk) begin
    WB_RegDst <= reset ? MEM_RegDst : 2'b0;
    WB_RegWr <= reset ? MEM_RegWr : 1'b0;
    WB_MemToReg <= reset ? MEM_MemToReg : 2'b0;
end
endmodule