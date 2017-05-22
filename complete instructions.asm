#edited by lcj
#14级的instructions： lw, sw, add, sub, and,  or,  slt, beq, j
#15级的instructions： lw, sw, add，sub，subu，ori, slt，beq, j, sltu，addiu
#考虑到指令集可能不同就只用：lw, sw, add, sub, slt, beq, j七个指令


#基本流水，没有beq和j指令
#初始 $t0 = 7, $t1 = 15, 其余为0
begin:
#add $t0, $zero, 7
#add $t1, $zero, 15
add  $t2, $t0, $t1  #t1 = 22
add  $t3, $t0, $t0  #t3 = 14
sub  $t4, $t1, $t0  #t4 = 8
slt  $t5, $t0, $t1  #t5 = 1
slt  $t6, $t0, $t0  #t6 = 0
sw   $t1, 100($zero)#t1 => 
lw   $t7, 100($zero)#t7 <= 

#数据冒险1: Ex hazard和 MEM hazard互相独立
#EX/MEM.RegisterRd = ID/EX.RegisterRt或MEM/WB.RegisterRd = ID/EX.RegisterRs
#或EX/MEM.RegisterRd = ID/EX.RegisterRt或MEM/WB.RegisterRd = ID/EX.RegisterRt
#初始 $t0 = 7, $t1 = 15, 其余为0
add  $t2, $zero, $zero
add  $t3, $zero, $zero
add  $t4, $zero, $zero
add  $t5, $zero, $zero
add  $t6, $zero, $zero
add  $t7, $zero, $zero

sub  $t2, $t1, $t0 #t2 = 8
add  $t3, $t2, $t1 #t3 = 22, EX/MEM.RegisterRd = ID/EX.RegisterRs
add  $t4, $t2, $t0 #t4 = 15, MEM/WB.RegisterRd = ID/EX.RegisterRs
add  $t5, $t1, $t4 #t5 = 30,  EX/MEM.RegisterRd = ID/EX.RegisterRt
add  $t6, $t1, $t4 #t6 = 30,  MEM/WB.RegisterRd = ID/EX.RegisterRt

#数据冒险2  Ex hazard和 MEM hazard同时出现,应选择上一条指令（Ex hazard）的结果
#初始 $t0 = 7, $t1 = 15, 其余为0
add  $t2, $zero, $zero
add  $t3, $zero, $zero
add  $t4, $zero, $zero
add  $t5, $zero, $zero
add  $t6, $zero, $zero

sub  $t2, $t1, $t0 #t2 = 8
add  $t2, $t2, $t1 #t2 = 23, EX/MEM.RegisterRd = ID/EX.RegisterRs
add  $t4, $t0, $t2 #t4 = 30, EX/MEM.RegisterRd = ID/EX.RegisterRt & MEM/WB.RegisterRd = ID/EX.RegisterRt
sub  $t4, $t1, $t0 #t4 = 8
add  $t5, $t4, $t2 #t5 = 31,  EX/MEM.RegisterRd = ID/EX.RegisterRs & MEM/WB.RegisterRd = ID/EX.RegisterRs

#load-use冒险  & 结构冒险（最后一条是结构冒险）
#初始 $t0 = 7, $t1 = 15, 其余为0
add  $t2, $zero, $zero
add  $t3, $zero, $zero
add  $t4, $zero, $zero
add  $t5, $zero, $zero

sw   $t1, 100($zero) #t1 =>
lw   $t2, 100($zero) #t2 <= 15
add  $t3, $t2, $t0   #t3 = 22, load-use冒险1，需要和上一条指令间插入一个气泡，然后属于MEM/WB.RegisterRd = ID/EX.RegisterRs的转发
sub  $t4, $t2, $t0   #t4 = 8,  load-use冒险2（结构冒险），和lw相隔一个气泡和一个指令， lw前半个周期写入寄存器堆，后半个周期，$t2读入

#branch
#初始 $t0 = 7, $t1 = 15, 其余为0
add  $t2, $zero, $zero
add  $t3, $zero, $zero
add  $t4, $zero, $zero

##相邻的branch
beq  $t1, $t1, test0   #跳转，   最基本的branch操作
j    begin
test0:
add  $t2, $t1, $t0     #$t2 = 22
beq  $t2, $t1, test1   #不跳转，  branch在第二个周期（ID）判断，需要上一条指令执行完第三个周期（EX），所以需要插入气泡
sub  $t3, $t1, $t0     #$t3 = 8
sub  $t4, $t1, $t0     #$t4 = 8
beq  $t3, $t4, test2   #跳转，    判断相邻两条指令的情况
test1:
j    begin
##lw-branch的情况
test2:
sw  $t1, 100($zero)
lw  $t5, 100($zero)    #$t5 = 15
beq $t5, $t0, test3    #不跳转,lw,branch不隔指令(要插入两个空气泡，lw后插一个，branch前插一个)
lw  $t7, 100($zero)
add $t6, $t1, $zero    #$t6 = 15
test3:
beq $t6, $t7, test4    #跳转，lw,branch隔一条指令	
j begin
test4:
lw  $t5, 100($zero)    #$t5 = 15
beq $t5, $t5, test5    #跳转,lw,branch不隔指令(要插入两个空气泡，lw后插一个，branch前插一个)
j   begin
test5:

#use-load冒险（转发单元在I指令可能存在的问题。。只针对forwardB,传入alu的busB）
#只要非R指令，alu的busB是imm16就好
#初始 $t0 = 7, $t1 = 15, 其余为0
#基于上面的冒险都已解决， 不考虑指令间的间隔
add  $t2, $zero, $zero
add  $t3, $zero, $zero
add  $t4, $zero, $zero
add  $t5, $zero, $zero
add  $t6, $zero, $zero
add  $t7, $zero, $zero

add  $t2, $t1, $t0    #t2 = 22
sw   $t1, 100($zero)
lw   $t2, 100($zero)  #t2 = 15， 实际应该是15(错误下得到0)，但（当前是ID/EX）MEM/WB.RegisterRd = ID/EX.RegisterRt,导致forwardB = 01，转发的时候传入busB（alu中）不是imm16而是22
add  $s7, $zero, $zero
add  $s7, $zero, $zero
add  $s7, $zero, $zero
sub  $t3, $t1, $t0    #t3 = 8
lw   $t3, 100($zero)  #t3 = 15,  实际应该是15(错误下得到0)，但（当前是ID/EX）EX/MEM.RegisterRd = ID/EX.RegisterRt,导致forwardB = 10，转发的时候传入alu的busB不是imm16而是8
sw   $t3, 40($zero)   #t3 =>     （存储的地址出错）前面一条正确的情况下，存储的数据内存地址可能不是40（$zero）, （先插入一个气泡，而后） MEM/WB.RegisterRd = ID/EX.RegisterRt, 导致forwardB = 01，转发的时候传入busB（alu中）不是imm16而是$t3

j    begin


#如果branch是第一条指令，刷新的时候会出现死循环？
