#add $t2, $zero, 7
#add $t3, $zero, 15
#add $s4, $zero, 128
goto:
add  $t1, $t2, $t3  #t1 = 22
add  $t4, $t2, $s4  #t4 = 135
add  $s0, $t1, $t4  #s0 = 157
sub  $s1, $s4, $zero #s1 = 128
and  $s2, $s1, $t4  #s2 = 128
sw   $t4, 100($zero)
lw   $t9, 100($zero) #t9 = 135
sub  $t5, $t3, $t2  #t5 = 8
beq  $s1, $s2, label
and  $t6, $t3, $t2  #t6 = 8
label:
or   $t7, $t3, $t2  #t7 = 15
slt  $t8, $t2, $t3  #t8 = 1
j    goto
