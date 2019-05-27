`timescale 1ns / 1ps
module LoongsonBubbleUnit(clk, mem_MemWr, wr_MemWr, loongsonBubble, loongsonOver);

	input       clk;
	input [1:0] mem_MemWr;
	input [1:0] wr_MemWr;
	output reg  loongsonBubble;
	output reg  loongsonOver;
	initial begin
		loongsonBubble = 0;
		loongsonOver   = 0;
	end
	//
	always @(posedge clk) begin 
		if (mem_MemWr == 2'b01 || mem_MemWr == 2'b10) begin

			//*********第一次阻塞**//
			if (loongsonBubble == 0 && loongsonOver == 0) begin
				loongsonBubble <= 1;
				loongsonOver   <= 0;
			end else 
			//*********第二次阻塞**//
			if (loongsonBubble == 1 && loongsonOver == 0) begin
				loongsonBubble <= 0;
				loongsonOver   <= 1;
			end else 
			//*********清空阻塞信号
			if (loongsonBubble == 0 && loongsonOver == 1) begin
				loongsonBubble <= 0;
				loongsonOver   <= 0;
			end
		end else begin
			loongsonBubble <= 0;
			loongsonOver   <= 0;
		end
	end
endmodule