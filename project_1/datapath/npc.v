
module npc (imm16,Branch,Zero,Jump,Target,PC,NPC);// no jump
	input[15:0] imm16;
	input Branch,Zero,Jump;
	input[25:0] Target;
	input[31:2] PC;
	output[31:2] NPC;
	
	wire [31:2] PC_plus_4 = PC[31:2] + 1;
	wire [31:2] PC_br = PC_plus_4[31:2]+{ { 14{imm16[15]} } , imm16};
	wire [31:2] NPC_pre;
	wire [31:2] PC_jump = { PC[31:28] , Target[25:0] };

	MUX2 #30 MUX_NPC_pre(PC_plus_4[31:2] , PC_br[31:2] , Branch&Zero , NPC_pre[31:2]);
	MUX2 #30 MUX_NPC(NPC_pre[31:2] , PC_jump[31:2] , Jump , NPC[31:2]);
endmodule
