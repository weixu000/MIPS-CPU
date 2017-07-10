module FreqDiv(
    input reset, clk,
    output reg clk_
);
localparam cycle = 100000000;
reg [26:0] cnt;
always @(negedge reset or posedge clk) begin
    if (~reset) begin
        cnt <= 27'b0;
        clk_ <= 1;
    end else
    if (cnt < cycle-1) begin
        cnt <= cnt+1;
        clk_ <= 0;
    end else begin
        cnt <= 0;
        clk_ <= 1;
    end
end
endmodule