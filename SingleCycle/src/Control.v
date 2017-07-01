module Control(
    input [31:0] Instruct,
    input IRQ,
    output [2:0] PCSrc,
    output [1:0] RegDst,
    output RegWr,
    output ALUSrc1, ALUSrc2,
    output [5:0] ALUFun,
    output MemWr, MemRd,
    output [1:0] MemToReg,
    output EXTOp,
    output LUOp
);
wire [5:0] opcode, funct;
assign opcode = Instruct[31:26],
       funct = Instruct[5:0];

// 未定义命令
wire Undefined;
assign Undefined = !((opcode==0&&(funct==6'h20||funct==6'h21||funct==6'h22||funct==6'h23||funct==6'h24||funct==6'h25||funct==6'h26||funct==6'h27||funct==6'h00||funct==6'h02||funct==6'h03||funct==6'h2A||funct==6'h2B||funct==6'h08||funct==6'h09))
                    ||opcode==6'h23||opcode==6'h2B||opcode==6'h0F||opcode==6'h08||opcode==6'h09||opcode==6'h0C||opcode==6'h0A||opcode==6'h0B||opcode==6'h04||opcode==6'h05||opcode==6'h06||opcode==6'h07||opcode==6'h01
                    ||opcode==6'h02||opcode==6'h03);

assign PCSrc = IRQ ? 4 :
               Undefined ? 5 :
               (opcode==0&&(funct==6'h08||funct==6'h09)) ? 3 :
               (opcode==6'h04||opcode==6'h05||opcode==6'h06||opcode==6'h07||opcode==6'h01) ? 1 :
               (opcode==6'h02||opcode==6'h03) ? 2 : 0;

assign RegDst = IRQ||Undefined ? 3 :
                opcode==0 ? 0 :
                opcode==6'h03 ? 2 : 1;

assign RegWr = IRQ||Undefined||(opcode==0&&funct==6'h08)||opcode==6'h2B||opcode==6'h04||opcode==6'h05||opcode==6'h06||opcode==6'h07||opcode==6'h01||opcode==6'h02 ? 0 : 1;

assign ALUSrc1 = opcode==0&&(funct==6'h00||funct==6'h02||funct==6'h03);
assign ALUSrc2 = opcode==6'h23||opcode==6'h2B||opcode==6'h0F||opcode==6'h08||opcode==6'h09||opcode==6'h0C||opcode==6'h0A||opcode==6'h0B;

assign ALUFun = (opcode==0&&(funct==6'h20||funct==6'h21))||opcode==6'h23||opcode==6'h2B||opcode==6'h0F||opcode==6'h08||opcode==6'h09 ? 6'b000_000 :
                opcode==0&&(funct==6'h22||funct==6'h23) ? 6'b000_001 :
                (opcode==0&&funct==6'h24)||opcode==6'h0C ? 6'b011_000 :
                opcode==0&&funct==6'h25 ? 6'b011_110 :
                opcode==0&&funct==6'h26 ? 6'b010_110 :
                opcode==0&&funct==6'h27 ? 6'b010_001 :
                opcode==0&&funct==6'h00 ? 6'b100_000 :
                opcode==0&&funct==6'h02 ? 6'b100_001 :
                opcode==0&&funct==6'h03 ? 6'b100_011 :
                (opcode==0&&(funct==6'h2A||funct==6'h2B))||opcode==6'h0A||opcode==6'h0B ? 6'b110_101 :
                opcode==6'h04 ? 6'b110_011 :
                opcode==6'h05 ? 6'b110_001 :
                opcode==6'h06 ? 6'b111_101 :
                opcode==6'h07 ? 6'b111_111 :
                opcode==6'h01 ? 6'b111_011 : 6'b000_000;

assign MemWr = !IRQ && opcode==6'h2B;
assign MemRd = opcode==6'h23;

assign MemToReg = opcode==6'h23 ? 1 :
                  IRQ||Undefined||(opcode==0&&funct==6'h09)||opcode==6'h03 ? 2 : 0;

assign EXTOp = opcode!=6'h0C;
assign LUOp = opcode==6'h0F;
endmodule