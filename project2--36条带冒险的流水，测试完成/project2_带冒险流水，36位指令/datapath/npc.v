module npc(PC_plus_4,PC_br,PC_jump01,PC_jump10,Branch_ok,Jump,NPC);
	input [31:2]      PC_plus_4;
	input [31:2]  	  PC_br;
	input [31:2]	  PC_jump01;
	input [31:2]	  PC_jump10;
	input		 	  Branch_ok;
	input [1:0]	 	  Jump;
	output[31:2]      NPC;

	assign NPC = (Branch_ok==1) ? PC_br     :
		         ((Jump==2'b01) ? PC_jump01 : 
		         ((Jump==2'b10) ? PC_jump10 : PC_plus_4));
endmodule


