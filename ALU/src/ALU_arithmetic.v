module ALU_arithmetic(Z, V, N, S, A, B, Sign, ALUFun);
output Z, V, N;
output [31:0] S;
input [31:0] A, B;
input ALUFun, Sign;
wire [31:0] Bnew;
wire [32:0] S_ext;
wire V_Sign, V_Unsign;
assign Bnew = (ALUFun) ? ~B+1: B;
assign S_ext = A+Bnew;
assign S = S_ext[31:0];
assign V_Sign = (A[31]==Bnew[31]) ? S_ext[32]^S_ext[31] : 0;
assign V_Unsign = (ALUFun) ? ((A<B) ? 1 : 0) : S_ext[32];
assign V = Sign ? V_Sign : V_Unsign;
assign Z = S==0;
assign N = V^S[31];
endmodule
