module mips(clk, rst) ; 
input     clk ;   // clock 
input     rst ;// reset 

wire  RegWr, ExtOp,  ALUSrc;
wire[1:0]  Jump,MemtoReg,RegDst;
wire[2:0] MemWr,Branch;
wire[3:0]  ALUctr;
wire[31:2]  NPC,PC;//+00

wire[31:0]  ins;
wire[4:0]  Rw;
wire[31:0]  busA, busB, busW;
wire[31:0]  imm16Ext, busBB;
wire  zero,overflow;
wire[31:0]  ALU_Result, dm_Result;
wire[31:0]  LUI_Result;

assign LUI_Result = {ins[15:0],16'd0};
//get pc
pc       a_pc( .PC(PC), .NPC(NPC), .Clk(clk), .Reset(rst));
//get npc
npc      a_npc( .busA(busA), .imm16(ins[15:0]), .branch(Branch), .zero(zero), .jump(Jump), .target(ins[25:0]), .PC(PC), .NPC(NPC));
//get instruction
im_4k    a_im_4k( .addr(PC[11:2]), .dout(ins) );
//get ctrl
ctrl     a_ctrl( .op(ins[31:26]), .RegWr(RegWr), .RegDst(RegDst), .ExtOp(ExtOp), .ALUSrc(ALUSrc), .branop(ins[20:16]), .Branch(Branch), .Jump(Jump), .MemWr(MemWr), .MemtoReg(MemtoReg));
ALUctrl  a_ALUctr( .op(ins[31:26]), .func(ins[5:0]), .ALUctr(ALUctr));
//fetch from register file
MUX3     a_MUX3_Rw( .a(ins[20:16]), .b(ins[15:11]), .c(5'b11111), .ctr(RegDst), .y(Rw));//选择器i  or R
rf       a_rf( .Clk(clk), .WrEn(RegWr&!overflow), .Ra(ins[25:21]), .Rb(ins[20:16]), .Rw(Rw), .busW(busW), .busA(busA), .busB(busB));
//ALU
ext      #(16,32) a_ext( .Extop(ExtOp), .a(ins[15:0]), .y(imm16Ext));
MUX2     a_MUX2_busBB( .a(busB), .b(imm16Ext), .ctr(ALUSrc), .y(busBB));
ALU      a_ALU( .A(busA), .B(busBB), .C(ins[10:6]), .ALUctr(ALUctr), .zero(zero), .overflow(overflow), .result(ALU_Result));//未考虑溢出
//dm
dm_4k    a_dm_4k( .addr(ALU_Result[11:0]), .din(busB), .we(MemWr), .clk(clk), .dout(dm_Result));
//MUX2     a_MUX2_busW( .a(ALU_Result), .b(dm_Result), .ctr(MemtoReg), .y(busW));
MUX4    a_MUX4_busW( .a(ALU_Result), .b(dm_Result), .c(LUI_Result), .d({PC[31:2]+1,2'b00}), .ctr(MemtoReg), .y(busW));
endmodule
