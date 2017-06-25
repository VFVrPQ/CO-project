module pc(NPC,Clk,Reset,PC,hazard,BranchBubble,cp0Bubble);
	input[31:2]       NPC;
	input 			  Clk;
	input 			  Reset;
	input 			  hazard;
	input 			  BranchBubble;
	input             cp0Bubble;
	output reg [31:2] PC;
	
	initial begin
		PC = 30'd0;
	end

	always @(posedge Clk)
	begin
		if (hazard == 0 && BranchBubble == 0 && cp0Bubble == 0) 
		begin
			if (Reset == 1) //初始时34
				 PC <= 30'b00_0000_0000_0000_0000_0000_0000_1101;//high 30
			else PC <= NPC;//PC必须非阻塞赋值，否则循环加到很大很大
		end
	end
endmodule
