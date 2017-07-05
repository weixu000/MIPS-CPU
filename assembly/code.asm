j Initialization
j Interrupt

Initialization:
lui $t0,16384                  # $t0=TH地址
addi $t1,$t0,12                # led地址
addi $t2,$t0,26                # $t2=digi_in地址
addi $t3,$t0,24                # TXD地址
addi $t4,$t0,28                # RXD地址
<<<<<<< HEAD
addi $t5,$zero,0               # 显示第几位？？？�?
=======
addi $t5,$zero,0               # 显示第几位？？？
>>>>>>> origin/master
lui $t6,65535
addi $t6,$t6,15535             # 频率1kHz
sw $t6,0($t0)
lui $t6,65535
addi $t6,$t6,65535
sw $t6,4($t0)                  # 设置TL
addi $t6,$zero,3
sw $t6,8($t0)                  # 设置TCON，启动定时器
addi $ra,$zero,80             # 80是哪？是72的Read嘛？
<<<<<<< HEAD
jr $ra                      # 跳到用户�?

Read:
sw $t6,8($t0)                  # 使TCON�?011 ？？�?
=======
jr $ra                      # 跳到用户

Read:
sw $t6,8($t0)                  # 使TCON011 ？？
>>>>>>> origin/master
lw $t6,32($t0)                 # 读UARTCON
srl $t6,$t6,3
subi $t6,$t6,1
beqz $t6,Load2                 # 收到数据
j Read
Load2:
beqz $t5,Load1
<<<<<<< HEAD
addi $t5,$zero,0               # 将t5初始化为0留作interrupt里控制显示第几位？？�?
lw $s1,0($t4)                  # $s1第二个数据？�?
j Main
Load1:
lw $s0,0($t4)                  # $s0第一个数据？�?
=======
addi $t5,$zero,0               # 将t5初始化为0留作interrupt里控制显示第几位？？
lw $s1,0($t4)                  # $s1第二个数据？
j Main
Load1:
lw $s0,0($t4)                  # $s0第一个数据？
>>>>>>> origin/master
addi $t5,$t5,1
j Read

Interrupt:
addi $t6,$zero,0
sw $t6,8($t0)                  # TCON=0
beqz $t5,Num1
subi $t6,$t5,1
beqz $t6,Num2
subi $t6,$t5,2
beqz $t6,Num3
subi $t6,$t5,3
beqz $t6,Num4
Num1:
sll $s2,$s0,28
<<<<<<< HEAD
srl $s2,$s2,28                 # s0�?4�
jal Translate1
addi $s2,$s2,3584#����an0
=======
srl $s2,$s2,28             
jal Translate1
addi $s2,$s2,3584
>>>>>>> origin/master
sw $s2,0($t2)
addi $t5,$t5,1
addi $t6,$zero,3
sw $t6,8($t0)                  # 设置TCON，启动定时器
addi $26, $26, -4
jr $26
Num2:
<<<<<<< HEAD
srl $s2,$s0,4                  # s0�?4�
jal Translate1
addi $s2,$s2,3328#����an1
=======
srl $s2,$s0,4           
jal Translate1
addi $s2,$s2,3328
>>>>>>> origin/master
sw $s2,0($t2)
addi $t5,$t5,1
addi $t6,$zero,3
sw $t6,8($t0)                  # 设置TCON，启动定时器
addi $26, $26, -4
jr $26
Num3:
sll $s2,$s1,28
<<<<<<< HEAD
srl $s2,$s2,28                 # s1�?4�
jal Translate1
addi $s2,$s2,2816#����an2?
=======
srl $s2,$s2,28             
jal Translate1
addi $s2,$s2,2816
>>>>>>> origin/master
sw $s2,0($t2)
addi $t5,$t5,1
addi $t6,$zero,3
sw $t6,8($t0)                  # 设置TCON，启动定时器
addi $26, $26, -4
jr $26
Num4:
<<<<<<< HEAD
srl $s2,$s1,4                  # s1�?4�?
jal Translate1
addi $s2,$s2,1792#����an3?
=======
srl $s2,$s1,4            
jal Translate1
addi $s2,$s2,1792
>>>>>>> origin/master
sw $s2,0($t2)
addi $t5,$zero,0
addi $t6,$zero,3
sw $t6,8($t0)                  # 设置TCON，启动定时器
addi $26, $26, -4
jr $26

Translate1:
addi $t7,$zero,2#8'b0000_0010
beqz $s2,Translate2
addi $t7,$zero,158#8'b1001_1110
subi $t8,$s2,1
beqz $t8,Translate2
addi $t7,$zero,36#8'b0010_0100
subi $t8,$s2,2
beqz $t8,Translate2
addi $t7,$zero,12#8'b0000_1100
subi $t8,$s2,3
beqz $t8,Translate2
addi $t7,$zero,152#8'b1001_1000
subi $t8,$s2,4
beqz $t8,Translate2
addi $t7,$zero,72#8'b0100_1000
subi $t8,$s2,5
beqz $t8,Translate2
addi $t7,$zero,64#8'b0100_0000
subi $t8,$s2,6
beqz $t8,Translate2
addi $t7,$zero,30#8'b0001_1110
subi $t8,$s2,7
beqz $t8,Translate2
addi $t7,$zero,0#8'b0000_0000
subi $t8,$s2,8
beqz $t8,Translate2
addi $t7,$zero,4#8'b0000_0100
subi $t8,$s2,9
beqz $t8,Translate2
addi $t7,$zero,8#8'b0000_1000
subi $t8,$s2,10
beqz $t8,Translate2
addi $t7,$zero,192#8'b1100_0000
subi $t8,$s2,11
beqz $t8,Translate2
addi $t7,$zero,98#8'b0110_0010
subi $t8,$s2,12
beqz $t8,Translate2
addi $t7,$zero,132#8'b1000_0100
subi $t8,$s2,13
beqz $t8,Translate2
addi $t7,$zero,98#8'b0110_0010
subi $t8,$s2,14
beqz $t8,Translate2
addi $t7,$zero,114#8'b0111_0010
subi $t8,$s2,15
beqz $t8,Translate2
Translate2:
<<<<<<< HEAD
add $s2,$zero,$t7#$����s2�е�8λ
jr $ra

Main:
beq $s0,$s1,Res1               # 相等�?大公约数是自�?
Loop1:
bgt $s0,$s1,Loop2
sub $t7,$s1,$s0                # s1>s0�?
=======
add $s2,$zero,$t7
jr $ra

Main:
beq $s0,$s1,Res1               # 相等大公约数是自
Loop1:
bgt $s0,$s1,Loop2
sub $t7,$s1,$s0                # s1>s0
>>>>>>> origin/master
beq $s0,$t7,Res2
addi $s1,$t7,0
j Loop1
Loop2:
<<<<<<< HEAD
sub $t7,$s0,$s1                # s0>s1�?
=======
sub $t7,$s0,$s1                # s0>s1
>>>>>>> origin/master
beq $s1,$t7,Res2
addi $s0,$t7,0
j Loop1
Res1:
addi $a0,$s0,0
addi $t7,$a0,0
Res2:
addi $a0,$t7,0
sw $a0,0($t1)                  # led显示结果
sw $a0,0($t3)                  # 写入TXD

HALT:
<<<<<<< HEAD
beq	$zero, $zero, HALT         # 死循�?
=======
beq	$zero, $zero, HALT         # 死循
>>>>>>> origin/master
