loop:
#addi $s2,$zero,10
#addi $s3,$zero, 2
add $s1,$s2,$s3
sub $s0,$s1,$s3
and $s1,$s2,$s3
or  $s1,$s2,$s3
sw  $s1,100($zero)
lw  $t0,100($zero)
slt $t1,$s0,$s1
beq $s0,$s1,label1
label2:
add $t2,$t0,$t1
label1:
beq $t0,$t1,label2
j   loop