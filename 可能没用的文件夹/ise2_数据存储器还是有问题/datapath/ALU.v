/*
addu  0000 有符号无符号无区别，在没有溢出的情况�subu  0001
slt 0010
and 0011
nor 0100
or  0101
xor 0110
sll 0111
srl 1000
sltu  1001
sra 1010
*/
`timescale 1ns / 1ps
module ALU #(parameter WIDTH = 32)
  (A,B,ALUctr,Zero,Result);//no Overflow
  //define
  input [WIDTH-1:0]     A,B;
  input [3:0]           ALUctr;
  output            Zero;
  output reg [WIDTH-1:0]  Result;
  
  //***SLTUpre***//
  wire [WIDTH-1:0]        high   = {1'b1, {WIDTH-1{1'b0}} };
  wire [WIDTH-1:0]        SLTA  = A ^ high;
  wire [WIDTH-1:0]        SLTB  = B ^ high;
  
  assign Zero = ((Result == 0)? 1'b1 : 1'b0);

  always @ (ALUctr or A or B)
  begin
  case (ALUctr)
    //***ADDU**//
    4'b0000 : Result <= A + B;//直接得出结果
    //***SUBU**//
    4'b0001 : Result <= A - B;
    //***SLT***//
    4'b0010 : Result <= (SLTA < SLTB) ? 1 : 0;//modelsim�是无符号位！�    //***AND***//
    4'b0011 : Result <= A & B;
    //***NOR***//
    4'b0100 : Result <= ~ ( A | B);
    //***OR****//
    4'b0101 : Result <= A | B;
    //***XOR***//
    4'b0110 : Result <= A ^ B;
    //***SLL***//
    4'b0111 : Result <= B << A;//A,B反向
    //***SRL**//
    4'b1000 : Result <= B >> A;//A,B反向
    //***SLTU***//
    4'b1001 : Result <= (A < B) ? 1 : 0; //modelsim�是无符号位！�    //***SRA***//A,B反向
    4'b1010 : begin
          if (B[31] == 0)begin
              Result <= B >> A;
          end else begin
              Result <= ~((~B)>>A);
          end
    end
    //***LUI***//
    4'b1011 : begin
				  Result <= {B[15:0], 16'd0};
    end
  endcase
  end
endmodule
