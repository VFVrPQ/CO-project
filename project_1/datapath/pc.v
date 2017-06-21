module pc(NPC,Clk,Reset,PC);
	input[31:2]NPC;
	input Clk;
	input Reset;
	output reg [31:2] PC;
	
	always @(posedge Clk)
	begin
		if (Reset == 1) 
			PC <= 30'b00_0000_0000_0000_0000_1100_0000_0000;//high 30
		else PC <= NPC;
	end
endmodule
