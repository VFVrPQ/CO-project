module mips(clk, rst) ;
	input	clk ;   // clock
	input	rst ;// reset
	
	wire	RegWr,RegDst,ExtOp,ALUsrc,Branch,Jump,MemWr,MemtoReg;
	wire[2:0]  ALUctr;
	wire[31:2] NPC,PC;
	
	wire[31:0] ins;
	wire[4:0]  Rw;
	wire[31:0] busA, busB, busW;
	wire[31:0] imm16Ext, busBB;
	wire	Zero;
	wire[31:0] ALU_Result, dm_Result;

	//get pc
	pc 	a_pc( .NPC(NPC), .Clk(clk), .Reset(rst), .PC(PC) );
	//get npc
	npc 	a_npc( .imm16(ins[15:0]) , .Branch(Branch) , .Zero(Zero), .Jump(Jump), .Target(ins[25:0]) , .PC(PC), .NPC(NPC));//Zero
	//get instruction
	im_4k 	a_im_4k( .addr(PC[11:2]), .dout(ins));
	//get ctrl
	ctrl	a_ctrl(.op(ins[31:26]), .func(ins[5:0]), .RegWr(RegWr), .RegDst(RegDst), .ExtOp(ExtOp), .ALUsrc(ALUsrc), .Branch(Branch), .Jump(Jump), .ALUctr(ALUctr), .MemWr(MemWr), .MemtoReg(MemtoReg));
	//register file
	MUX2 #5	a_MUX2_Rw( .a(ins[20:16]), .b(ins[15:11]), .ctr(RegDst), .y(Rw));
	rf	a_rf(.Clk(clk), .WrEn(RegWr), .Ra(ins[25:21]), .Rb(ins[20:16]), .Rw(Rw), .busW(busW), .busA(busA), .busB(busB));//busW not get
	//ALU
	SignExt16 a_SignExt16(.ExtOp(ExtOp), .a(ins[15:0]), .y(imm16Ext));
	MUX2	a_MUX2_ALUsrc(busB, imm16Ext, ALUsrc, busBB);
	ALU	a_ALU(busA, busBB, ALUctr, Zero, ALU_Result);
	//dm
	dm_4k	a_dm_4k(.addr(ALU_Result[11:2]), .din(busB), .we(MemWr), .clk(clk), .dout(dm_Result));
	MUX2	a_MUX2_busW(ALU_Result, dm_Result, MemtoReg, busW);
endmodule
