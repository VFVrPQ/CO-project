
module npc (busA,id_imm16Ext,Branch_ok,Jump,Target,PC,NPC);//(id_imm16,if_flush,id_Jump,ins[25:0],PC,NPC);
	input[31:0]       busA;
	input[31:0]  	  id_imm16Ext;
	input		 	  Branch_ok;
	input[1:0]	 	  Jump;
	input[25:0]  	  Target;
	input[31:2]  	  PC;
	output[31:2] NPC;
	
	wire [31:2] PC_plus_4 = PC[31:2] + 1;
	wire [31:2] PC_br 	  = PC_plus_4[31:2]+ id_imm16Ext[29:0]; //id_imm16Ext表示的是相对的指令数

	wire [31:2] PC_jump01 = { PC_plus_4[31:28] , Target[25:0] };
	wire [31:2] PC_jump10 = busA;

	assign NPC = (Branch_ok==1) ? PC_br     :
		         ((Jump==2'b01) ? PC_jump01 : 
		         ((Jump==2'b10) ? PC_jump10 : PC_plus_4));
endmodule
