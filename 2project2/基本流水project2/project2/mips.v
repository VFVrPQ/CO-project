module mips(clk, rst) ;
	input	clk ;   // clock
	input	rst ;// reset

	wire[31:2]  NPC;
  wire[31:2]  PC;
  wire[31:2]  PC_plus_4;
	
	wire[31:0]  ins;
	//id
  wire[31:2]  id_PC_plus_4;
  wire[31:0]  id_busA;
  wire[31:0]  id_busB;
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
  wire[31:2]  ex_PC_br;
  wire        ex_Zero;
  wire[31:0]  ex_alu_result;
  wire[31:0]  ex_busA;
  wire[31:0]  ex_busB;
  wire[31:0]  ex_busB_mux2;
  wire[4:0]   ex_Rb;
  wire[4:0]   ex_Rw;
  wire[4:0]   ex_Rw_mux2;

  wire        ex_RegWr;
  wire        ex_RegDst;
  wire        ex_ALUsrc;
  wire        ex_Branch;
  wire        ex_Jump;
  wire        ex_MemWr;
  wire        ex_MemtoReg;
  wire[2:0]   ex_ALUctr;

  wire[31:0]  ex_imm16Ext;
  wire[31:2]  ex_PC_plus_4;
  //mem
  wire[31:0]  mem_dout;
  wire[31:0]  mem_alu_result;
  wire[4:0]   mem_Rw;
  wire[31:2]  mem_PC_br;
  wire[31:0]  mem_busB;
  
    //control
  wire      mem_RegWr;
  wire      mem_Branch;
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
  wire        wr_RegWr;
  wire        wr_Jump;
  wire        wr_MemtoReg;
     
	//get pc
	pc 	a_pc( .NPC(NPC), .Clk(clk), .Reset(rst), .PC(PC) );
	//get pc_plus_4
	assign PC_plus_4 = PC + 1;
	//get instruction
	im_4k 	a_im_4k( .addr(PC[11:2]), .dout(ins));
	//get ctrl
	ctrl	a_ctrl(.clk(clk), .op(ins[31:26]), .func(ins[5:0]), .RegWr(id_RegWr), .RegDst(id_RegDst), .ExtOp(id_ExtOp), .ALUsrc(id_ALUsrc), .Branch(id_Branch), .Jump(id_Jump), .ALUctr(id_ALUctr), .MemWr(id_MemWr), .MemtoReg(id_MemtoReg));
	//if_id
	if_id a_if_id(.Clk(clk), .ins(ins), .PC_plus_4(PC_plus_4), .Ra(id_Ra), .Rb(id_Rb), .Rw(id_Rw), .imm16(id_imm16), .id_PC_plus_4(id_PC_plus_4) );
	//register file
	rf	a_rf(.Clk(clk), .WrEn(wr_RegWr), .Ra(id_Ra), .Rb(id_Rb), .Rw(wr_Rw), .busW(wr_busW), .busA(id_busA), .busB(id_busB));
	//Sign-extend
	SignExt16 a_SignExt16(.ExtOp(id_ExtOp), .a(id_imm16), .y(id_imm16Ext));
	//id_ex
	id_ex a_id_ex(clk,id_PC_plus_4,id_busA,id_busB,id_Rb,id_Rw,id_imm16Ext,id_RegWr,id_RegDst,id_ALUsrc,id_Branch,id_Jump,id_MemWr,id_MemtoReg,id_ALUctr,
            ex_PC_plus_4,ex_busA,ex_busB,ex_Rb,ex_Rw,ex_imm16Ext,ex_RegWr,ex_RegDst,ex_ALUsrc,ex_Branch,ex_Jump,ex_MemWr,ex_MemtoReg,ex_ALUctr);
  //ex_add_result = ex_PC_br 
  assign ex_PC_br = ex_imm16Ext[29:0] + ex_PC_plus_4[31:2] ;
 
  //alu 
	MUX2	a_MUX2_ALUsrc(ex_busB, ex_imm16Ext, ex_ALUsrc, ex_busB_mux2);
	ALU	a_ALU(ex_busA, ex_busB_mux2, ex_ALUctr, ex_Zero, ex_alu_result);
	 
	MUX2 #5 a_MUX2_RegDst(ex_Rb, ex_Rw, ex_RegDst, ex_Rw_mux2);
	//ex_mem
	ex_mem a_ex_mem(clk,ex_PC_br,ex_Zero,ex_alu_result,ex_busB,ex_Rw,ex_RegWr,ex_Branch,ex_Jump,ex_MemWr,ex_MemtoReg,
            mem_PC_br,mem_Zero,mem_alu_result,mem_busB,mem_Rw,mem_RegWr,mem_Branch,mem_Jump,mem_MemWr,mem_MemtoReg);
        
  //MUX2 #30 a_MUX2_NPC(PC_plus_4, mem_PC_br, mem_Branch&mem_Zero, NPC);
  assign NPC = PC_plus_4 ;
	//dm
	dm_4k	a_dm_4k(.addr(mem_alu_result[11:2]), .din(mem_busB), .we(mem_MemWr), .clk(clk), .dout(mem_dout));
	
	mem_wr a_mmem_wr(clk,mem_dout,mem_alu_result,mem_Rw,mem_RegWr,mem_Jump,mem_MemtoReg,
              wr_dout,wr_alu_result,wr_Rw,wr_RegWr,wr_Jump,wr_MemtoReg);
	MUX2	a_MUX2_wr_busW(wr_alu_result, wr_dout,wr_MemtoReg, wr_busW);
endmodule
