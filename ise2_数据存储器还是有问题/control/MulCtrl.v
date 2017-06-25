`timescale 1ns / 1ps
module MulCtrl(ins, mulCtr, regToMul, mulToReg, mulRead);//MFLO和MFHI的RegWr = 1, RegDst =1, 其他控制信号�
	input      [31: 0] ins;
	output reg         mulCtr;
	output reg [ 1: 0] regToMul;
	output reg         mulToReg;
	output reg 		   mulRead;	

	//************op**********//
	parameter R    = 6'b0000000;
	//************func********//
	parameter MULT = 6'b011000, MFLO = 6'b010010, MFHI = 6'b010000,
			  MTLO = 6'b010011, MTHI = 6'b010001;

	initial begin
		mulCtr   = 0;
		regToMul = 2'b0;
		mulToReg = 0; 
		mulRead  = 0;
	end
	always @(*) begin
		if (ins[31:26] == R) begin
			case(ins[5:0])
				MULT:begin
					mulCtr   = 1;
					regToMul = 2'b11;
					mulToReg = 0; 
					mulRead  = 0;
				end
				MFLO:begin
					mulCtr   = 0;
					regToMul = 2'b00;
					mulToReg = 1; 	
					mulRead  = 0;				
				end
				MFHI:begin
					mulCtr   = 0;
					regToMul = 2'b00;
					mulToReg = 1; 
					mulRead  = 1;				
				end
				MTLO:begin
					mulCtr   = 0;
					regToMul = 2'b01;
					mulToReg = 0; 					
					mulRead  = 0;				
				end		
				MTHI:begin
					mulCtr   = 0;
					regToMul = 2'b10;
					mulToReg = 0; 	
					mulRead  = 0;				
				end		
				default:begin
					mulCtr   = 0;
					regToMul = 2'b00;
					mulToReg = 0; 	
					mulRead  = 0;
				end	
			endcase
		end else begin
			mulCtr   = 0;
			regToMul = 2'b00;
			mulToReg = 0; 	
			mulRead  = 0;
		end
	end
endmodule