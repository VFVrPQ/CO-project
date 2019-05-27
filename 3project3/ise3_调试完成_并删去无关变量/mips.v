`timescale 1ns / 1ps
module mips(             // 带冒险的流水线，支持loongson的45条指令
    input clk,           // 时钟
    input resetn,        // 复位信号，低电平有效
    
    //display data
    input  [ 4:0] rf_addr,
    input  [31:0] mem_addr,
    output [31:0] rf_data,
    output [31:0] mem_data,
    output [31:0] IF_pc,
    output [31:0] IF_inst,
    output [31:0] ID_pc,
    output [31:0] EXE_pc,
    output [31:0] MEM_pc,
    output [31:0] WB_pc,
    
    //5级流水新增
    output [31:0] cpu_5_valid,
    output [31:0] HI_data,
    output [31:0] LO_data
    );
  
//begin
  wire[31:2]  NPC;
  wire[31:2]  PC;
  wire[31:2]  PC_plus_4;
  
  wire[31:0]  if_ins;

  wire        Branch_ok;
  wire        BranchBubble;

  wire        R31Wr;
  //*************id**************//
  wire[31:0]  id_ins;
  wire[31:2]  id_PC_plus_4;
  wire[31:0]  id_busA, id_busA_mux2;
  wire[31:0]  id_busB, id_busB_mux2;
  wire[4:0]   id_Ra;
  wire[4:0]   id_Rb;
  wire[4:0]   id_Rw;
  wire[31:0]  id_imm16Ext;
  wire[15:0]  id_imm16;
  wire[4:0]   id_shf;
  //control
  wire        id_RegWr;
  wire        id_RegDst;
  wire        id_ExtOp;
  wire        id_ALUsrc;
  wire[2:0]   id_Branch;
  wire[1:0]   id_Jump;
  wire[1:0]   id_MemWr;
  wire        id_MemtoReg;
  wire[3:0]   id_ALUctr;
  wire[1:0]   id_MemRead;
  wire        id_ALUshf; //判断是否移位的信号，造成的影响是busA和busB要进行选择
  
  //----{id_mul}begin
  wire        id_mulCtr;
  wire[1:0]   id_regToMul;
  wire        id_mulToReg;
  wire        id_mulRead;
  //----{id_mul}end
  //----{id_cp0}begin
  wire[2:0]   id_cp0Op;
  wire[2:0]   id_sel;
  wire[4:0]   id_cs;
  wire[31:2]  id_PC;
  //----{id_cp0}end

  //***************ex****************//
  wire[31:0]  ex_busB_mux3;
  wire        ex_Zero;
  wire[31:0]  ex_alu_result;
  wire[31:0]  ex_busA;
  wire[31:0]  ex_busB;
  wire[4:0]   ex_Ra;
  wire[4:0]   ex_Rb;
  wire[4:0]   ex_Rw;
  wire[4:0]   ex_Rw_mux2;
  wire[4:0]   ex_shf;
  wire[31:0]  ex_shfExt;
  //control
  wire        ex_RegWr;
  wire        ex_RegDst;//Rt,Rd选择目的寄存器
  wire        ex_ALUsrc;
  wire[1:0]   ex_MemWr;
  wire        ex_MemtoReg;
  wire[3:0]   ex_ALUctr;
  wire[1:0]   ex_MemRead;
  wire        ex_ALUshf;

  wire[31:0]  ex_imm16Ext;
  wire[31:0]  ex_busA_mux3;
  wire[31:0]  ex_alu_busA;
  wire[31:0]  ex_alu_busB;
  wire[63:0]  ex_mul_result;

  //----{ex_mul}begin
  wire        ex_mulCtr;
  wire[1:0]   ex_regToMul;
  wire        ex_mulToReg;
  wire        ex_mulRead;
  //----{ex_mul}end
  //----{ex_cp0}begin
  wire[2:0]   ex_cp0Op;
  wire[2:0]   ex_sel;
  wire[4:0]   ex_cs;
  wire[31:2]  ex_PC;
  //----{ex_cp0}end

  //*************mem***************//
  wire[31:0]  mem_dout;
  wire[31:0]  mem_alu_result;
  wire[4:0]   mem_Rw;
  wire[31:0]  mem_busB;
  
  //***control***//
  wire      mem_RegWr;
  wire[1:0] mem_MemWr;
  wire      mem_MemtoReg;
  wire      mem_Zero;
  wire[1:0] mem_MemRead;

  //----{mem_mul}begin
  wire[31:0]  mem_busA;
  wire[63:0]  mem_mul_result;
  wire[ 1:0]  mem_regToMul;
  wire        mem_mulToReg;
  wire        mem_mulRead;
  //----{mem_mul}end
  //----{mem_cp0}begin
  wire[2:0]   mem_cp0Op;
  wire[2:0]   mem_sel;
  wire[4:0]   mem_cs;
  wire[31:2]  mem_PC;
  //----{mem_cp0}end

  //*****************wr***********//
  wire[31:0]  wr_dout;
  wire[31:0]  wr_alu_result;
  wire[ 4:0]  wr_Rw;
  wire[31:0]  wr_busW;
  //***control***//
  wire        wr_RegWr;//寄存器堆写使能有效
  wire        wr_MemtoReg;//写入存储器的数据来自 ALU或者数据存储器

  //----{wr_mul}begin
    wire[31:0]  wr_busA;
    wire[63:0]  wr_mul_result;
    wire[ 1:0]  wr_regToMul;
    wire        wr_mulToReg;
    wire        wr_mulRead;

    wire[31:0]  HI_LOout;
    wire[31:0]  wr_busW_mux2_dout;
    wire[31:0]  wr_busW_mux_HI_LOout;
  //----{wr_mul}end       
  //----{wr_cp0}begin
    wire[ 4:0]  wr_cs;
    wire[ 2:0]  wr_sel;
    wire[31:0]  wr_busB;
    wire[ 2:0]  wr_cp0Op;
    wire[31:2]  wr_PC;  
  //----{wr_cp0}end

  //*****forwardingUnit****//
  wire[1:0]   forwardA;
  wire[1:0]   forwardB;
  //*****hazard*****//
  wire        hazard;

  //----{cp0}begin
  wire        cp0Bubble;
  wire[31:0]  cp0OutToReg;
  wire[31:0]  cp0OutToPC;
  wire[ 1:0]  cp0Forward;
  wire[31:0]  PC_cp0_mux3;
  //----{cp0}end

//----{link to ISE}begin
  wire  rst;
  wire  if_valid;
  wire  id_valid;
  wire  ex_valid;
  wire  mem_valid;
  wire  wr_valid;
  
  assign rst         = ~resetn;// 重置信号取反， 因为之前写的mips的reset信号相反
  assign IF_inst     = if_ins;
  assign IF_pc       = {PC,    2'd0};
  assign ID_pc       = {id_PC, 2'd0};
  assign EXE_pc      = {ex_PC, 2'd0};
  assign MEM_pc      = {mem_PC,2'd0};
  assign WB_pc       = {wr_PC, 2'd0};
  assign cpu_5_valid = { 12'd0, {4{if_valid}}, {4{id_valid}}, {4{ex_valid}}, {4{mem_valid}}, {4{wr_valid}} };
//----{link to ISE}end

  //----{IF}begin
    //********************PC********************//
    pc  a_pc( .NPC(NPC), .Clk(clk), .Reset(rst), .PC(PC) , .hazard(hazard), .BranchBubble(BranchBubble) , 
              .cp0Bubble(cp0Bubble), .if_valid(if_valid));


    npc a_npc( .PC_plus_4(PC_plus_4),                              .PC_br(id_PC_plus_4[31:2]+ id_imm16Ext[29:0]), 
               .PC_jump01({ id_PC_plus_4[31:28] , id_ins[25:0] }), .PC_jump10(id_busA_mux2[31:2]),            
               .Branch_ok(Branch_ok),                              .Jump(id_Jump),
               .NPC(NPC),
               .PC_cp0_mux3(PC_cp0_mux3[31:2]),                    .cp0Forward(cp0Forward));

    //***********CP0ForwardingUnit***********// 包括SYSCALL，虽然不是转发，为了简单写在一起
    CP0ForwardingUnit a_CP0ForwardingUnit( .id_cp0Op(id_cp0Op), .ex_cs(ex_cs),     .ex_sel(ex_sel),       .ex_cp0Op(ex_cp0Op),
                                           .mem_cs(mem_cs),     .mem_sel(mem_sel), .mem_cp0Op(mem_cp0Op), .cp0Forward(cp0Forward) );

    //*************选择cp0赋值给NPC的信号*****//
    MUX3 a_MUX3_cp0OutToPC( cp0OutToPC, ex_busB_mux3, mem_busB, cp0Forward, PC_cp0_mux3);

    assign PC_plus_4 = PC + 1;

    //********************IM********************//
    im_4k   a_im_4k( .addr(PC[31:2]), .dout(if_ins));
  //----{IF}end

  //********************IF_ID*****************//
  if_id a_if_id(clk,       rst,          id_Jump,      Branch_ok,    hazard, if_ins, id_ins,
                PC_plus_4, id_PC_plus_4, BranchBubble, 
                //----{cp0}begin
                PC,        id_PC,        id_cp0Op,     cp0Bubble,
                //----{cp0}end 
                //----{ISE}begin
                id_valid
                //----{ISE}end
                ); 

  //----{ID}begin
    assign id_Ra     = id_ins[25:21];
    assign id_Rb     = id_ins[20:16];
    assign id_Rw     = id_ins[15:11];
    assign id_imm16  = id_ins[15: 0];
    assign id_shf    = id_ins[10: 6];

    //----{cp0}begin
    assign id_cs     = id_ins[15:11];
    assign id_sel    = id_ins[ 2: 0];
    //----{cp0}end 

    //********************CTRL******************//
    ctrl  a_ctrl(.clk(clk),          .op(id_ins[31:26]),    .func(id_ins[5:0]),  .ALUctr(id_ALUctr),
                 .Branch(id_Branch), .Jump(id_Jump),        .RegDst(id_RegDst),  .ALUsrc(id_ALUsrc),   .MemtoReg(id_MemtoReg), 
                 .RegWr(id_RegWr),   .MemWr(id_MemWr),      .ExtOp(id_ExtOp),    .MemRead(id_MemRead), .ALUshf(id_ALUshf), 
                 .R31Wr(R31Wr),      .Rb(id_Rb),            .cp0Op(id_cp0Op) );

    //****************MUL_CTRL******************//
    MulCtrl a_MulCtrl( .ins(id_ins), .mulCtr(id_mulCtr), .regToMul(id_regToMul), .mulToReg(id_mulToReg), .mulRead(id_mulRead) );

    //****************CP0_CTRL******************//
    Cp0Ctrl a_Cp0Ctrl( .ins(id_ins), .cp0Op(id_cp0Op) );

    //**************REGISTER_FILE***************//
    rf a_rf(.Clk(clk),      .WrEn(wr_RegWr), .Ra(id_Ra),     .Rb(id_Rb),    .Rw(wr_Rw), 
            .busW(wr_busW), .busA(id_busA),  .busB(id_busB), .R31Wr(R31Wr), .R31(id_PC_plus_4 + 30'b1),//B_PC+1
            //----{link to ise}begin
            .rf_addr(rf_addr), .rf_data(rf_data)
            //----{link to ise}end
            );

    //***************SIGN_EXTENDED**************//
    SignExt16 a_SignExt16(.ExtOp(id_ExtOp), .a(id_imm16), .y(id_imm16Ext));
    
    //***********BranchForwardingUnit***********//
    BranchForwardingUnit a_BranchForwardingUnit( 
                          .id_Ra(id_Ra),         .id_Rb(id_Rb), .mem_Rw(mem_Rw), 
                          .mem_RegWr(mem_RegWr), .mem_MemtoReg(mem_MemtoReg),
                          .BranchForwardA(BranchForwardA),
                          .BranchForwardB(BranchForwardB));

    MUX2 a_MUX2_id_busA(id_busA, mem_alu_result, BranchForwardA, id_busA_mux2);
    MUX2 a_MUX2_id_busB(id_busB, mem_alu_result, BranchForwardB, id_busB_mux2);
    
    //该模块不需要用到
    //***********branchOrNot***********//Branch_ok=1表示需要跳转，=0表示不需要跳转
    branchOrNot a_BranchOrNot(id_busA_mux2,id_busB_mux2,id_Branch,Branch_ok);
    
    //*************BranchBubbleUnit************//
    BranchBubbleUnit a_BranchBubbleUnit( .id_Ra(id_Ra),      .id_Rb(id_Rb),               .ex_RegWr(ex_RegWr), 
                                         .ex_Rw(ex_Rw_mux2), .mem_RegWr(mem_RegWr),       .mem_MemtoReg(mem_MemtoReg), 
                                         .mem_Rw(mem_Rw),    .BranchBubble(BranchBubble), .id_Branch(id_Branch),
                                         .id_Jump(id_Jump) );

    //*************Cp0BubbleUnit************//
    Cp0BubbleUnit a_Cp0BubbleUnit(       .id_Ra(id_Ra),      .id_Rb(id_Rb),               .ex_cp0Op(ex_cp0Op),
                                         .ex_Rw(ex_Rw_mux2), .mem_Rw(mem_Rw),             .mem_cp0Op(mem_cp0Op),
                                         .cp0Bubble(cp0Bubble) );

    //*******************HAZARD(lw)*************//
    HazardDetectionUnit a_HazardDetectionUnit(ex_MemtoReg&ex_RegWr,ex_Rw_mux2,id_Ra,id_Rb,hazard);//ex_Rw_mux2为目的操作数！,ex_MemtoReg为数据内存写入寄存器
  //----{ID}end
  
  
  //*****************ID_EX******************//
  id_ex a_id_ex(clk,          hazard,      BranchBubble, id_busA,     id_busB,     
                id_Ra,        id_Rb,       id_Rw,        id_imm16Ext, id_RegWr,     
                id_RegDst,    id_ALUsrc,   id_MemWr,     id_MemtoReg, id_ALUctr, id_MemRead, id_shf, id_ALUshf,
                ex_busA,      ex_busB,
                ex_Ra,        ex_Rb,       ex_Rw,        ex_imm16Ext, ex_RegWr,    
                ex_RegDst,    ex_ALUsrc,   ex_MemWr,     ex_MemtoReg, ex_ALUctr, ex_MemRead, ex_shf, ex_ALUshf,
                //----{mul}begin
                id_mulCtr,    id_regToMul, id_mulToReg,  id_mulRead,
                ex_mulCtr,    ex_regToMul, ex_mulToReg,  ex_mulRead,
                //----{mul}end

                //----{cp0}begin
                id_cs,        id_sel,      id_cp0Op,     id_PC,
                ex_cs,        ex_sel,      ex_cp0Op,     ex_PC,
                cp0Bubble,
                //----{cp0}end
                //----{ISE}begin
                id_valid,     ex_valid
                //----{ISE}end
                );
  
  
  
  //----{EX}begin
    MUX2 #5 a_MUX2_RegDst(ex_Rb, ex_Rw, ex_RegDst, ex_Rw_mux2);//!!!!ex_Rw_mux2为目的操作数！

    //*************ForwardingUint***************//
    forwardingUnit a_forwardingUnit(ex_Ra, ex_Rb,    mem_Rw,   mem_RegWr,
                                    wr_Rw, wr_RegWr, forwardA, forwardB);
    
    //***********ext shf***********************//
    SignExt5 a_SignExt5(.a(ex_shf), .y(ex_shfExt));

    //**************MUX_BusA***************//
    MUX3  a_MUX3_alu_busA(ex_busA, wr_busW, mem_alu_result, forwardA, ex_busA_mux3);
    MUX2  a_MUX2_ALUshf_busA(ex_busA_mux3, ex_shfExt, ex_ALUshf, ex_alu_busA);

    //**************MUX_BusB***************//
    MUX3  a_MUX3_alu_busB(ex_busB, wr_busW, mem_alu_result, forwardB, ex_busB_mux3);//传到下一阶段的busB
    MUX2  a_MUX2_ALUsrc(ex_busB_mux3, ex_imm16Ext, ex_ALUsrc, ex_alu_busB);

    //*****************ALU*********************// 
    ALU a_ALU(ex_alu_busA, ex_alu_busB, ex_ALUctr, ex_Zero, ex_alu_result);

    //*****************MULU********************//
    MULU a_MULU(ex_mulCtr, ex_busA_mux3, ex_busB_mux3, ex_mul_result);

  //----{EX}end

  //ex_mem  应该是ex_busB_mux3传下去的
  //*****************EX_MEM******************// 
  ex_mem a_ex_mem( clk,          ex_Zero,        ex_alu_result, ex_busB_mux3,     ex_Rw_mux2,
                   ex_RegWr,     ex_MemWr,       ex_MemtoReg,   mem_Zero,         mem_alu_result,
                   mem_busB,     mem_Rw,         mem_RegWr,     mem_MemWr,        mem_MemtoReg,
                   ex_MemRead,   mem_MemRead,
                   //----{mul}begin
                   ex_busA_mux3, ex_mul_result,  ex_regToMul,   ex_mulToReg,      ex_mulRead,
                   mem_busA,     mem_mul_result, mem_regToMul,  mem_mulToReg,     mem_mulRead,
                   //----{mul}end
                   //----{cp0}begin
                   ex_cs,        ex_sel,         ex_cp0Op,      ex_PC,
                   mem_cs,       mem_sel,        mem_cp0Op,     mem_PC,
                   //----{cp0}end
                   //----{ISE}begin
                   ex_valid,     mem_valid
                   //----{ISE}end
                   );
        
  //----{mem}begin

  //****************龙芯内核的dm仅sw比正常多一个周期，但不需要阻塞**************//
  //****************DM***********************//
  wire [ 3:0] dm_wen ; 
  wire [31:0] dina;
  wire [31:0] douta;
  wire [ 1:0] dm_addr;

  assign dm_addr= mem_alu_result[1:0];
  assign dm_wen = ((mem_MemWr == 2'b01                      ) ? 4'b1111  :
                  ((mem_MemWr == 2'b10 && dm_addr   == 2'b00) ? 4'b0001  :
                  ((mem_MemWr == 2'b10 && dm_addr   == 2'b01) ? 4'b0010  :
                  ((mem_MemWr == 2'b10 && dm_addr   == 2'b10) ? 4'b0100  :  
                  ((mem_MemWr == 2'b10 && dm_addr   == 2'b11) ? 4'b1000  : 4'b0000)))));

  assign dina   = ((mem_MemWr == 2'b01                      ) ? mem_busB :
                  ((mem_MemWr == 2'b10 && dm_addr   == 2'b00) ? {24'b0, mem_busB[7:0]}        :
                  ((mem_MemWr == 2'b10 && dm_addr   == 2'b01) ? {16'b0, mem_busB[7:0], 8'b0}  :
                  ((mem_MemWr == 2'b10 && dm_addr   == 2'b10) ? { 8'b0, mem_busB[7:0], 16'b0} :  
                  ((mem_MemWr == 2'b10 && dm_addr   == 2'b11) ? {mem_busB[7:0], 24'b0}        : mem_busB)))));

    data_ram data_ram_module(   // Êý¾Ý´æ´¢Ä£¿é
        .clka   (clk         ),  // I, 1,  Ê±ÖÓ
        .wea    (dm_wen      ),  // I, 1,  Ð´Ê¹ÄÜ
        .addra  (mem_alu_result[9:2]),  // I, 8,  ¶ÁµØÖ·
        .dina   (dina        ),  // I, 32, Ð´Êý¾Ý
        .douta  (douta       ),  // O, 32, ¶ÁÊý¾Ý

        //display mem
        .clkb   (clk          ),  // I, 1,  Ê±ÖÓ
        .web    (4'd0         ),  // ²»Ê¹ÓÃ¶Ë¿Ú2µÄÐ´¹¦ÄÜ
        .addrb  (mem_addr[9:2]),  // I, 8,  ¶ÁµØÖ·
        .doutb  (mem_data     ),  // I, 32, Ð´Êý¾Ý
        .dinb   (32'd0        )   // ²»Ê¹ÓÃ¶Ë¿Ú2µÄÐ´¹¦ÄÜ
    );
    assign mem_dout = ( (mem_MemRead == 2'b01)                     ?                   douta         : 
                      ( (mem_MemRead == 2'b10 && dm_addr == 2'b00) ? {{24{douta[ 7]}}, douta[ 7: 0]} : 
                      ( (mem_MemRead == 2'b10 && dm_addr == 2'b01) ? {{24{douta[15]}}, douta[15: 8]} :   
                      ( (mem_MemRead == 2'b10 && dm_addr == 2'b10) ? {{24{douta[23]}}, douta[23:16]} :     
                      ( (mem_MemRead == 2'b10 && dm_addr == 2'b11) ? {{24{douta[31]}}, douta[31:24]} :     
                      ( (mem_MemRead == 2'b11 && dm_addr == 2'b00) ? { 24'b0,          douta[ 7: 0]} : 
                      ( (mem_MemRead == 2'b11 && dm_addr == 2'b01) ? { 24'b0,          douta[15: 8]} :   
                      ( (mem_MemRead == 2'b11 && dm_addr == 2'b10) ? { 24'b0,          douta[23:16]} :     
                      ( (mem_MemRead == 2'b11 && dm_addr == 2'b11) ? { 24'b0,          douta[31:24]} : 32'd0
                      )))))))));
  //----{mem}end

  //*****************MEM_WR******************// 
  mem_wr a_mem_wr( clk,          mem_dout, mem_alu_result, mem_Rw, mem_RegWr, 
                   mem_MemtoReg, wr_dout,  wr_alu_result,  wr_Rw,  wr_RegWr, 
                   wr_MemtoReg,
                   //----{mul}begin
                   mem_busA,     mem_mul_result, mem_regToMul,     mem_mulToReg,  mem_mulRead,
                   wr_busA,      wr_mul_result,  wr_regToMul,      wr_mulToReg,   wr_mulRead,
                   //----{mul}end
                   //----{cp0}begin
                   mem_cs,       mem_sel,        mem_busB,         mem_cp0Op,     mem_PC,
                   wr_cs,        wr_sel,         wr_busB,          wr_cp0Op,      wr_PC,
                   //----{cp0}end
                   //----{ISE}begin
                   mem_valid,     wr_valid
                   //----{ISE}end
                   );
  //----{WR}begin
    //****************HI_LO********************//
    HI_LO a_HI_LO( clk, wr_regToMul, wr_mulToReg, wr_mulRead, wr_busA, wr_mul_result, HI_LOout, HI_data, LO_data );

    //****************CP0*********************//
    CP0 a_CP0( .clk(clk),                 .cs(wr_cs),              .sel(wr_sel), .busB(wr_busB), .cp0Op(wr_cp0Op), 
               .cp0OutToReg(cp0OutToReg), .cp0OutToPC(cp0OutToPC), .PC(wr_PC) );

    //****************选择wr_busW*************//
    MUX2  a_MUX2_wr_dout(    wr_alu_result,        wr_dout,     wr_MemtoReg,                        wr_busW_mux2_dout);
    MUX2  a_MUX2_wr_HI_LOout(wr_busW_mux2_dout,    HI_LOout,    wr_mulToReg,                        wr_busW_mux_HI_LOout);
    MUX2  a_MUX2_wr_busW(    wr_busW_mux_HI_LOout, cp0OutToReg, ((wr_cp0Op==3'b001) ? 1'b1 : 1'b0), wr_busW);
  //----{WR}end
endmodule
