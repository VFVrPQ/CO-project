`timescale 1ns / 1ps
module mem_wr(Clk, mem_dout, mem_alu_result, mem_Rw, mem_RegWr,
              mem_MemtoReg, wr_dout, wr_alu_result, wr_Rw, wr_RegWr,
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
              mem_valid,    wr_valid,
              //----{ISE}end
              Reset
              );
    input       Reset;
    input       Clk;
    input[31:0] mem_dout;
    input[31:0] mem_alu_result;
    input[4:0]  mem_Rw;
    input       mem_RegWr,mem_MemtoReg;
    //----{mul}begin
    input[31:0] mem_busA;
    input[63:0] mem_mul_result;
    input[ 1:0] mem_regToMul;
    input       mem_mulToReg;
    input       mem_mulRead;
    //----{mul}end    
    //----{cp0}begin
    input[ 4:0] mem_cs;
    input[ 2:0] mem_sel;
    input[31:0] mem_busB;
    input[ 2:0] mem_cp0Op;
    input[31:2] mem_PC;
    //----{cp0}end   

    output reg [31:0] wr_dout;
    output reg [31:0] wr_alu_result;
    output reg [4:0]  wr_Rw;
    output reg        wr_RegWr,wr_MemtoReg;
    //----{mul}begin
    output reg [31:0] wr_busA;
    output reg [63:0] wr_mul_result;
    output reg [ 1:0] wr_regToMul;
    output reg        wr_mulToReg;
    output reg        wr_mulRead;
    //----{mul}end    
    //----{cp0}begin
    output reg [ 4:0] wr_cs;
    output reg [ 2:0] wr_sel;
    output reg [31:0] wr_busB;
    output reg [ 2:0] wr_cp0Op;
    output reg [31:2] wr_PC;
    //----{cp0}end   


    input             mem_valid;
    output reg        wr_valid;
    initial begin
      wr_dout       = 32'd0;
      wr_alu_result = 32'd0;
      wr_Rw         = 5'd0;
      wr_RegWr      = 0;
      wr_MemtoReg   = 0; 
      //----{mul}begin
      wr_busA       = 32'd0;
      wr_mul_result = 63'd0;
      wr_regToMul   = 2'd0;
      wr_mulToReg   = 0;
      wr_mulRead    = 0;
      //----{mul}end
      //----{cp0}begin
      wr_cs         = 5'd0;
      wr_sel        = 3'd0;
      wr_busB       = 32'd0;
      wr_cp0Op      = 3'd0;
      wr_PC         = 30'd0;
      //----{cp0}end

      wr_valid      = 1'd0;
    end
    always @(negedge Clk)
    begin
      /*if (Reset) begin
          wr_dout       <= 32'd0;
          wr_alu_result <= 32'd0;
          wr_Rw         <= 5'd0;
          wr_RegWr      <= 0;
          wr_MemtoReg   <= 0; 
          //----{mul}begin
          wr_busA       <= 32'd0;
          wr_mul_result <= 63'd0;
          wr_regToMul   <= 2'd0;
          wr_mulToReg   <= 0;
          wr_mulRead    <= 0;
          //----{mul}end
          //----{cp0}begin
          wr_cs         <= 5'd0;
          wr_sel        <= 3'd0;
          wr_busB       <= 32'd0;
          wr_cp0Op      <= 3'd0;
          wr_PC         <= 30'd0;
          //----{cp0}end

          wr_valid      = 1'd0;
      end else */begin
          wr_dout       <= mem_dout;
          wr_alu_result <= mem_alu_result;
          wr_Rw         <= mem_Rw;
          //control
          wr_RegWr      <= mem_RegWr;
          wr_MemtoReg   <= mem_MemtoReg;

          //----{mul}begin
          wr_busA       <= mem_busA;
          wr_mul_result <= mem_mul_result;
          wr_regToMul   <= mem_regToMul;
          wr_mulToReg   <= mem_mulToReg;
          wr_mulRead    <= mem_mulRead;
          //----{mul}end

          //----{cp0}begin
          wr_cs         <= mem_cs;
          wr_sel        <= mem_sel;
          wr_busB       <= mem_busB;
          wr_cp0Op      <= mem_cp0Op;
          wr_PC         <= mem_PC;
          //----{cp0}end

          wr_valid      <= mem_valid;
      end
    end
endmodule
