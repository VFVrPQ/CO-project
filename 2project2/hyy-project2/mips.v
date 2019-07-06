
module mips(clk, rst) ; 
input     clk ;   // clock 
input     rst ;// reset 

wire[31:2]  NPC,PC;//+00

//IF
wire[31:0]  IF_ins;

//ID
wire[31:2]  ID_pc;//address of ins
wire[31:0]  ID_ins;
wire[4:0]   ID_Rw;
wire[4:0]   ID_Ra;
wire[4:0]   ID_Rb;
wire[31:0]  ID_busA, ID_busB;
wire[15:0]  ID_imm16;

wire        ID_RegWr;
wire        ID_ExtOp;  
wire        ID_ALUSrc;
wire[1:0]   ID_Jump;
wire[1:0]   ID_MemtoReg;
wire[1:0]   ID_RegDst;
wire[2:0]   ID_MemWr;
wire[2:0]   ID_Branch;
wire[3:0]   ID_ALUctr;

//Ex
wire[31:0]  Ex_ins;
wire[31:2]  Ex_pc;
wire[31:0]  Ex_busA;
wire[31:0]  Ex_busB;
wire[31:0]  Ex_mux3_busA;
wire[31:0]  Ex_mux3_busB;
wire[31:0]  Ex_mux_busBB;
wire[31:0]  Ex_mux_din;
wire[31:0]  Ex_imm16Ext;
wire[15:0]  Ex_imm16;
wire[4:0]   Ex_Rs;
wire[4:0]   Ex_Rt;
wire[4:0]   Ex_Rd;
wire[4:0]   Ex_mux_Rw;
wire        Ex_zero;
wire        Ex_overflow;
wire[31:0]  Ex_aluout;


wire        Ex_ExtOp;  
wire        Ex_ALUSrc;
wire        Ex_RegWr;
wire[1:0]   Ex_Jump;  
wire[1:0]   Ex_MemtoReg;
wire[1:0]   Ex_RegDst;
wire[2:0]   Ex_MemWr;
wire[2:0]   Ex_Branch;
wire[3:0]   Ex_ALUctr;


//Mem
wire[31:0]  Mem_ins;
wire[31:2]  Mem_pc;
wire[4:0]   Mem_Rw;
wire[31:0]  Mem_aluout;
wire[31:0]  Mem_busA;
wire[31:0]  Mem_busB;
wire[31:0]  Mem_dout;
wire[31:0]  Mem_din;

wire[2:0]   Mem_MemWr;
wire[2:0]   Mem_Branch;
wire[1:0]   Mem_MemtoReg;
wire        Mem_zero;
wire        Mem_RegWr;
wire[1:0]   Mem_Jump;
wire        Mem_overflow;

//Wr
wire[31:0]  Wr_ins;
wire[31:2]  Wr_pc;
wire[31:0]  Wr_pc_plus_4;
wire[31:0]  Wr_aluout;
wire[31:0]  Wr_memout;
wire[31:0]  Wr_lui_result;
wire[31:0]  Wr_busW;
wire[4:0]   Wr_Rw;

wire        Wr_RegWr;
wire[1:0]   Wr_MemtoReg;
wire        Wr_Overflow;

//forwarding  solve
wire[1:0]   ALUSrcA;
wire[1:0]   ALUSrcB;
wire[1:0]   ALUSrcDin;

//get pc
pc       a_pc(  .PC(PC), 
                .NPC(NPC), 
                .Clk(clk), 
                .Reset(rst)
             );

/*********IF*********/
//get instruction
im_4k    a_im_4k(   .addr(PC[11:2]), 
                    .dout(IF_ins) 
                );

/*********if_id*********/
//if_id
if_id   a_if_id(    clk,
                    IF_ins,
                    ID_ins,
                    PC,
                    ID_pc,
                    ID_Ra,
                    ID_Rb,
                    ID_Rw,
                    ID_imm16
                );
/*********ID*********/
//get ctrl
ctrl     a_ctrl(    .Clk        (clk),
                    .op         (ID_ins[31:26]),
                    .func       (ID_ins[5:0]), 
                    .RegWr      (ID_RegWr), 
                    .RegDst     (ID_RegDst), 
                    .ExtOp      (ID_ExtOp), 
                    .ALUSrc     (ID_ALUSrc), 
                    .branop     (ID_ins[20:16]), 
                    .Branch     (ID_Branch), 
                    .Jump       (ID_Jump), 
                    .MemWr      (ID_MemWr), 
                    .MemtoReg   (ID_MemtoReg)
                );

ALUctrl  a_ALUctr(  .Clk        (clk),
                    .op         (ID_ins[31:26]), 
                    .func       (ID_ins[5:0]), 
                    .ALUctr     (ID_ALUctr)
                 );

//fetch from register file(xxx-id)&wirte data in(xxx-wr)
rf       a_rf(  .Clk        (clk), 
                .WrEn       (Wr_RegWr&&(!Wr_overflow)), 
                .Ra         (ID_Ra), 
                .Rb         (ID_Rb), 
                .Rw         (Wr_Rw), 
                .busW       (Wr_busW), 
                .busA       (ID_busA), 
                .busB       (ID_busB)
            );

