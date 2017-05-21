
module npc (imm16,if_flush,Jump,Target,PC,NPC);//(id_imm16,if_flush,id_Jump,ins[25:0],PC,NPC);
	input[15:0]  	  imm16;
	input		 	  if_flush;
	input		 	  Jump;
	input[25:0]  	  Target;
	input[31:2]  	  PC;
	output reg [31:2] NPC;
	
	wire [31:2] PC_plus_4 = PC[31:2] + 1;
	wire [31:2] PC_br 	  = PC_plus_4[31:2]+{ { 14{imm16[15]} } , imm16};
	wire [31:2] NPC_pre;
	wire [31:2] PC_jump   = { PC[31:28] , Target[25:0] };

	//get npc
	//如果上一指令是branch，且要跳转，则 npc = 跳转地址
	//如果not(上一指令是branch，且要跳转) && if_ins[31:26] == 6'b000010，则npc = 下一指令
	always @(*)begin
		if (if_flush == 0 &&  Jump)	assign NPC = PC_jump;
		else if (if_flush) 			assign NPC = PC_br;
		else 						assign NPC = PC_plus_4;
	end
endmodule
