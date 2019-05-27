`timescale 1ns / 1ps
module id_ex(Clk,       hazard,      BranchBubble, id_busA,     id_busB,
             id_Ra,     id_Rb,       id_Rw,        id_imm16Ext, id_RegWr,
             id_RegDst, id_ALUsrc,   id_MemWr,     id_MemtoReg, id_ALUctr, id_MemRead, id_shf, id_ALUshf,
             ex_busA,   ex_busB,
             ex_Ra,     ex_Rb,       ex_Rw,        ex_imm16Ext, ex_RegWr,  
             ex_RegDst, ex_ALUsrc,   ex_MemWr,     ex_MemtoReg, ex_ALUctr, ex_MemRead, ex_shf, ex_ALUshf,
             //----{mul}begin
             id_mulCtr, id_regToMul, id_mulToReg,  id_mulRead,
             ex_mulCtr, ex_regToMul, ex_mulToReg,  ex_mulRead,
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
        input         Clk;
        input         hazard;
        input         BranchBubble;
        input [31:0]  id_busA;
        input [31:0]  id_busB;
        input [4:0]   id_Ra;
        input [4:0]   id_Rb;
        input [4:0]   id_Rw;
        input [31:0]  id_imm16Ext;
        input         id_RegWr,id_RegDst,id_ALUsrc;
        input [1:0]   id_MemWr;
        input         id_MemtoReg;
        input [3:0]   id_ALUctr;
        input [1:0]   id_MemRead;
        input [4:0]   id_shf;
        input         id_ALUshf;
        //----{mul}begin
        input         id_mulCtr;
        input [1:0]   id_regToMul;
        input         id_mulToReg;
        input         id_mulRead;        
        //----{mul}end
        //----{cp0}begin
        input [ 4:0]  id_cs;
        input [ 2:0]  id_sel;
        input [ 2:0]  id_cp0Op;
        input [31:2]  id_PC;
        input         cp0Bubble;
        //----{cp0}end

        output reg [4:0]   ex_Ra;
        output reg [4:0]   ex_Rb;
        output reg [4:0]   ex_Rw;
        output reg [31:0]  ex_busA;
        output reg [31:0]  ex_busB;
        output reg [31:0]  ex_imm16Ext;
        output reg         ex_RegWr,ex_RegDst,ex_ALUsrc;
        output reg [1:0]   ex_MemWr;
        output reg         ex_MemtoReg;
        output reg [3:0]   ex_ALUctr;     
        output reg [1:0]   ex_MemRead;
        output reg [4:0]   ex_shf;
        output reg         ex_ALUshf;
        //----{mul}begin
        output reg         ex_mulCtr;     
        output reg [1:0]   ex_regToMul;
        output reg         ex_mulToReg;
        output reg         ex_mulRead;    
        //----{mul}end

        //----{cp0}begin
        output reg [ 4:0]  ex_cs;
        output reg [ 2:0]  ex_sel;
        output reg [ 2:0]  ex_cp0Op;
        output reg [31:2]  ex_PC;
        //----{cp0}end

        input              id_valid;
        output reg         ex_valid;
       initial begin
             ex_Ra        = 5'd0;
             ex_Rb        = 5'd0;
             ex_Rw        = 5'd0;
             ex_busA      = 32'd0;
             ex_busB      = 32'd0;
             ex_imm16Ext  = 32'd0;
             ex_RegWr     = 0;
             ex_RegDst    = 0;
             ex_ALUsrc    = 0;
             ex_MemWr     = 2'd0;
             ex_MemtoReg  = 0;  
             ex_ALUctr    = 4'd0;
             ex_MemRead   = 2'd0;
             ex_shf       = 5'd0;
             ex_ALUshf    = 0;
             //----{mul}begin
             ex_mulCtr    = 0;
             ex_regToMul  = 2'b0;
             ex_mulToReg  = 0;
             ex_mulRead   = 0;
             //----{mul}end
             //----{cp0}begin
             ex_cs       = 5'd0;
             ex_sel      = 3'd0;
             ex_cp0Op    = 3'd0;
             ex_PC       = 30'd0;
             //----{cp0}end  

             ex_valid    = 1'd0;
        end
        always @(negedge Clk)
        begin
             if (hazard || BranchBubble || cp0Bubble) begin
                 ex_RegWr     <= 0;
                 ex_RegDst    <= 0;
                 ex_ALUsrc    <= 0;
                 ex_MemWr     <= 2'b0;
                 ex_MemtoReg  <= 0;
                 ex_ALUctr    <= 4'b0;  
                 ex_MemRead   <= 2'b0; 
                 ex_ALUshf    <= 0; 
                 //----{mul}begin
                 ex_mulCtr    <= 0;
                 ex_regToMul  <= 2'b0;
                 ex_mulToReg  <= 0;
                 ex_mulRead   <= 0;
                 //----{mul}end
                 //----{cp0}begin
                 ex_cs        <= 5'd0;
                 ex_sel       <= 3'd0;
                 ex_cp0Op     <= 3'd0;
                 ex_PC        <= 30'd0;
                 //----{cp0}end 

                 ex_valid     <= 1'd0;
             end else begin
                 ex_Ra        <= id_Ra;
                 ex_Rb        <= id_Rb;
                 ex_Rw        <= id_Rw;
                 ex_busA      <= id_busA;
                 ex_busB      <= id_busB;
                 ex_imm16Ext  <= id_imm16Ext;
                 ex_shf       <= id_shf;
                //control
                 ex_RegWr     <= id_RegWr;
                 ex_RegDst    <= id_RegDst;
                 ex_ALUsrc    <= id_ALUsrc;
                 ex_MemWr     <= id_MemWr;
                 ex_MemtoReg  <= id_MemtoReg;
                 ex_ALUctr    <= id_ALUctr;    
                 ex_MemRead   <= id_MemRead;
                 ex_ALUshf    <= id_ALUshf;
                 //----{mul}begin
                 ex_mulCtr    <= id_mulCtr;
                 ex_regToMul  <= id_regToMul;
                 ex_mulToReg  <= id_mulToReg;
                 ex_mulRead   <= id_mulRead;
                 //----{mul}end
                 //----{cp0}begin
                 ex_cs        <= id_cs;
                 ex_sel       <= id_sel;
                 ex_cp0Op     <= id_cp0Op;
                 ex_PC        <= id_PC;
                 //----{cp0}end 

                 ex_valid     <= id_valid;
             end 
        end
endmodule