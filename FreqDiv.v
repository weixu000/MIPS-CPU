module FreqDiv(
    input reset, clk,
    output reg clk_
);
always @(negedge reset or posedge clk)
    if (~reset) 
        clk_ <= 1;
     else
        clk_ <= ~clk_;
  

endmodule