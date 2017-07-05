module ROM(
    input [30:0] addr,
    output [31:0] data
);

localparam ROM_SIZE = 32;
(* rom_style = "distributed" *) reg [ROM_SIZE:0] ROMDATA[ROM_SIZE-1:0];

assign data = addr[30:2]<ROM_SIZE ? ROMDATA[addr[30:2]] : 32'b0;

integer i;
initial begin
    ROMDATA[0] <= 32'h08000002;
    ROMDATA[1] <= 32'h0800001f;
    ROMDATA[2] <= 32'h3c084000;
    ROMDATA[3] <= 32'h2109000c;
    ROMDATA[4] <= 32'h210a001a;
    ROMDATA[5] <= 32'h210b0018;
    ROMDATA[6] <= 32'h210c001c;
    ROMDATA[7] <= 32'h200d0000;
    ROMDATA[8] <= 32'h3c0effff;
    ROMDATA[9] <= 32'h21ce3caf;
    ROMDATA[10] <= 32'had0e0000;
    ROMDATA[11] <= 32'h3c0effff;
    ROMDATA[12] <= 32'h21ceffff;
    ROMDATA[13] <= 32'had0e0004;
    ROMDATA[14] <= 32'h200e0003;
    ROMDATA[15] <= 32'had0e0008;
    ROMDATA[16] <= 32'h201f0050;
    ROMDATA[17] <= 32'h03e00008;
    ROMDATA[18] <= 32'had0e0008;
    ROMDATA[19] <= 32'h8d0e0020;
    ROMDATA[20] <= 32'h000e70c2;
    ROMDATA[21] <= 32'h08000012;
    ROMDATA[22] <= 32'h200d0000;
    ROMDATA[23] <= 32'h8d910000;
    ROMDATA[24] <= 32'h0800007f;
    ROMDATA[25] <= 32'h8d900000;
    ROMDATA[26] <= 32'h21ad0001;
    ROMDATA[27] <= 32'h08000012;
    ROMDATA[28] <= 32'h200e0000;
    ROMDATA[29] <= 32'had0e0008;
    ROMDATA[30] <= 32'h00109700;
    ROMDATA[31] <= 32'h00129702;
    ROMDATA[32] <= 32'h0c00004e;
    ROMDATA[33] <= 32'h22520e00;
    ROMDATA[34] <= 32'had520000;
    ROMDATA[35] <= 32'h21ad0001;
    ROMDATA[36] <= 32'h200e0003;
    ROMDATA[37] <= 32'had0e0008;
    ROMDATA[38] <= 32'h235afffc;
    ROMDATA[39] <= 32'h03400008;
    ROMDATA[40] <= 32'h00109102;
    ROMDATA[41] <= 32'h0c00004e;
    ROMDATA[42] <= 32'h22520d00;
    ROMDATA[43] <= 32'had520000;
    ROMDATA[44] <= 32'h21ad0001;
    ROMDATA[45] <= 32'h200e0003;
    ROMDATA[46] <= 32'had0e0008;
    ROMDATA[47] <= 32'h235afffc;
    ROMDATA[48] <= 32'h03400008;
    ROMDATA[49] <= 32'h00119700;
    ROMDATA[50] <= 32'h00129702;
    ROMDATA[51] <= 32'h0c00004e;
    ROMDATA[52] <= 32'h22520b00;
    ROMDATA[53] <= 32'had520000;
    ROMDATA[54] <= 32'h21ad0001;
    ROMDATA[55] <= 32'h200e0003;
    ROMDATA[56] <= 32'had0e0008;
    ROMDATA[57] <= 32'h235afffc;
    ROMDATA[58] <= 32'h03400008;
    ROMDATA[59] <= 32'h00119102;
    ROMDATA[60] <= 32'h0c00004e;
    ROMDATA[61] <= 32'h22520700;
    ROMDATA[62] <= 32'had520000;
    ROMDATA[63] <= 32'h200d0000;
    ROMDATA[64] <= 32'h200e0003;
    ROMDATA[65] <= 32'had0e0008;
    ROMDATA[66] <= 32'h235afffc;
    ROMDATA[67] <= 32'h03400008;
    ROMDATA[68] <= 32'h200f0002;
    ROMDATA[69] <= 32'h200f009e;
    ROMDATA[70] <= 32'h200f0024;
    ROMDATA[71] <= 32'h200f000c;
    ROMDATA[72] <= 32'h200f0098;
    ROMDATA[73] <= 32'h200f0048;
    ROMDATA[74] <= 32'h200f0040;
    ROMDATA[75] <= 32'h200f001e;
    ROMDATA[76] <= 32'h200f0000;
    ROMDATA[77] <= 32'h200f0004;
    ROMDATA[78] <= 32'h200f0008;
    ROMDATA[79] <= 32'h200f00c0;
    ROMDATA[80] <= 32'h200f0062;
    ROMDATA[81] <= 32'h200f0084;
    ROMDATA[82] <= 32'h200f0062;
    ROMDATA[83] <= 32'h200f0072;
    ROMDATA[84] <= 32'h000f9020;
    ROMDATA[85] <= 32'h03e00008;
    ROMDATA[86] <= 32'h12110009;
    ROMDATA[87] <= 32'h02307822;
    ROMDATA[88] <= 32'h120f0008;
    ROMDATA[89] <= 32'h21f10000;
    ROMDATA[90] <= 32'h08000080;
    ROMDATA[91] <= 32'h02117822;
    ROMDATA[92] <= 32'h122f0004;
    ROMDATA[93] <= 32'h21f00000;
    ROMDATA[94] <= 32'h08000080;
    ROMDATA[95] <= 32'h22040000;
    ROMDATA[96] <= 32'h208f0000;
    ROMDATA[97] <= 32'h21e40000;
    ROMDATA[98] <= 32'had240000;
    ROMDATA[99] <= 32'had640000;
    ROMDATA[100] <= 32'h1000ffff;
    for (i=101; i<ROM_SIZE; i=i+1) begin
        ROMDATA[i] <= 32'b0;
    end
end
endmodule
