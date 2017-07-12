                 j Initialization
                 j Interrupt
Initialization:  lui  $t0,0x4000                #TH
                 addi $t1,$t0,0xC               #LED
                 addi $t2,$t0,0x14              #digi
                 addi $t5,$zero,0
                 addi $v0,$zero,0
                 addi $v0,$zero,0
                 lui  $t6,0xFFFF                #TH
                 ori  $t6,$t6,0x0000
                 sw   $t6,0($t0)
                 lui  $t6,0xFFFF                #TL
                 ori  $t6,$t6,0xFFFF
                 sw   $t6,4($t0)
                 la $ra, Loop
                 addi $t6,$zero,3               #启动定时器，TCON置3
                 sw $t6,8($t0)
                 jr $ra
Loop:            bne $v1,$t5,Increment1
                 j Loop
Increment1:      addi $v0,$v0,1
                 andi $v1,$v0,0x1000
                 nop
                 bnez $v1,Increment2
                 addi $v1,$t5,0
                 j Loop
Increment2:      addi $s0,$s0,1
                 addi $s1,$s1,-1
                 addi $v0,$zero,0
                 addi $v1,$t5,0
                 j Main
Interrupt:       sw $zero,8($t0)
                 beqz $t5,Num1                  #中断处理程序，根据$t5值，digi显示不同位
                 addi $t6,$t5,-1
                 nop
                 beqz $t6,Num2
                 addi $t6,$t5,-2
                 nop
                 beqz $t6,Num3
                 addi $t6,$t5,-3
                 nop
                 beqz $t6,Num4
Num1:            sll $s2,$s0,28                 #$s0低四位
                 srl $s2,$s2,28
                 jal Translate1
                 addi $s2,$s2,3584
                 sw $s2,0($t2)
                 addi $t5,$t5,1
                 addi $t6,$zero,3
                 sw $t6,8($t0)
                 addi $26, $26, -4
                 nop
                 jr $26
Num2:            sll $s2,$s0,24                  #$s0高四位
                 srl $s2,$s2,28
                 jal Translate1
                 addi $s2,$s2,3328
                 sw $s2,0($t2)
                 addi $t5,$t5,1
                 addi $t6,$zero,3
                 sw $t6,8($t0)
                 addi $26, $26, -4
                 nop
                 jr $26
Num3:            sll $s2,$s1,28                 #$s1低四位
                 srl $s2,$s2,28
                 jal Translate1
                 addi $s2,$s2,2816
                 sw $s2,0($t2)
                 addi $t5,$t5,1
                 addi $t6,$zero,3
                 sw $t6,8($t0)
                 addi $26, $26, -4
                 nop
                 jr $26
Num4:            sll $s2,$s1,24                  #$s1高四位
                 srl $s2,$s2,28
                 jal Translate1
                 addi $s2,$s2,1792
                 sw $s2,0($t2)
                 addi $t5,$zero,0
                 addi $t6,$zero,3
                 sw $t6,8($t0)
                 addi $26, $26, -4
                 nop
                 jr $26
Translate1:      addi $t7,$zero,3               #将$s0,$s1值转为bcd7对应编码(小数点都不亮)
                 beqz $s2,Translate2
                 addi $t7,$zero,159
                 addi $t8,$s2,-1
                 nop
                 beqz $t8,Translate2
                 addi $t7,$zero,37
                 addi $t8,$s2,-2
                 nop
                 beqz $t8,Translate2
                 addi $t7,$zero,13
                 addi $t8,$s2,-3
                 nop
                 beqz $t8,Translate2
                 addi $t7,$zero,153
                 addi $t8,$s2,-4
                 nop
                 beqz $t8,Translate2
                 addi $t7,$zero,73
                 addi $t8,$s2,-5
                 nop
                 beqz $t8,Translate2
                 addi $t7,$zero,65
                 addi $t8,$s2,-6
                 nop
                 beqz $t8,Translate2
                 addi $t7,$zero,31
                 addi $t8,$s2,-7
                 nop
                 beqz $t8,Translate2
                 addi $t7,$zero,1
                 addi $t8,$s2,-8
                 nop
                 beqz $t8,Translate2
                 addi $t7,$zero,9
                 addi $t8,$s2,-9
                 nop
                 beqz $t8,Translate2
                 addi $t7,$zero,17
                 addi $t8,$s2,-10
                 nop
                 beqz $t8,Translate2
                 addi $t7,$zero,193
                 addi $t8,$s2,-11
                 nop
                 beqz $t8,Translate2
                 addi $t7,$zero,99
                 addi $t8,$s2,-12
                 nop
                 beqz $t8,Translate2
                 addi $t7,$zero,133
                 addi $t8,$s2,-13
                 nop
                 beqz $t8,Translate2
                 addi $t7,$zero,97
                 addi $t8,$s2,-14
                 nop
                 beqz $t8,Translate2
                 addi $t7,$zero,113
                 addi $t8,$s2,-15
                 nop
                 beqz $t8,Translate2
Translate2:      add $s2,$zero,$t7
                 jr $ra
Main:            andi $s0,$s0,0xFF
                 andi $s1,$s1,0xFF
                 nop
                 beq $s0,$s1,Res1               #最大公约数程序，$s0=$s1时，答案是自己
                 addi $s3,$s0,0
                 addi $s4,$s1,0
Loop1:           nop
                 bgt $s3,$s4,Loop2              #$s3>$s4时
                 sub $t3,$s4,$s3
                 nop
                 beq $s3,$t3,Res2               #减数等于差则跳出
                 addi $s4,$t3,0
                 j Loop1
Loop2:           sub $t3,$s3,$s4                #$s3<$s4时
                 nop
                 beq $s4,$t3,Res2               #减数等于差则跳出
                 addi $s3,$t3,0
                 j Loop1
Res1:            addi $a0,$s1,0
                 addi $t3,$a0,0
Res2:            addi $a0,$t3,0
                 sw $a0,0($t1)                  #结果写到led
                 j Loop