/*********id_ex*********/
//id_ex
id_ex   a_id_ex(    clk,
                    ID_pc,
                    ID_ins,
                    ID_busA,
                    ID_busB,
                    ID_imm16,
                    ID_Ra,
                    ID_Rb,
                    ID_Rw,
                    ID_ExtOp,
                    ID_ALUSrc,
                    ID_RegDst,
                    ID_MemWr,
                    ID_Branch,
                    ID_Jump,
                    ID_MemtoReg,
                    ID_RegWr,
                    ID_ALUctr,
                    Ex_pc,
                    Ex_ins,
                    Ex_busA,
                    Ex_busB,
                    Ex_imm16,
                    Ex_Rs,
                    Ex_Rt,
                    Ex_Rd,
                    Ex_ExtOp,
                    Ex_ALUSrc,
                    Ex_RegDst,
                    Ex_MemWr,
                    Ex_Branch,
                    Ex_Jump,
                    Ex_MemtoReg,
                    Ex_RegWr,
                    Ex_ALUctr
                );

/*********Ex*********/
//get Ex_imm16Ext
ext      #(16,32) a_ext(    .Extop     (Ex_ExtOp), 
                            .a         (Ex_imm16), 
                            .y         (Ex_imm16Ext)
                        );
/*********forwarding*********/
forwarding a_forwarding_alu(   Ex_Rs,
                               Ex_Rt,
                               Mem_Rw,
                               Mem_RegWr,
                               Wr_Rw,
                               Wr_RegWr,
                               ALUSrcA,
                               ALUSrcB,
                               ALUSrcDin
);


//get Ex_mux3_busA
MUX3     a_mux3_busA(    .a(Ex_busA),
                         .b(Mem_aluout),
                         .c(Wr_busW),
                         .ctr(ALUSrcA),
                         .y(Ex_mux3_busA));

//get Ex_mux3_busB
MUX3     a_mux3_busB(    .a(Ex_busB),
                         .b(Mem_aluout),
                         .c(Wr_busW),
                         .ctr(ALUSrcB),
                         .y(Ex_mux3_busB));
//get Ex_mux_busBB
MUX2     a_MUX2_busBB( .a     (Ex_mux3_busB), 
                       .b     (Ex_imm16Ext), 
                       .ctr   (Ex_ALUSrc), 
                       .y     (Ex_mux_busBB));
//get Ex_aluout
ALU      a_ALU  (   .A         (Ex_mux3_busA), 
                    .B         (Ex_mux_busBB), 
                    .C         (Ex_ins[10:6]), 
                    .ALUctr    (Ex_ALUctr), 
                    .zero      (Ex_zero),
                    .overflow  (Ex_overflow), 
                    .result    (Ex_aluout)
                );
//get Mem_din
MUX3     a_MUX2_Mem_din(   .a(Ex_busB),
                           .b(Mem_aluout),
                           .c(Wr_busW),
                           .ctr(ALUSrcDin),
                           .y(Ex_mux_din));

//get address of datain
MUX3    #(5) a_MUX3_Rw (    .a     (Ex_Rt), 
                        .b     (Ex_Rd), 
                        .c     (5'b11111), 
                        .ctr   (Ex_RegDst), 
                        .y     (Ex_mux_Rw)
                    );

/*********ex_mem*********/
ex_mem      a_ex_mem(   clk,
                        Ex_ins,
                        Ex_pc,
                        Ex_zero,
                        Ex_overflow,
                        Ex_aluout,
                        Ex_busA,
                        Ex_mux_din,
                        Ex_mux_Rw,
                        Ex_RegWr,
                        Ex_MemtoReg,
                        Ex_MemWr,
                        Ex_Branch,
                        Ex_Jump,
                        Mem_ins,
                        Mem_pc,
                        Mem_zero,
                        Mem_overflow,
                        Mem_aluout,
                        Mem_busA,
                        Mem_din,
                        Mem_Rw,                        
                        Mem_RegWr,
                        Mem_MemtoReg,
                        Mem_MemWr,
                        Mem_Branch,
                        Mem_Jump
);
/*********Mem*********/
//judge pc_br  or  pc_ju
//get address of branch or jump  
npc     a_npc(      .busA        (Mem_busA), 
                    .imm16       (Mem_ins[15:0]), 
                    .branch      (Mem_Branch), 
                    .zero        (Mem_zero), 
                    .jump        (Mem_Jump), 
                    .target      (Mem_ins[25:0]), 
                    .PC1         (PC), 
                    .PC2         (Mem_pc), 
                    .NPC         (NPC)
            );

//lw.lb.lbu.sw.sb
//dm
dm_4k    a_dm_4k(   .addr         (Mem_aluout[11:0]), 
                    .din          (Mem_din),
                    .we           (Mem_MemWr), 
                    .clk          (clk), 
                    .dout         (Mem_dout)
                );

/*********mem_wr*********/
mem_wr  a_mem_wr(   clk,
                    Mem_pc,
                    Mem_overflow,
                    Mem_dout,
                    Mem_aluout,
                    Mem_ins,
                    Mem_RegWr,
                    Mem_MemtoReg,
                    Mem_Rw,
                    Wr_pc,
                    Wr_overflow,  
                    Wr_memout,
                    Wr_aluout,
                    Wr_ins,
                    Wr_RegWr,
                    Wr_MemtoReg,
                    Wr_Rw
);

assign Wr_lui_result = {Wr_ins[15:0],16'd0};
assign Wr_pc_plus_4 = Wr_pc + 1;
MUX4    a_MUX4_busW( .a     (Wr_aluout), 
                     .b     (Wr_memout), 
                     .c     (Wr_lui_result), 
                     .d     (Wr_pc_plus_4), 
                     .ctr   (Wr_MemtoReg), 
                     .y     (Wr_busW));
endmodule
