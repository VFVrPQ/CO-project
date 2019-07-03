
module npc(busA, imm16, branch, zero, jump, target, PC, NPC);

input[15:0] imm16;
input[2:0] branch;
input[31:0] busA;
input zero;
input[1:0] jump;
input[25:0] target;
input[31:2] PC;
output reg [31:2] NPC;

wire[31:2] PC_4 = PC[31:2] + 1;
wire[31:2] PC_br1 = PC[31:2]  + { { 14{ imm16[15]}} , imm16 };
wire[31:2] PC_ju = { PC[31:28], target[25:0] };

reg[31:2] npc1;

always @ (PC or branch )
  begin
	case (branch[2:0])
    3'b000 : assign npc1[31:2] = PC_4[31:2];
    3'b001 : assign npc1[31:2] = (zero==1) ? PC_br1[31:2]:PC_4[31:2];
    3'b010 : assign npc1[31:2] = (zero==0) ? PC_br1[31:2]:PC_4[31:2];
    3'b011 : assign npc1[31:2] = (busA>=0) ? PC_br1[31:2]:PC_4[31:2];
    3'b100 : assign npc1[31:2] = (busA>0) ? PC_br1[31:2]:PC_4[31:2];
    3'b101 : assign npc1[31:2] = (busA[31]==1|busA==32'd0) ? PC_br1[31:2]:PC_4[31:2];
    3'b110 : assign npc1[31:2] = (busA[31]==1) ? PC_br1[31:2]:PC_4[31:2];
endcase
  end
//MUX2 #30 a_MUX2_npc1( PC_4[31:2], PC_br1[31:2], branch&zero, npc1[31:2]);

always @ (PC or jump )
  begin
	case (jump[1:0])
    2'b00 : assign NPC[31:2] = npc1[31:2];
    2'b10 : assign NPC[31:2] = busA[31:2];
    2'b01 : assign NPC[31:2] = PC_ju[31:2];
endcase
  end
//MUX2 #30 a_MUX2_NPC( npc1[31:2], PC_ju[31:2], jump, NPC[31:2]);

endmodule
