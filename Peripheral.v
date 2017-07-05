module Peripheral( 
    input reset, sysclk,
    input rd,wr,
    input [31:0] addr,
    input [31:0] wdata,
    output reg[31:0] rdata,

    input UART_RX,
    output UART_TX,

    output reg [7:0] led,
    input [7:0] switch,
    output reg [11:0] digi,

    output irqout,
    input PC_31
);
wire gclk;
wire [7:0] TX_DATA;
wire [7:0] RX_DATA;
wire TX_STATUS;
wire RX_STATUS;
reg [7:0] UART_TXD;
reg [7:0] UART_RXD;
reg TX_EN;
reg [31:0] TH, TL;
reg [2:0] TCON;
reg [4:0] UART_CON;
assign irqout = (!PC_31)&TCON[2];
assign TX_DATA = UART_TXD;
UART_Receiver x1(RX_STATUS, RX_DATA, sysclk, gclk, UART_RX, reset);
UART_Sender x2(UART_TX, TX_STATUS, TX_EN, TX_DATA, sysclk, gclk, reset);
UART_generator x3(gclk, sysclk, reset);

always @(*) begin
    if (rd) begin
        case(addr)
            32'h40000000: rdata <= TH;
            32'h40000004: rdata <= TL;
            32'h40000008: rdata <= {29'b0,TCON};
            32'h4000000C: rdata <= {24'b0,led};
            32'h40000010: rdata <= {24'b0,switch};
            32'h40000014: rdata <= {20'b0,digi};
            32'h4000001C: rdata <= {24'b0,UART_RXD};
            32'h40000020: rdata <= {27'b0,UART_CON};
            default:      rdata <= 32'b0;
        endcase
    end
    else rdata <= 32'b0;
end

always @(negedge reset or posedge sysclk or posedge RX_STATUS) begin
    if (~reset) begin
        TH <= 32'b0;
        TL <= 32'b0;
        TCON <= 3'b0;
        TX_EN <= 0;
        UART_CON <= 5'b00000;
        UART_RXD <= 8'b00000;
        UART_TXD <= 8'b00000;
    end
    else begin
        if (TCON[0]) begin	//timer is enabled
            if(TL == 32'hffffffff) begin
                TL <= TH;
                if(TCON[1]) TCON[2] <= 1'b1;		//irq is enabled
            end
            else TL <= TL + 1;
        end
        if (RX_STATUS) begin //after receiving 8 bits, update state of RXD and CON
        UART_RXD<=RX_DATA;
        UART_CON[3] <= 1;
        end
        if (TX_STATUS) begin //after sending 8 bits, update state of CON
            UART_CON[2] <= 1;
            UART_CON[4] <= 0;
        end
        if (TX_EN) //"enable" only lasts for one cycle
            TX_EN<=0;
        if (rd) //after loading state of CON,clear
        if(addr == 32'h40000020) begin
           UART_CON[2] <= 1'b0;
           UART_CON[3] <= 1'b0;
        end
        if (wr) begin
            case(addr)
                32'h40000000: TH <= wdata;
                32'h40000004: TL <= wdata;
                32'h40000008: TCON <= wdata[2:0];
                32'h4000000C: led <= wdata[7:0];
                32'h40000014: digi <= wdata[11:0];
                32'h40000018: begin
                    UART_TXD <= wdata[7:0];
                        if (TX_STATUS) begin
                            TX_EN <= 1;
                            UART_CON[4] <= 1;
                        end
                    end
                32'h40000020: UART_CON <= wdata[1:0];
                default: ;
            endcase
        end
    end
end
endmodule

