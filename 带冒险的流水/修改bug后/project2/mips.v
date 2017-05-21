module mips(clk, rst) ;
	input	clk ;   // clock
	input	rst ;// reset

	wire[31:2]  NPC;
  wire[31:2]  PC;
  wire[31:2]  PC_plus_4;
	
	wire[31:0]  if_ins;
  wire        if_flush;
	//id
  wire[5:0]   id_op;
  wire[31:0]  id_ins;
  wire[31:2]  id_PC_plus_4;
  wire[31:0]  id_busA, id_busA_mux2;
  wire[31:0]  id_busB, id_busB_mux2;
  wire[4:0]   id_Ra;
  wire[4:0]   id_Rb;
  wire[4:0]   id_Rw;
  wire[31:0]  id_imm16Ext;
  wire[15:0]  id_imm16;
  wire	      id_RegWr;
  wire        id_RegDst;
  wire        id_ExtOp;
  wire        id_ALUsrc;
  wire        id_Branch;
  wire        id_Jump;
  wire        id_MemWr;
  wire        id_MemtoReg;
	wire[2:0]   id_ALUctr;
  //ex
  wire[5:0]   ex_op;
  wire[31:0]  ex_busB_pushDown;
  wire        ex_Zero;
  wire[31:0]  ex_alu_result;
  wire[31:0]  ex_busA;
  wire[31:0]  ex_busB;
  wire[31:0]  ex_busB_mux2;
  wire[4:0]   ex_Ra;
  wire[4:0]   ex_Rb;
  wire[4:0]   ex_Rw;
  wire[4:0]   ex_Rw_mux2;

  wire        ex_RegWr;
  wire        ex_RegDst;
  wire        ex_ALUsrc;
  wire        ex_Jump;
  wire        ex_MemWr;
  wire        ex_MemtoReg;
  wire[2:0]   ex_ALUctr;

  wire[31:0]  ex_imm16Ext;
  wire[31:2]  ex_PC_plus_4;
  wire[31:0]  ex_alu_busA;
  wire[31:0]  ex_alu_busB;
  //mem
  wire[31:0]  mem_dout;
  wire[31:0]  mem_alu_result;
  wire[4:0]   mem_Rw;
  wire[31:0]  mem_busB;
  
    //control
  wire      mem_RegWr;
  wire	    mem_Jump;
  wire      mem_MemWr;
  wire      mem_MemtoReg;
  wire      mem_Zero;
  //wr
  wire[31:0]  wr_dout;
  wire[31:0]  wr_alu_result;
  wire[4:0]   wr_Rw;
  wire[31:0]  wr_busW;
    //control 
  wire        wr_RegWr;//寄存器堆写使能有效
  wire        wr_Jump;
  wire        wr_MemtoReg;//写入存储器的数据来自 ALU或者数据存储器
  //forwardingUnit
  wire[1:0]   forwardA;
  wire[1:0]   forwardB;
  //hazard
  wire        hazard;
	//get pc
	pc 	a_pc( .NPC(NPC), .Clk(clk), .Reset(rst), .PC(PC) , .hazard(hazard));
	//get pc_plus_4
	assign PC_plus_4 = PC + 1;
	//get instruction
	im_4k 	a_im_4k( .addr(PC[31:2]), .dout(if_ins));
  //if_id
  if_id a_if_id(clk,if_flush,hazard,if_ins,id_ins,PC_plus_4,id_PC_plus_4);
  assign id_op    = id_ins[31:26];
  assign id_Ra    = id_ins[25:21];
  assign id_Rb    = id_ins[20:16];
  assign id_Rw    = id_ins[15:11];
  assign id_imm16 = id_ins[15:0];
	//get ctrl
	ctrl	a_ctrl(.clk(clk), .op(id_ins[31:26]), .func(id_ins[5:0]), .RegWr(id_RegWr), .RegDst(id_RegDst), .ExtOp(id_ExtOp), 
               .ALUsrc(id_ALUsrc), .Branch(id_Branch), .Jump(id_Jump), .ALUctr(id_ALUctr), .MemWr(id_MemWr), .MemtoReg(id_MemtoReg));
  //hazard(lw)
  HazardDetectionUnit a_HazardDetectionUnit(ex_MemtoReg&ex_RegWr,ex_Rw_mux2,id_Ra,id_Rb,hazard);//ex_Rw_mux2为目的操作数！,ex_MemtoReg为数据内存写入寄存器
	
	//register file
	rf a_rf(.Clk(clk), .WrEn(wr_RegWr), .Ra(id_Ra), .Rb(id_Rb), .Rw(wr_Rw), 
          .busW(wr_busW), .busA(id_busA), .busB(id_busB), .ex_Ra(ex_Ra), .ex_Rb(ex_Rb), .ex_busA(ex_busA), .ex_busB(ex_busB));
	//Sign-extend
	SignExt16 a_SignExt16(.ExtOp(id_ExtOp), .a(id_imm16), .y(id_imm16Ext));

  //lw紧接branch的情况，需要对busA,busB进行选择,仅对a_BranchOrNot有效
  MUX2 a_MUX2_id_busA(id_busA,mem_dout,mem_RegWr && mem_MemtoReg && (mem_Rw == id_Ra),id_busA_mux2);
  MUX2 a_MUX2_id_busB(id_busB,mem_dout,mem_RegWr && mem_MemtoReg && (mem_Rw == id_Rb),id_busB_mux2);
  //branchOrNot
  branchOrNot a_BranchOrNot(id_busA_mux2,id_busB_mux2,id_Branch,if_flush);
  //get npc
  //如果上一指令是branch，且要跳转，则 npc = 跳转地址
  //如果not(上一指令是branch，且要跳转) && if_ins[31:26] == 6'b000010，则npc = 下一指令
  npc a_npc(id_imm16,if_flush,(if_ins[31:26] == 6'b000010),if_ins[25:0],PC,NPC);//if.jump
 	//id_ex
  //ex_op是为了保证  不是R指令的情况下，forwardB 必取2’b00（对于alu的busB而言）
  //而传下的ex_busB_pushDown的值是不包括imm16Ext的
	id_ex a_id_ex(clk,hazard,id_op,id_PC_plus_4,id_busA,id_busB,id_Ra,id_Rb,id_Rw,id_imm16Ext,id_RegWr,id_RegDst,id_ALUsrc,id_Branch,id_Jump,id_MemWr,id_MemtoReg,id_ALUctr,
                ex_op,ex_PC_plus_4,ex_Ra,ex_Rb,ex_Rw,ex_imm16Ext,ex_RegWr,ex_RegDst,ex_ALUsrc,ex_Branch,ex_Jump,ex_MemWr,ex_MemtoReg,ex_ALUctr);
  
  MUX2 #5 a_MUX2_RegDst(ex_Rb, ex_Rw, ex_RegDst, ex_Rw_mux2);//!!!!ex_Rw_mux2为目的操作数！
  //forwardingUnit
  forwardingUnit a_forwardingUnit(ex_Ra,ex_Rb,mem_Rw,mem_RegWr,wr_Rw,wr_RegWr,forwardA,forwardB,ex_op);
  
  MUX3  a_MUX3_alu_busA(ex_busA,wr_busW,mem_alu_result,forwardA,ex_alu_busA);//此处的ex_busA应该从寄存器中读取

  MUX2  a_MUX2_ALUsrc(ex_busB, ex_imm16Ext, ex_ALUsrc, ex_busB_mux2);//此处的ex_busB应该从寄存器中读取
  //MUX3  a_MUX3_alu_busB(ex_busB_mux2,wr_busW,mem_alu_result,forwardB,ex_alu_busB);
  //不是R指令，则ex_alu_busB = imm16Ext
  MUX3  a_MUX3_ex_busB_pushDown(ex_busB,wr_busW,mem_alu_result,forwardB,ex_busB_pushDown);
  assign ex_alu_busB = ( ex_op == 6'd0) ? ((forwardB == 2'b00) ? ex_busB : (forwardB == 2'b01) ? wr_busW : mem_alu_result) : ex_imm16Ext;

  //MUX3  a_MUX3_ex_busB_pushDown(ex_busB,wr_busW,mem_alu_result,forwardB);
  //alu 
	ALU	a_ALU(ex_alu_busA, ex_alu_busB, ex_ALUctr, ex_Zero, ex_alu_result);
	//ex_mem  应该是ex_alu_busB传下去的
	ex_mem a_ex_mem(clk,ex_Zero,ex_alu_result,ex_busB_pushDown,ex_Rw_mux2,ex_RegWr,ex_Branch,ex_Jump,ex_MemWr,ex_MemtoReg,
            mem_Zero,mem_alu_result,mem_busB,mem_Rw,mem_RegWr,mem_Branch,mem_Jump,mem_MemWr,mem_MemtoReg);
        
	//dm
	dm_4k	a_dm_4k(.addr(mem_alu_result[11:2]), .din(mem_busB), .we(mem_MemWr), .clk(clk), .dout(mem_dout));
	
	mem_wr a_mem_wr(clk,mem_dout,mem_alu_result,mem_Rw,mem_RegWr,mem_Jump,mem_MemtoReg,
              wr_dout,wr_alu_result,wr_Rw,wr_RegWr,wr_Jump,wr_MemtoReg);
	MUX2	a_MUX2_wr_busW(wr_alu_result, wr_dout,wr_MemtoReg, wr_busW);
endmodule
