loop:
#addi $s2,$zero,10
#addi $s3,$zero, 2
add $s1,$s2,$s3   #s1=12
sub $s0,$s1,$s3   #s0=10
subu $s4,$s1,$s3
sw  $s1,100($zero)
lw  $t0,100($zero)
slt $t1,$s0,$s1
sltu $t2,$s0,$s1
beq $t1,$t2,label1
label2:
add $t2,$t0,$t1
label1:
ori $t3,$s1,100
addiu $t4,$s1,88
beq $t0,$t1,label2
j   loop
