`timescale 1ns / 1ps
module Cp0Ctrl (ins, cp0Op);
	input      [31:0] ins;
	output reg [ 2:0] cp0Op;

	//************op**********//
	parameter R    = 6'b0000000;
	//************func********//
	parameter MULT = 6'b011000, MFLO = 6'b010010, MFHI = 6'b010000,
			  MTLO = 6'b010011, MTHI = 6'b010001;

	initial begin
		cp0Op = 3'b0;
	end
	always @(*) begin
		//**********MFCO*******//
		if (ins[31:26] == 6'b010000 && ins[25:21] == 5'b00000 && ins[10:3]==8'b00000000)
			cp0Op <= 3'b001;
		//**********MTCO*******//
		else if (ins[31:26] == 6'b010000 && ins[25:21] == 5'b00100 && ins[10:3]==8'b00000000)
			cp0Op <= 3'b010;
		//**********SYSCALL***//
		else if (ins[31:26] == 6'b000000 && ins[5:0]==8'b001100)
			cp0Op <= 3'b011;
		//**********ERET******//
		else if (ins == 32'b0100_0010_0000_0000_0000_0000_0001_1000)
			cp0Op <= 3'b100;
		//*********else*******//
		else
			cp0Op <= 3'b000;
	end
endmodule