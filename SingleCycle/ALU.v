module ALU (
    input [31:0] A, B,
    input [5:0] ALUFun,
    input Sign,
    output [31:0] S,
    output Z, V, N // 零，有效，负
);

always @(*) begin
    // right?
    Z <= S == 0;
    N <= Sign && S[31];
    V <= ~(Sign && A[31] == B[31] && A[31] != S[31]);

    case (ALUFun)
        6b'000000: S <= A+B;
        6b'000001: S <= A+~B+1;
        6'b011000: S <= A&B;
        6'b011110: S <= A|B;
        6'b010110: S <= A^B;
        6'b010001: S <= ~(A|B);
        6'b011010: S <= A;

        // TODO：移位运算

        // 似乎可以先做减法再位缩?但感觉不需要
        6'b110011: S <= A==B;
        6'b110001: S <= A!=B;
        6'b110101: S <= A<B;

        // 这几个似乎用伪码即可，似乎不需要实现
        // 如果不实现，ALUFun可以变短
        6'b110011: S <= A<=0;
        6'b111011: S <= A<0;
        6'b111111: S <= A>0;

        // maybe incomplete

      default: S <= 0;
    endcase
end
endmodule