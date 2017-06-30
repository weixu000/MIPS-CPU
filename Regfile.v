module RegFile(
    input reset, clk, wr,
    input [4:0] addr1, addr2, addr3,
    input [31:0] data3,
    output [31:0] data1, data2
);

reg [31:0] RF_DATA[31:1];
integer i;

assign data1 = (addr1==5'b0) ? 32'b0 : RF_DATA[addr1];	//$0 MUST be all zeros
assign data2 = (addr2==5'b0) ? 32'b0 : RF_DATA[addr2];

always @(negedge reset or posedge clk) begin
    if (~reset) begin
        for(i=1; i<32; i=i+1) RF_DATA[i] <= 32'b0;
    end
    else begin
        if(wr && addr3) RF_DATA[addr3] <= data3;
    end
end
endmodule
