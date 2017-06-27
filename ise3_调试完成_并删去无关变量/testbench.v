`timescale 1ns / 1ps
module testbench();
	reg clk,rst;

	initial begin
		clk = 0;
		rst = 0;
		#45 rst = 1;
	end
	always #40 clk = ~clk;

	mips mips(clk,rst);
endmodule 