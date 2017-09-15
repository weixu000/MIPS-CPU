module ROM(
    input [30:0] addr,
    output [31:0] data
);

localparam ROM_SIZE = 256;
(* rom_style = "distributed" *) reg [31:0] ROMDATA[ROM_SIZE-1:0];

assign data = addr[30:2]<ROM_SIZE ? ROMDATA[addr[30:2]] : 32'b0;

integer i;
initial begin
    ROMDATA[31'h00000000] <= 32'h08000002; //                     j Initialization
    ROMDATA[31'h00000001] <= 32'h0800001f; //                     j Interrupt
    ROMDATA[31'h00000002] <= 32'h3c084000; // Initialization:     lui $t0, 16384
    ROMDATA[31'h00000003] <= 32'h2109000c; //                     addi $t1, $t0, 12
    ROMDATA[31'h00000004] <= 32'h210a0014; //                     addi $t2, $t0, 20
    ROMDATA[31'h00000005] <= 32'h210c001c; //                     addi $t4, $t0, 28
    ROMDATA[31'h00000006] <= 32'h200d0000; //                     addi $t5, $zero, 0
    ROMDATA[31'h00000007] <= 32'h20190000; //                     addi $t9, $zero, 0
    ROMDATA[31'h00000008] <= 32'h3c0effff; //                     lui $t6, 65535
    ROMDATA[31'h00000009] <= 32'h35ce3caf; //                     ori $t6, $t6, 15535
    ROMDATA[31'h0000000a] <= 32'had0e0000; //                     sw $t6, 0($t0)
    ROMDATA[31'h0000000b] <= 32'h3c0effff; //                     lui $t6, 65535
    ROMDATA[31'h0000000c] <= 32'h35ceffff; //                     ori $t6, $t6, 65535
    ROMDATA[31'h0000000d] <= 32'had0e0004; //                     sw $t6, 4($t0)
    ROMDATA[31'h0000000e] <= 32'h200e0003; //                     addi $t6, $zero, 3
    ROMDATA[31'h0000000f] <= 32'had0e0008; //                     sw $t6, 8($t0)
    ROMDATA[31'h00000010] <= 32'h201f004c; //                     addi $ra, $zero, 76
    ROMDATA[31'h00000011] <= 32'had0e0008; //                     sw $t6, 8($t0)
    ROMDATA[31'h00000012] <= 32'h03e00008; //                     jr $ra
    ROMDATA[31'h00000013] <= 32'h8d0e0020; // Read:               lw $t6, 32($t0)
    ROMDATA[31'h00000014] <= 32'h000e70c2; //                     srl $t6, $t6, 3
    ROMDATA[31'h00000015] <= 32'h21ceffff; //                     addi $t6, $t6, -1
    ROMDATA[31'h00000016] <= 32'h00000000; //                     nop
    ROMDATA[31'h00000017] <= 32'h11c00001; //                     beqz $t6, Load2
    ROMDATA[31'h00000018] <= 32'h08000013; //                     j Read
    ROMDATA[31'h00000019] <= 32'h13200002; // Load2:              beqz $t9, Load1
    ROMDATA[31'h0000001a] <= 32'h8d910000; //                     lw $s1, 0($t4)
    ROMDATA[31'h0000001b] <= 32'h08000095; //                     j Main
    ROMDATA[31'h0000001c] <= 32'h8d900000; // Load1:              lw $s0, 0($t4)
    ROMDATA[31'h0000001d] <= 32'h23390001; //                     addi $t9, $t9, 1
    ROMDATA[31'h0000001e] <= 32'h08000013; //                     j Read
    ROMDATA[31'h0000001f] <= 32'h200e0000; // Interrupt:          addi $t6, $zero, 0
    ROMDATA[31'h00000020] <= 32'had0e0008; //                     sw $t6, 8($t0)
    ROMDATA[31'h00000021] <= 32'h11a00009; //                     beqz $t5, Num1
    ROMDATA[31'h00000022] <= 32'h21aeffff; //                     addi $t6, $t5, -1
    ROMDATA[31'h00000023] <= 32'h00000000; //                     nop
    ROMDATA[31'h00000024] <= 32'h11c00011; //                     beqz $t6, Num2
    ROMDATA[31'h00000025] <= 32'h21aefffe; //                     addi $t6, $t5, -2
    ROMDATA[31'h00000026] <= 32'h00000000; //                     nop
    ROMDATA[31'h00000027] <= 32'h11c00018; //                     beqz $t6, Num3
    ROMDATA[31'h00000028] <= 32'h21aefffd; //                     addi $t6, $t5, -3
    ROMDATA[31'h00000029] <= 32'h00000000; //                     nop
    ROMDATA[31'h0000002a] <= 32'h11c00020; //                     beqz $t6, Num4
    ROMDATA[31'h0000002b] <= 32'h00109700; // Num1:               sll $s2, $s0, 28
    ROMDATA[31'h0000002c] <= 32'h00129702; //                     srl $s2, $s2, 28
    ROMDATA[31'h0000002d] <= 32'h0c000055; //                     jal Translate1
    ROMDATA[31'h0000002e] <= 32'h22520e00; //                     addi $s2, $s2, 3584
    ROMDATA[31'h0000002f] <= 32'had520000; //                     sw $s2, 0($t2)
    ROMDATA[31'h00000030] <= 32'h21ad0001; //                     addi $t5, $t5, 1
    ROMDATA[31'h00000031] <= 32'h200e0003; //                     addi $t6, $zero, 3
    ROMDATA[31'h00000032] <= 32'had0e0008; //                     sw $t6, 8($t0)
    ROMDATA[31'h00000033] <= 32'h235afffc; //                     addi $26, $26, -4
    ROMDATA[31'h00000034] <= 32'h00000000; //                     nop
    ROMDATA[31'h00000035] <= 32'h03400008; //                     jr $26
    ROMDATA[31'h00000036] <= 32'h00109102; // Num2:               srl $s2, $s0, 4
    ROMDATA[31'h00000037] <= 32'h0c000055; //                     jal Translate1
    ROMDATA[31'h00000038] <= 32'h22520d00; //                     addi $s2, $s2, 3328
    ROMDATA[31'h00000039] <= 32'had520000; //                     sw $s2, 0($t2)
    ROMDATA[31'h0000003a] <= 32'h21ad0001; //                     addi $t5, $t5, 1
    ROMDATA[31'h0000003b] <= 32'h200e0003; //                     addi $t6, $zero, 3
    ROMDATA[31'h0000003c] <= 32'had0e0008; //                     sw $t6, 8($t0)
    ROMDATA[31'h0000003d] <= 32'h235afffc; //                     addi $26, $26, -4
    ROMDATA[31'h0000003e] <= 32'h00000000; //                     nop
    ROMDATA[31'h0000003f] <= 32'h03400008; //                     jr $26
    ROMDATA[31'h00000040] <= 32'h00119700; // Num3:               sll $s2, $s1, 28
    ROMDATA[31'h00000041] <= 32'h00129702; //                     srl $s2, $s2, 28
    ROMDATA[31'h00000042] <= 32'h0c000055; //                     jal Translate1
    ROMDATA[31'h00000043] <= 32'h22520b00; //                     addi $s2, $s2, 2816
    ROMDATA[31'h00000044] <= 32'had520000; //                     sw $s2, 0($t2)
    ROMDATA[31'h00000045] <= 32'h21ad0001; //                     addi $t5, $t5, 1
    ROMDATA[31'h00000046] <= 32'h200e0003; //                     addi $t6, $zero, 3
    ROMDATA[31'h00000047] <= 32'had0e0008; //                     sw $t6, 8($t0)
    ROMDATA[31'h00000048] <= 32'h235afffc; //                     addi $26, $26, -4
    ROMDATA[31'h00000049] <= 32'h00000000; //                     nop
    ROMDATA[31'h0000004a] <= 32'h03400008; //                     jr $26
    ROMDATA[31'h0000004b] <= 32'h00119102; // Num4:               srl $s2, $s1, 4
    ROMDATA[31'h0000004c] <= 32'h0c000055; //                     jal Translate1
    ROMDATA[31'h0000004d] <= 32'h22520700; //                     addi $s2, $s2, 1792
    ROMDATA[31'h0000004e] <= 32'had520000; //                     sw $s2, 0($t2)
    ROMDATA[31'h0000004f] <= 32'h200d0000; //                     addi $t5, $zero, 0
    ROMDATA[31'h00000050] <= 32'h200e0003; //                     addi $t6, $zero, 3
    ROMDATA[31'h00000051] <= 32'had0e0008; //                     sw $t6, 8($t0)
    ROMDATA[31'h00000052] <= 32'h235afffc; //                     addi $26, $26, -4
    ROMDATA[31'h00000053] <= 32'h00000000; //                     nop
    ROMDATA[31'h00000054] <= 32'h03400008; //                     jr $26
    ROMDATA[31'h00000055] <= 32'h200f0003; // Translate1:         addi $t7, $zero, 3
    ROMDATA[31'h00000056] <= 32'h1240003c; //                     beqz $s2, Translate2
    ROMDATA[31'h00000057] <= 32'h200f009f; //                     addi $t7, $zero, 159
    ROMDATA[31'h00000058] <= 32'h2258ffff; //                     addi $t8, $s2, -1
    ROMDATA[31'h00000059] <= 32'h00000000; //                     nop
    ROMDATA[31'h0000005a] <= 32'h13000038; //                     beqz $t8, Translate2
    ROMDATA[31'h0000005b] <= 32'h200f0025; //                     addi $t7, $zero, 37
    ROMDATA[31'h0000005c] <= 32'h2258fffe; //                     addi $t8, $s2, -2
    ROMDATA[31'h0000005d] <= 32'h00000000; //                     nop
    ROMDATA[31'h0000005e] <= 32'h13000034; //                     beqz $t8, Translate2
    ROMDATA[31'h0000005f] <= 32'h200f000d; //                     addi $t7, $zero, 13
    ROMDATA[31'h00000060] <= 32'h2258fffd; //                     addi $t8, $s2, -3
    ROMDATA[31'h00000061] <= 32'h00000000; //                     nop
    ROMDATA[31'h00000062] <= 32'h13000030; //                     beqz $t8, Translate2
    ROMDATA[31'h00000063] <= 32'h200f0099; //                     addi $t7, $zero, 153
    ROMDATA[31'h00000064] <= 32'h2258fffc; //                     addi $t8, $s2, -4
    ROMDATA[31'h00000065] <= 32'h00000000; //                     nop
    ROMDATA[31'h00000066] <= 32'h1300002c; //                     beqz $t8, Translate2
    ROMDATA[31'h00000067] <= 32'h200f0049; //                     addi $t7, $zero, 73
    ROMDATA[31'h00000068] <= 32'h2258fffb; //                     addi $t8, $s2, -5
    ROMDATA[31'h00000069] <= 32'h00000000; //                     nop
    ROMDATA[31'h0000006a] <= 32'h13000028; //                     beqz $t8, Translate2
    ROMDATA[31'h0000006b] <= 32'h200f0041; //                     addi $t7, $zero, 65
    ROMDATA[31'h0000006c] <= 32'h2258fffa; //                     addi $t8, $s2, -6
    ROMDATA[31'h0000006d] <= 32'h00000000; //                     nop
    ROMDATA[31'h0000006e] <= 32'h13000024; //                     beqz $t8, Translate2
    ROMDATA[31'h0000006f] <= 32'h200f001f; //                     addi $t7, $zero, 31
    ROMDATA[31'h00000070] <= 32'h2258fff9; //                     addi $t8, $s2, -7
    ROMDATA[31'h00000071] <= 32'h00000000; //                     nop
    ROMDATA[31'h00000072] <= 32'h13000020; //                     beqz $t8, Translate2
    ROMDATA[31'h00000073] <= 32'h200f0001; //                     addi $t7, $zero, 1
    ROMDATA[31'h00000074] <= 32'h2258fff8; //                     addi $t8, $s2, -8
    ROMDATA[31'h00000075] <= 32'h00000000; //                     nop
    ROMDATA[31'h00000076] <= 32'h1300001c; //                     beqz $t8, Translate2
    ROMDATA[31'h00000077] <= 32'h200f0009; //                     addi $t7, $zero, 9
    ROMDATA[31'h00000078] <= 32'h2258fff7; //                     addi $t8, $s2, -9
    ROMDATA[31'h00000079] <= 32'h00000000; //                     nop
    ROMDATA[31'h0000007a] <= 32'h13000018; //                     beqz $t8, Translate2
    ROMDATA[31'h0000007b] <= 32'h200f0011; //                     addi $t7, $zero, 17
    ROMDATA[31'h0000007c] <= 32'h2258fff6; //                     addi $t8, $s2, -10
    ROMDATA[31'h0000007d] <= 32'h00000000; //                     nop
    ROMDATA[31'h0000007e] <= 32'h13000014; //                     beqz $t8, Translate2
    ROMDATA[31'h0000007f] <= 32'h200f00c1; //                     addi $t7, $zero, 193
    ROMDATA[31'h00000080] <= 32'h2258fff5; //                     addi $t8, $s2, -11
    ROMDATA[31'h00000081] <= 32'h00000000; //                     nop
    ROMDATA[31'h00000082] <= 32'h13000010; //                     beqz $t8, Translate2
    ROMDATA[31'h00000083] <= 32'h200f0063; //                     addi $t7, $zero, 99
    ROMDATA[31'h00000084] <= 32'h2258fff4; //                     addi $t8, $s2, -12
    ROMDATA[31'h00000085] <= 32'h00000000; //                     nop
    ROMDATA[31'h00000086] <= 32'h1300000c; //                     beqz $t8, Translate2
    ROMDATA[31'h00000087] <= 32'h200f0085; //                     addi $t7, $zero, 133
    ROMDATA[31'h00000088] <= 32'h2258fff3; //                     addi $t8, $s2, -13
    ROMDATA[31'h00000089] <= 32'h00000000; //                     nop
    ROMDATA[31'h0000008a] <= 32'h13000008; //                     beqz $t8, Translate2
    ROMDATA[31'h0000008b] <= 32'h200f0061; //                     addi $t7, $zero, 97
    ROMDATA[31'h0000008c] <= 32'h2258fff2; //                     addi $t8, $s2, -14
    ROMDATA[31'h0000008d] <= 32'h00000000; //                     nop
    ROMDATA[31'h0000008e] <= 32'h13000004; //                     beqz $t8, Translate2
    ROMDATA[31'h0000008f] <= 32'h200f0071; //                     addi $t7, $zero, 113
    ROMDATA[31'h00000090] <= 32'h2258fff1; //                     addi $t8, $s2, -15
    ROMDATA[31'h00000091] <= 32'h00000000; //                     nop
    ROMDATA[31'h00000092] <= 32'h13000000; //                     beqz $t8, Translate2
    ROMDATA[31'h00000093] <= 32'h000f9020; // Translate2:         add $s2, $zero, $t7
    ROMDATA[31'h00000094] <= 32'h03e00008; //                     jr $ra
    ROMDATA[31'h00000095] <= 32'h1211000e; // Main:               beq $s0, $s1, Res1
    ROMDATA[31'h00000096] <= 32'h22130000; //                     addi $s3, $s0, 0
    ROMDATA[31'h00000097] <= 32'h22340000; //                     addi $s4, $s1, 0
    ROMDATA[31'h00000098] <= 32'h00000000; // Loop1:              nop
    ROMDATA[31'h00000099] <= 32'h1e740005; //                     bgt $s3, $s4, Loop2
    ROMDATA[31'h0000009a] <= 32'h02935822; //                     sub $t3, $s4, $s3
    ROMDATA[31'h0000009b] <= 32'h00000000; //                     nop
    ROMDATA[31'h0000009c] <= 32'h126b0009; //                     beq $s3, $t3, Res2
    ROMDATA[31'h0000009d] <= 32'h21740000; //                     addi $s4, $t3, 0
    ROMDATA[31'h0000009e] <= 32'h08000098; //                     j Loop1
    ROMDATA[31'h0000009f] <= 32'h02745822; // Loop2:              sub $t3, $s3, $s4
    ROMDATA[31'h000000a0] <= 32'h00000000; //                     nop
    ROMDATA[31'h000000a1] <= 32'h128b0004; //                     beq $s4, $t3, Res2
    ROMDATA[31'h000000a2] <= 32'h21730000; //                     addi $s3, $t3, 0
    ROMDATA[31'h000000a3] <= 32'h08000098; //                     j Loop1
    ROMDATA[31'h000000a4] <= 32'h22240000; // Res1:               addi $a0, $s1, 0
    ROMDATA[31'h000000a5] <= 32'h208b0000; //                     addi $t3, $a0, 0
    ROMDATA[31'h000000a6] <= 32'h21640000; // Res2:               addi $a0, $t3, 0
    ROMDATA[31'h000000a7] <= 32'had240000; //                     sw $a0, 0($t1)
    ROMDATA[31'h000000a8] <= 32'had040018; //                     sw $a0, 24($t0)
    ROMDATA[31'h000000a9] <= 32'h08000002; //                     j Initialization
    for (i=170; i<ROM_SIZE; i=i+1) begin
        ROMDATA[i] <= 32'b0;
    end
end
endmodule
