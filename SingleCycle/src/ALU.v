module ALU(
    input [31:0] A, B,
    input [5:0] ALUFun,
    output reg [31:0] S
);
always @(*) begin
    case (ALUFun)
        6'b000000: S <= A+B;
        6'b000001: S <= A+~B+1;
        6'b011000: S <= A&B;
        6'b011110: S <= A|B;
        6'b010110: S <= A^B;
        6'b010001: S <= ~(A|B);
        6'b011010: S <= A;

        6'b100000: S <= B<<A[4:0];
        6'b100001: S <= B>>A[4:0];
        6'b100011: S <= {{31{B[31]}}, B}>>A[4:0];

        6'b110011: S <= A==B;
        6'b110001: S <= A!=B;
        6'b110101: S <= A<B;
        6'b111101: S <= A<=B;
        6'b111011: S <= A<B;
        6'b111111: S <= A>B;
      default: S <= 0;
    endcase
end
endmodule