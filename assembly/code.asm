j Initialization
j Interrupt

Initialization:
lui $t0,16384                  # $t0=TH地址
addi $t1,$t0,12                # led地址
addi $t2,$t0,26                # $t2=digi_in地址
addi $t3,$t0,24                # TXD地址
addi $t4,$t0,28                # RXD地址
addi $t5,$zero,0               # 显示第几位？？？？
lui $t6,65535
addi $t6,$t6,15535             # 频率1kHz
sw $t6,0($t0)
lui $t6,65535
addi $t6,$t6,65535
sw $t6,4($t0)                  # 设置TL
addi $t6,$zero,3
sw $t6,8($t0)                  # 设置TCON，启动定时器
addi $ra,$zero,72              # 80是哪？是72的Read嘛？
jr $ra                         # 跳到用户态

Read:
sw $t6,8($t0)                  # 使TCON为011 ？？？
lw $t6,32($t0)                 # 读UARTCON
srl $t6,$t6,3
subi $t6,$t6,1
beqz $t6,Load2                 # 收到数据
j Read
Load2:
beqz $t5,Load1
addi $t5,$zero,0               # 将t5初始化为0留作interrupt里控制显示第几位？？？
lw $s1,0($t4)                  # $s1第二个数据？？
j Main
Load1:
lw $s0,0($t4)                  # $s0第一个数据？？
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
srl $s2,$s2,28                 # s0低4位
addi $s2,$s2,256
sw $s2,0($t2)
addi $t5,$t5,1
addi $t6,$zero,3
sw $t6,8($t0)                  # 设置TCON，启动定时器
addi $26, $26, -4
jr $26
Num2:
srl $s2,$s0,4                  # s0高4位
addi $s2,$s2,512
sw $s2,0($t2)
addi $t5,$t5,1
addi $t6,$zero,3
sw $t6,8($t0)                  # 设置TCON，启动定时器
addi $26, $26, -4
jr $26
Num3:
sll $s2,$s1,28
srl $s2,$s2,28                 # s1低4位
addi $s2,$s2,1024
sw $s2,0($t2)
addi $t5,$t5,1
addi $t6,$zero,3
sw $t6,8($t0)                  # 设置TCON，启动定时器
addi $26, $26, -4
jr $26
Num4:
srl $s2,$s1,4                  # s1高4位
addi $s2,$s2,2048
sw $s2,0($t2)
addi $t5,$zero,0
addi $t6,$zero,3
sw $t6,8($t0)                  # 设置TCON，启动定时器
addi $26, $26, -4
jr $26

Main:
beq $s0,$s1,Res1               # 相等最大公约数是自己
Loop1:
bgt $s0,$s1,Loop2
sub $t7,$s1,$s0                # s1>s0时
beq $s0,$t7,Res2
addi $s1,$t7,0
j Loop1
Loop2:
sub $t7,$s0,$s1                # s0>s1时
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
beq	$zero, $zero, HALT         # 死循环
