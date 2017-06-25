`timescale 1ns / 1ps
module npc(PC_plus_4,PC_br,PC_jump01,PC_jump10,Branch_ok,Jump,NPC,PC_cp0_mux3,cp0Forward);
	input [31:2]      PC_plus_4;
	input [31:2]  	  PC_br;
	input [31:2]	  PC_jump01;
	input [31:2]	  PC_jump10;
	input		 	  Branch_ok;
	input [1:0]	 	  Jump;

	input [31:2]      PC_cp0_mux3;
	input [ 1:0]      cp0Forward;
	output[31:2]      NPC;

	parameter EXC_ENTER_ADDR = 30'b0;
	assign NPC = ((cp0Forward == 2'b11) ? EXC_ENTER_ADDR :
		         ((cp0Forward != 2'b00) ? PC_cp0_mux3    :
				 ((Branch_ok==1)        ? PC_br          :
		         ((Jump==2'b01)         ? PC_jump01      : 
		         ((Jump==2'b10)         ? PC_jump10      : PC_plus_4)))));
endmodule


