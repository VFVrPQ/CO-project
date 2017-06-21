#add $t2, $zero, 7
#add $t3, $zero, 15
#add $t9, $zero, 0
#add $t9, $zero, 0
#add $t9, $zero, 0

j    goto
add  $t1, $t2, $t3  #t1 = 22
addi $t4, $t2, 128  #t4 = 135
goto:
beq  $zero, $zero, label
sub  $t5, $t3, $t2  #t5 = 8
and  $t6, $t3, $t2  #t6 = 8
label:
or   $t7, $t3, $t2  #t7 = 15
slt  $t8, $t2, $t3  #t8 = 1
sw   $t4, 100($zero)
lw   $t9, 100($zero)
 
