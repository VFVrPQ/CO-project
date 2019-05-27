`timescale 1ns / 1ps

module pc(NPC,Clk,Reset,PC,hazard,BranchBubble,cp0Bubble,if_valid/*,loongsonBubble,loongsonOver*/);
	input[31:2]       NPC;
	input 			  Clk;
	input 			  Reset;
	input 			  hazard;
	input 			  BranchBubble;
	input             cp0Bubble;
	//input             loongsonBubble;
	//input             loongsonOver;

	output reg [31:2] PC;
	output reg        if_valid;
	initial begin
		PC       = 30'd0;
		if_valid =  1'd0;
	end

	always @(negedge Clk)
	begin
		if (Reset == 1) begin//初始�4
			 PC       <= 30'b00_0000_0000_0000_0000_0000_0000_1101;//high 30
			 if_valid <= 1'b1;
		end
		else if ( hazard == 0 && BranchBubble == 0 && cp0Bubble == 0/* && loongsonBubble == 0 && loongsonOver == 0 */)
			 PC       <= NPC;//PC必须非阻塞赋值，否则循环加到很大很大
	end
endmodule
