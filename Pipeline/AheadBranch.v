module AheadBranch(
    input [31:0] ID_DataBusA, ID_DataBusB,
    input [5:0] ID_ALUFun,

    output reg Branch
);
// ALU比较部分放在这里
always @(*) begin
    case (ID_ALUFun)
        6'b110011: Branch <= ID_DataBusA==ID_DataBusB;
        6'b110001: Branch <= ID_DataBusA!=ID_DataBusB;
        6'b110101: Branch <= ID_DataBusA<ID_DataBusB;
        6'b111101: Branch <= ID_DataBusA<=ID_DataBusB;
        6'b111011: Branch <= ID_DataBusA<ID_DataBusB;
        6'b111111: Branch <= ID_DataBusA>ID_DataBusB;
      default: Branch <= 0;
    endcase
end
endmodule