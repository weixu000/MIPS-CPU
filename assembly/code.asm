j Initialization
j Interrupt

Initialization:
lui $t0,16384
addi $t1,$t0,12
addi $t2,$t0,20
addi $t4,$t0,28
addi $t5,$zero,0
addi $t9,$zero,0
lui $t6,65535
ori $t6,$t6,15535
sw $t6,0($t0)
lui $t6,65535
ori $t6,$t6,65535
sw $t6,4($t0)
addi $t6,$zero,3
sw $t6,8($t0)
addi $ra,$zero,80
sw $t6,8($t0)
jr $ra

Read:
lw $t6,32($t0)
srl $t6,$t6,3
addi $t6,$t6,-1
beqz $t6,Load2
j Read
Load2:
beqz $t9,Load1
lw $s1,0($t4)
j Main
Load1:
lw $s0,0($t4)
addi $t9,$t9,1
j Read

Interrupt:
addi $t6,$zero,0
sw $t6,8($t0)
beqz $t5,Num1
addi $t6,$t5,-1
beqz $t6,Num2
addi $t6,$t5,-2
beqz $t6,Num3
addi $t6,$t5,-3
beqz $t6,Num4
Num1:
sll $s2,$s0,28
srl $s2,$s2,28
jal Translate1
addi $s2,$s2,3584
sw $s2,0($t2)
addi $t5,$t5,1
addi $t6,$zero,3
sw $t6,8($t0)
addi $26, $26, -4
jr $26
Num2:
srl $s2,$s0,4
jal Translate1
addi $s2,$s2,3328
sw $s2,0($t2)
addi $t5,$t5,1
addi $t6,$zero,3
sw $t6,8($t0)
addi $26, $26, -4
jr $26
Num3:
sll $s2,$s1,28
srl $s2,$s2,28
jal Translate1
addi $s2,$s2,2816
sw $s2,0($t2)
addi $t5,$t5,1
addi $t6,$zero,3
sw $t6,8($t0)
addi $26, $26, -4
jr $26
Num4:
srl $s2,$s1,4
jal Translate1
addi $s2,$s2,1792
sw $s2,0($t2)
addi $t5,$zero,0
addi $t6,$zero,3
sw $t6,8($t0)
addi $26, $26, -4
jr $26

Translate1:
addi $t7,$zero,3
beqz $s2,Translate2
addi $t7,$zero,159
addi $t8,$s2,-1
beqz $t8,Translate2
addi $t7,$zero,37
addi $t8,$s2,-2
beqz $t8,Translate2
addi $t7,$zero,13
addi $t8,$s2,-3
beqz $t8,Translate2
addi $t7,$zero,153
addi $t8,$s2,-4
beqz $t8,Translate2
addi $t7,$zero,73
addi $t8,$s2,-5
beqz $t8,Translate2
addi $t7,$zero,65
addi $t8,$s2,-6
beqz $t8,Translate2
addi $t7,$zero,31
addi $t8,$s2,-7
beqz $t8,Translate2
addi $t7,$zero,1
addi $t8,$s2,-8
beqz $t8,Translate2
addi $t7,$zero,9
addi $t8,$s2,-9
beqz $t8,Translate2
addi $t7,$zero,17
addi $t8,$s2,-10
beqz $t8,Translate2
addi $t7,$zero,193
addi $t8,$s2,-11
beqz $t8,Translate2
addi $t7,$zero,99
addi $t8,$s2,-12
beqz $t8,Translate2
addi $t7,$zero,133
addi $t8,$s2,-13
beqz $t8,Translate2
addi $t7,$zero,97
addi $t8,$s2,-14
beqz $t8,Translate2
addi $t7,$zero,113
addi $t8,$s2,-15
beqz $t8,Translate2
Translate2:
add $s2,$zero,$t7
jr $ra

Main:
beq $s0,$s1,Res1 
addi $s3,$s0,0
addi $s4,$s1,0             
Loop1:
bgt $s3,$s4,Loop2
sub $t3,$s4,$s3               
beq $s3,$t3,Res2
addi $s4,$t3,0
j Loop1
Loop2:
sub $t3,$s3,$s4               
beq $s4,$t3,Res2
addi $s3,$t3,0
j Loop1
Res1:
addi $a0,$s3,0
addi $t3,$a0,0
Res2:
addi $a0,$t3,0
sw $a0,0($t1)                  
sw $a0,24($t0)                  

Halt:
beq	$zero, $zero, Halt         
