module ROM(
    input [30:0] addr,
    output [31:0] data
);

localparam ROM_SIZE = 128;
(* rom_style = "distributed" *) reg [ROM_SIZE:0] ROMDATA[ROM_SIZE-1:0];

assign data = addr[30:2]<ROM_SIZE ? ROMDATA[addr[30:2]] : 32'b0;

integer i;
initial begin
    ROMDATA[0] <= 32'h201d0400;
    ROMDATA[1] <= 32'h20040003;
    ROMDATA[2] <= 32'h0c000004;
    ROMDATA[3] <= 32'h1000ffff;
    ROMDATA[4] <= 32'h23bdfff8;
    ROMDATA[5] <= 32'hafbf0004;
    ROMDATA[6] <= 32'hafa40000;
    ROMDATA[7] <= 32'h28880001;
    ROMDATA[8] <= 32'h11000003;
    ROMDATA[9] <= 32'h00001026;
    ROMDATA[10] <= 32'h23bd0008;
    ROMDATA[11] <= 32'h03e00008;
    ROMDATA[12] <= 32'h2084ffff;
    ROMDATA[13] <= 32'h0c000004;
    ROMDATA[14] <= 32'h8fa40000;
    ROMDATA[15] <= 32'h8fbf0004;
    ROMDATA[16] <= 32'h23bd0008;
    ROMDATA[17] <= 32'h00821020;
    ROMDATA[18] <= 32'h03e00008;
    for (i=19; i<ROM_SIZE; i=i+1) begin
        ROMDATA[i] <= 32'b0;
    end
end
endmodule
