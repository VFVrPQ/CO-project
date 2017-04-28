readme.md来自：https://github.com/HaleLu/mips.git
# mips
Mips 处理器仿真设计

## 开发语言、工具和环境
采用 Verilog 语言开发  
Window 7 环境下

## 开发进度
Project 1 已完成支持9条指令的单周期。

## Project_1
单周期的 MIPS 处理器  
只支持 add、sub、and、or、lw、sw、slt、beq、j 这9条指令  

具体分为两大部分和处理器部分
### datapath（数据通路）
定义了各种元部件
#### ALU.v
模块名：ALU
说明：算逻部件  
输入接口：ALUctr（3位，运算符编码）,  A, B（32位，运算数） 
输出接口：Zero（结果是否为0）, Result（32位，运算结果）  
ALUctr的说明：  
　　000： Result = A + B  
　　001： Result = A - B  
　　010： Result = A | B  
　　011： Result = A & B  
　　100： Result = A < B ? 1 : 0

#### dm.v
模块名：dm_4k  
说明：数据寄存器，大小为4k（时钟上升沿触发）  
输入接口：addr（10位，数据地址）, din（32位，写数据时的数据端）, we（写数据使能端）, re（读数据使能端）, clk（时钟端）  
输出接口：dout（32位，读数据时的数据输出端）  

#### SignExt.v
模块名：SignExt16
说明：16位数的符号扩展部件（WIDTH 表示输出数据宽度）  
输入接口：ExtOp（0表示无符号位扩展，1表示有符号），a（16 位）  ,
输出接口：y（WIDTH 位）  

模块名：SignExt1
说明：1位数的无符号扩展部件（WIDTH 表示输出数据宽度）  
输入接口：a（1 位）  ,
输出接口：y（WIDTH 位）  

#### im.v
模块名：im_4k  
说明：指令存储器，大小为4k  
输入接口：addr（10位，运算符编码）  
输出接口：dout（32位，对应指令）  

#### MUX.v
模块名：mux2  
说明：二路选择器（WIDTH 表示输入数据宽度）  
输入接口：a, b（W 位，表示0和1对应的数据源）, ctr（选择信号）  
输出接口：y（W 位，选择结果）  

#### pc.v
模块名：pc  
说明：程序计数器（时钟上升沿触发）  
输入接口：NPC（30位，下一指令地址；低两位忽略）  ,Clk（时钟端）, Reset（重置信号）
输出接口：dout（30位，当前指令地址）  

#### rf.v
模块名：rf  
说明：寄存器堆（时钟上升沿触发）  
输入接口：Clk（时钟端）, WrEn（写寄存器使能端）, Ra（5位，读寄存器1地址）, Rb（5位，读寄存器2地址）, Rw（5位，写寄存器的地址）, busW（写入寄存器的数据）  
输出接口：busA（32位，读寄存器1的数据）, busB（32位，读寄存器2的数据）
另：有部分为方便测试而添加的初始化寄存器的值的代码。  

### control（控制信号）

解析指令，生成对应的控制信号

#### ALUctrl.v
模块名：ALUctrl  
说明：算逻部件控制器  
输入接口：ALUOp（2位）, funct（6位，指令的5-0位）  
输出接口：op（4位，对应的 alu 运算符编码）

#### ctrl.v
模块名：ctrl  
说明：算逻部件控制器  
输入接口：op（6位，指令的31-26位）,func（6位，指令的5-0位）
输出接口：RegWr,RegDst,ExtOp,ALUsrc,Branch,Jump,ALUctr,MemWr,MemtoReg（各种控制信号，其中 ALUctr 为3位）

控制信号名|无效时的含义|有效时的含义
:--|:--:|--:
RegDst|写寄存器的目标寄存器号来自 rt 字段（位 20 : 16 ）|写寄存器的目标寄存器号来自 rd 字段（位 15 : 11 ）
RegWr|无|寄存器堆写使能有效
ALUsrc|第二个 ALU 操作数来自寄存器堆的第二个输出（读数据2）|第二个 ALU 操作数为指令低16位的符号扩展
MemWr|无|数据存储器写使能有效
MemtoReg|写入存储器的数据来自 ALU|写入寄存器的数据来自数据存储器
Jump|无|PC 跳转至指定地址
Branch|无|PC 在分支条件成立时跳转

### mips.v（处理器部分）
模块名：mips  
说明：单周期处理器（时钟上升沿触发）  
输入接口：clk（时钟端）, rst（重置信号）  

### testbench.v（测试代码）
模块名：testbench  
说明：生成时钟信号测试部件可行性  

