
module npc(imm16, branch, zero, jump, target, PC, NPC);

input[15:0] imm16;
input branch,zero,jump;
input[25:0] target;
input[31:2] PC;
output[31:2] NPC;

wire[31:2] PC_4 = PC[31:2] + 1;
wire[31:2] PC_br = PC[31:2] + 1 + { { 14{ imm16[15]}} , imm16 };
wire[31:2] PC_ju = { PC[31:28], target[25:0] };

wire[31:2] npc1;
MUX2 #30 a_MUX2_npc1( PC_4[31:2], PC_br[31:2], branch&zero, npc1[31:2]);
MUX2 #30 a_MUX2_NPC( npc1[31:2], PC_ju[31:2], jump, NPC[31:2]);

endmodule
