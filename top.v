module top(
    input reset, clk,

    input UART_RX,
    output UART_TX,
    output [7:0] led,
    input [7:0] switch,
    output [11:0] digi
);
wire clk_;
CPU cpu(reset, clk, UART_RX, UART_TX, led, switch, digi);
FreqDiv div(reset, clk, clk_);
endmodule