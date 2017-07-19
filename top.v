module top(
    input reset, clk,

    input UART_RX,
    output UART_TX,
    output [7:0] led,
    input [7:0] switch,
    output [11:0] digi
);
CPU cpu(reset, clk, UART_RX, UART_TX, led, switch, digi);
endmodule