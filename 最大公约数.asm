j Initial
j Interrupt
Initialization: 
lui $t0,16384#$t0=TH��ַ
addi $t1,$t0,12#led��ַ
addi $t2,$t0,26#$t2=digi_in��ַ
addi $t3,$t0,24#TXD��ַ
addi $t4,$t0,28#RXD��ַ
addi $t5,$zero,0
lui $t6,65535
addi $t6,$t6,15535#Ƶ��1kHz
sw $t6,0($t0)
lui $t6,65535
addi $t6,$t6,65535
sw $t6,4($t0)#����TL
addi $t6,$zero,3
sw $t6,8($t0)#����TCON��������ʱ��
addi $ra,$zero,80
jr $ra#�����û�̬
Read:
sw $t6,8($t0)#ʹTCONΪ011
lw $t6,32($t0)#��UARTCON
srl $t6,$t6,3
subi $t6,$t6,1
beqz $t6,Load2
j Read
Load2:
beqz $t5,Load1
addi $t5,$zero,0#��t5��ʼ��Ϊ0����interrupt�������ʾ�ڼ�λ
lw $s1,0($t4)
j Main
Load1:
lw $s0,0($t4)
addi $t5,$t5,1
j Read
Interrupt:
addi $t6,$zero,0
sw $t6,8($t0)#TCON=0
beqz $t5,Num1
subi $t6,$t5,1
beqz $t6,Num2
subi $t6,$t5,2
beqz $t6,Num3
subi $t6,$t5,3
beqz $t6,Num4
Num1:
sll $s2,$s0,28
srl $s2,$s2,28#s0��4λ
addi $s2,$s2,256
sw $s2,0($t2)
addi $t5,$t5,1
addi $t6,$zero,3
sw $t6,8($t0)#����TCON��������ʱ��
jr
Num2:
srl $s2,$s0,4#s0��4λ
addi $s2,$s2,512
sw $s2,0($t2)
addi $t5,$t5,1
addi $t6,$zero,3
sw $t6,8($t0)#����TCON��������ʱ��
jr
Num3:
sll $s2,$s1,28
srl $s2,$s2,28#s1��4λ
addi $s2,$s2,1024
sw $s2,0($t2)
addi $t5,$t5,1
addi $t6,$zero,3
sw $t6,8($t0)#����TCON��������ʱ��
jr
Num4:
srl $s2,$s1,4#s1��4λ
addi $s2,$s2,2048
sw $s2,0($t2)
addi $t5,$zero,0
addi $t6,$zero,3
sw $t6,8($t0)#����TCON��������ʱ��
jr
Main:
beq $s0,$s1,Res1#������Լ�����Լ�
Loop1:
bgt $s0,$s1,Loop2
sub $t7,$s1,$s0#s1>s0ʱ
beq $s0,$t7,Res2
addi $s1,$t7,0
j Loop1
Loop2:
sub $t7,$s0,$s1#s0>s1ʱ
beq $s1,$t7,Res2
addi $s0,$t7,0
j Loop1
Res1:
addi $a0,$s0,0
addi $t7,$a0,0
Res2:
addi $a0,$t7,0
sw $a0,0($t1)#led��ʾ���
sw $a0,0($t3)#д��TXD







