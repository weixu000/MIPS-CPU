//不支持j、beq，貌似IF_ID的两个output
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

//ALUSrc应该不止1位，看forwarding再改
module ID_EX(
    input reset, clk,

    input [31:0] ID_PC_4,
    input [4:0] ID_Shamt,
    input [4:0] ID_Rd, ID_Rt, ID_Rs,
    input [31:0] ID_DataBusA, ID_DataBusB,
    input ID_ALUSrc1, ID_ALUSrc2,
    input [1:0] ID_RegDst,
    input ID_RegWr,
    input [5:0] ID_ALUFun,
    input ID_MemWr, ID_MemRd,
    input [1:0] ID_MemToReg,
    input [31:0] ID_LUOut,

    output reg [31:0] EX_PC_4,
    output reg [4:0] EX_Shamt,
    output reg [4:0] EX_Rd, EX_Rt, EX_Rs,
    output reg [31:0] EX_DataBusA, EX_DataBusB,
    output reg EX_ALUSrc1, EX_ALUSrc2,
    output reg [1:0] EX_RegDst,
    output reg EX_RegWr,
    output reg [5:0] EX_ALUFun,
    output reg EX_MemWr, EX_MemRd,
    output reg [1:0] EX_MemToReg,
    output reg [31:0] EX_LUOut
);
always @(negedge reset or posedge clk) begin
    EX_PC_4 <= reset ? ID_PC_4 : 32'b0;
    EX_Shamt <= reset ? ID_Shamt : 5'b0;
    EX_Rd <= reset ? ID_Rd : 5'b0;
    EX_Rt <= reset ? ID_Rt : 5'b0;
    EX_Rs <= reset ? ID_Rs : 5'b0;
    EX_DataBusA <= reset ? ID_DataBusA : 32'b0;
    EX_DataBusB <= reset ? ID_DataBusB : 32'b0;
    EX_ALUSrc1 <= reset ? ID_ALUSrc1 : 1'b0;
    EX_ALUSrc2 <= reset ? ID_ALUSrc2 : 1'b0;
    EX_RegDst <= reset ? ID_RegDst : 2'b0;
    EX_RegWr <= reset ? ID_RegWr : 1'b0;
    EX_ALUFun <= reset ? ID_ALUFun : 6'b0;
    EX_MemWr <= reset ? ID_MemWr : 1'b0;
    EX_MemRd <= reset ? ID_MemRd : 1'b0;
    EX_MemToReg <= reset ? ID_MemToReg : 2'b0;
    EX_LUOut <= reset ? ID_LUOut : 32'b0;
end
endmodule

module EX_MEM(
    input reset, clk,

    input [31:0] EX_PC_4,
    input [4:0] EX_Rd, EX_Rt,
    input [31:0] EX_ALUOut,
    input [31:0] EX_DataBusB,
    input [1:0] EX_RegDst,
    input EX_RegWr,
    input EX_MemWr, EX_MemRd,
    input [1:0] EX_MemToReg,

    output reg [31:0] MEM_PC_4,
    output reg [4:0] MEM_Rd, MEM_Rt,
    output reg [31:0] MEM_ALUOut,
    output reg [31:0] MEM_DataBusB,
    output reg [1:0] MEM_RegDst,
    output reg MEM_RegWr,
    output reg MEM_MemWr, MEM_MemRd,
    output reg [1:0] MEM_MemToReg
);
always @(negedge reset or posedge clk) begin
    MEM_PC_4 <= reset ? EX_PC_4 : 32'b0;
    MEM_Rd <= reset ? EX_Rd : 5'b0;
    MEM_Rt <= reset ? EX_Rt : 5'b0;
    MEM_ALUOut <= reset ? EX_ALUOut : 32'b0;
    MEM_DataBusB <= reset ? EX_DataBusB : 32'b0;
    MEM_RegDst <= reset ? EX_RegDst : 2'b0;
    MEM_RegWr <= reset ? EX_RegWr : 1'b0;
    MEM_MemWr <= reset ? EX_MemWr : 1'b0;
    MEM_MemRd <= reset ? EX_MemRd : 1'b0;
    MEM_MemToReg <= reset ? EX_MemToReg : 2'b0;
end
endmodule

module MEM_WB(
    input reset, clk,

    input [31:0] MEM_PC_4,
    input [4:0] MEM_Rd, MEM_Rt,
    input [1:0] MEM_RegDst,
    input MEM_RegWr,
    input [1:0] MEM_MemToReg,
    input [31:0] MEM_ALUOut, MEM_MemOut,

    output reg [31:0] WB_PC_4,
    output reg [4:0] WB_Rd, WB_Rt,
    output reg [1:0] WB_RegDst,
    output reg WB_RegWr,
    output reg [1:0] WB_MemToReg,
    output reg [31:0] WB_ALUOut, WB_MemOut
);
always @(negedge reset or posedge clk) begin
    WB_PC_4 <= reset ? MEM_PC_4 : 32'b0;
    WB_Rd <= reset ? MEM_Rd : 2'b0;
    WB_Rt <= reset ? MEM_Rt : 2'b0;
    WB_RegDst <= reset ? MEM_RegDst : 2'b0;
    WB_RegWr <= reset ? MEM_RegWr : 1'b0;
    WB_MemToReg <= reset ? MEM_MemToReg : 2'b0;
    WB_ALUOut <= reset ? MEM_ALUOut : 2'b0;
    WB_MemOut <= reset ? MEM_MemOut : 2'b0;
end
endmodule