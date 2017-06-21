module mips(clk, rst) ;
	input	clk ;   // clock
	input	rst ;// reset

	wire[31:2]  NPC;
  wire[31:2]  PC;
  wire[31:2]  PC_plus_4;
	
	wire[31:0]  if_ins;

  wire        Branch_ok;
  wire        BranchBubble;
	//id
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
  wire[31:0]  ex_busB_pushDown;
  wire        ex_Zero;
  wire[31:0]  ex_alu_result;
  wire[31:0]  ex_busA;
  wire[31:0]  ex_busB;
  wire[4:0]   ex_Ra;
  wire[4:0]   ex_Rb;
  wire[4:0]   ex_Rw;
  wire[4:0]   ex_Rw_mux2;

  wire        ex_RegWr;
  wire        ex_RegDst;//Rt,Rd选择目的寄存器
  wire        ex_ALUsrc;
  wire        ex_MemWr;
  wire        ex_MemtoReg;
  wire[2:0]   ex_ALUctr;

  wire[31:0]  ex_imm16Ext;
  wire[31:0]  ex_alu_busA;
  wire[31:0]  ex_alu_busB;
  //mem
  wire[31:0]  mem_dout;
  wire[31:0]  mem_alu_result;
  wire[4:0]   mem_Rw;
  wire[31:0]  mem_busB;
  
    //control
  wire      mem_RegWr;
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
  wire        wr_MemtoReg;//写入存储器的数据来自 ALU或者数据存储器
  //forwardingUnit
  wire[1:0]   forwardA;
  wire[1:0]   forwardB;
  //hazard
  wire        hazard;

	//********************PC********************//
	pc 	a_pc( .NPC(NPC), .Clk(clk), .Reset(rst), .PC(PC) , .hazard(hazard), .BranchBubble(BranchBubble));
  npc a_npc(id_imm16Ext, Branch_ok, id_Jump, id_ins[25:0], PC, NPC);
	assign PC_plus_4 = PC + 1;

	//********************im********************//
	im_4k 	a_im_4k( .addr(PC[31:2]), .dout(if_ins));

  //********************IF_ID*****************//
  if_id a_if_id(clk, id_Jump, Branch_ok, hazard, if_ins, id_ins,
                PC_plus_4, id_PC_plus_4, BranchBubble); 
  assign id_Ra    = id_ins[25:21];
  assign id_Rb    = id_ins[20:16];
  assign id_Rw    = id_ins[15:11];
  assign id_imm16 = id_ins[15:0];
	
  //********************CTRL******************//
	ctrl	a_ctrl(.clk(clk),          .op(id_ins[31:26]), .func(id_ins[5:0]), 
               .RegWr(id_RegWr),   .RegDst(id_RegDst), .ExtOp(id_ExtOp),   
               .ALUsrc(id_ALUsrc), .Branch(id_Branch), .Jump(id_Jump),     
               .ALUctr(id_ALUctr), .MemWr(id_MemWr),   .MemtoReg(id_MemtoReg));

  //**************REGISTER_FILE***************//
  rf a_rf(.Clk(clk),      .WrEn(wr_RegWr), .Ra(id_Ra),     .Rb(id_Rb),    .Rw(wr_Rw), 
          .busW(wr_busW), .busA(id_busA),  .busB(id_busB) );

  //***************SIGN_EXTENDED**************//
  SignExt16 a_SignExt16(.ExtOp(id_ExtOp), .a(id_imm16), .y(id_imm16Ext));

  //*******************HAZARD(lw)*************//
  HazardDetectionUnit a_HazardDetectionUnit(ex_MemtoReg&ex_RegWr,ex_Rw_mux2,id_Ra,id_Rb,hazard);//ex_Rw_mux2为目的操作数！,ex_MemtoReg为数据内存写入寄存器
	
	//***********BranchForwardingUnit***********//
  BranchForwardingUnit a_BranchForwardingUnit( 
                        .id_Ra(id_Ra),         .id_Rb(id_Rb), .mem_Rw(mem_Rw), 
                        .mem_RegWr(mem_RegWr), .mem_MemtoReg(mem_MemtoReg),
                        .BranchForwardA(BranchForwardA),
                        .BranchForwardB(BranchForwardB));

  MUX2 a_MUX2_id_busA(id_busA, mem_alu_result, BranchForwardA, id_busA_mux2);
  MUX2 a_MUX2_id_busB(id_busB, mem_alu_result, BranchForwardB, id_busB_mux2);
  //branchOrNot
  branchOrNot a_BranchOrNot(id_busA_mux2,id_busB_mux2,id_Branch,Branch_ok);
  
  //*************BranchBubbleUnit************//
  BranchBubbleUnit a_BranchBubbleUnit( .id_Ra(id_Ra),      .id_Rb(id_Rb),               .ex_RegWr(ex_RegWr), 
                                       .ex_Rw(ex_Rw_mux2), .mem_RegWr(mem_RegWr),       .mem_MemtoReg(mem_MemtoReg), 
                                       .mem_Rw(mem_Rw),    .BranchBubble(BranchBubble), .id_Branch(id_Branch));
 	
  //*****************ID_EX******************//
	id_ex a_id_ex(clk,          hazard,      BranchBubble, id_busA,     id_busB,     
                id_Ra,        id_Rb,       id_Rw,        id_imm16Ext, id_RegWr,     
                id_RegDst,    id_ALUsrc,   id_MemWr,     id_MemtoReg, id_ALUctr,   
                ex_busA,      ex_busB,
                ex_Ra,        ex_Rb,       ex_Rw,        ex_imm16Ext, ex_RegWr,    
                ex_RegDst,    ex_ALUsrc,   ex_MemWr,     ex_MemtoReg, ex_ALUctr);
  
  MUX2 #5 a_MUX2_RegDst(ex_Rb, ex_Rw, ex_RegDst, ex_Rw_mux2);//!!!!ex_Rw_mux2为目的操作数！

  //*************ForwardingUint***************//
  forwardingUnit a_forwardingUnit(ex_Ra, ex_Rb,    mem_Rw,   mem_RegWr,
                                  wr_Rw, wr_RegWr, forwardA, forwardB);
  
  //**************MUX_BusA_BusB***************//
  MUX3  a_MUX3_alu_busA(ex_busA, wr_busW, mem_alu_result, forwardA, ex_alu_busA);
  MUX3  a_MUX3_alu_busB(ex_busB, wr_busW, mem_alu_result, forwardB, ex_busB_pushDown);//传到阶段的busB
  MUX2  a_MUX2_ALUsrc(ex_busB_pushDown, ex_imm16Ext, ex_ALUsrc, ex_alu_busB);//传到阶段的busB

  //*****************ALU*********************// 
	ALU	a_ALU(ex_alu_busA, ex_alu_busB, ex_ALUctr, ex_Zero, ex_alu_result);

  //ex_mem  应该是ex_alu_busB传下去的
  //*****************EX_MEM******************// 
	ex_mem a_ex_mem( clk,      ex_Zero,  ex_alu_result, ex_busB_pushDown, ex_Rw_mux2,
                   ex_RegWr, ex_MemWr, ex_MemtoReg,   mem_Zero,         mem_alu_result,
                   mem_busB, mem_Rw,   mem_RegWr,     mem_MemWr,        mem_MemtoReg);
        
	//****************DM***********************//
	dm_4k	a_dm_4k( .addr(mem_alu_result[11:2]), .din(mem_busB), .we(mem_MemWr), 
                 .clk(clk),                   .dout(mem_dout));
	
  //*****************MEM_WR******************// 
	mem_wr a_mem_wr( clk,          mem_dout, mem_alu_result, mem_Rw, mem_RegWr, 
                   mem_MemtoReg, wr_dout,  wr_alu_result,  wr_Rw,  wr_RegWr, 
                   wr_MemtoReg);
	MUX2	a_MUX2_wr_busW(wr_alu_result, wr_dout, wr_MemtoReg, wr_busW);
endmodule
