module IF_ID(
    input reset, clk,
    input [1:0] Src,

    input [31:0] IF_PC_4,
    input [31:0] IF_Instruct,
    input IF_NoIRQ,

    output reg [31:0] ID_PC_4,
    output reg [31:0] ID_Instruct,
    output reg ID_NoIRQ
);
always @(negedge reset or posedge clk) begin
    if (~reset) begin
        ID_PC_4 <= 32'b0;
        ID_Instruct <= 32'b0;
        ID_NoIRQ <= 0;
    end else
    case (Src)
        0:begin
            ID_PC_4 <= IF_PC_4;
            ID_Instruct <= IF_Instruct;
            ID_NoIRQ <= IF_NoIRQ;
        end
        1:begin // stall
            ID_PC_4 <= IF_PC_4; // PC_4不stall
            ID_Instruct <= 32'b0;
            ID_NoIRQ <= IF_NoIRQ;
        end
        2:begin // hold
            ID_PC_4 <= ID_PC_4;
            ID_Instruct <= ID_Instruct;
            ID_NoIRQ <= ID_NoIRQ;
        end
        default:begin
            ID_PC_4 <= IF_PC_4;
            ID_Instruct <= IF_Instruct;
            ID_NoIRQ <= IF_NoIRQ;
        end
    endcase
end
endmodule

module ID_EX(
    input reset, clk, Stall,

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
    if (~reset) begin
        EX_PC_4 <= 32'b0;
        EX_Shamt <= 5'b0;
        EX_Rd <= 5'b0;
        EX_Rt <= 5'b0;
        EX_Rs <= 5'b0;
        EX_DataBusA <= 32'b0;
        EX_DataBusB <= 32'b0;
        EX_ALUSrc1 <= 1'b0;
        EX_ALUSrc2 <= 1'b0;
        EX_RegDst <= 2'b0;
        EX_RegWr <= 1'b0;
        EX_ALUFun <= 6'b0;
        EX_MemWr <= 1'b0;
        EX_MemRd <= 1'b0;
        EX_MemToReg <= 2'b0;
        EX_LUOut <= 32'b0;
    end else
    if (Stall) begin
        EX_PC_4 <= ID_PC_4; // PC_4不stall
        EX_Shamt <= 5'b0;
        EX_Rd <= 5'b0;
        EX_Rt <= 5'b0;
        EX_Rs <= 5'b0;
        EX_DataBusA <= 32'b0;
        EX_DataBusB <= 32'b0;
        EX_ALUSrc1 <= 1'b0;
        EX_ALUSrc2 <= 1'b0;
        EX_RegDst <= 2'b0;
        EX_RegWr <= 1'b0;
        EX_ALUFun <= 6'b0;
        EX_MemWr <= 1'b0;
        EX_MemRd <= 1'b0;
        EX_MemToReg <= 2'b0;
        EX_LUOut <= 32'b0;
    end else begin
        EX_PC_4 <= reset ? ID_PC_4 : 32'b0;
        EX_Shamt <= ID_Shamt;
        EX_Rd <= ID_Rd;
        EX_Rt <= ID_Rt;
        EX_Rs <= ID_Rs;
        EX_DataBusA <= ID_DataBusA;
        EX_DataBusB <= ID_DataBusB;
        EX_ALUSrc1 <= ID_ALUSrc1;
        EX_ALUSrc2 <= ID_ALUSrc2;
        EX_RegDst <= ID_RegDst;
        EX_RegWr <= ID_RegWr;
        EX_ALUFun <= ID_ALUFun;
        EX_MemWr <= ID_MemWr;
        EX_MemRd <= ID_MemRd;
        EX_MemToReg <= ID_MemToReg;
        EX_LUOut <= ID_LUOut;
    end
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
    if (~reset) begin
        MEM_PC_4 <= 32'b0;
        MEM_Rd <= 5'b0;
        MEM_Rt <= 5'b0;
        MEM_ALUOut <= 32'b0;
        MEM_DataBusB <= 32'b0;
        MEM_RegDst <= 2'b0;
        MEM_RegWr <= 1'b0;
        MEM_MemWr <= 1'b0;
        MEM_MemRd <= 1'b0;
        MEM_MemToReg <= 2'b0;
    end else begin
        MEM_PC_4 <= EX_PC_4;
        MEM_Rd <= EX_Rd;
        MEM_Rt <= EX_Rt;
        MEM_ALUOut <= EX_ALUOut;
        MEM_DataBusB <= EX_DataBusB;
        MEM_RegDst <= EX_RegDst;
        MEM_RegWr <= EX_RegWr;
        MEM_MemWr <= EX_MemWr;
        MEM_MemRd <= EX_MemRd;
        MEM_MemToReg <= EX_MemToReg;
    end
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
    if (~reset) begin
        WB_PC_4 <= 32'b0;
        WB_Rd <= 2'b0;
        WB_Rt <= 2'b0;
        WB_RegDst <= 2'b0;
        WB_RegWr <= 1'b0;
        WB_MemToReg <= 2'b0;
        WB_ALUOut <= 2'b0;
        WB_MemOut <= 2'b0;
    end else begin
        WB_PC_4 <= MEM_PC_4;
        WB_Rd <= MEM_Rd;
        WB_Rt <= MEM_Rt;
        WB_RegDst <= MEM_RegDst;
        WB_RegWr <= MEM_RegWr;
        WB_MemToReg <= MEM_MemToReg;
        WB_ALUOut <= MEM_ALUOut;
        WB_MemOut <= MEM_MemOut;
    end
end
endmodule