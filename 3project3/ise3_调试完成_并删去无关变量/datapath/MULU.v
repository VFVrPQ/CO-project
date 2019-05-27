`timescale 1ns / 1ps
module MULU(mulCtr, a, b, y);
	input 		        mulCtr;
	input 		[31: 0] a;
	input 		[31: 0] b;
	output reg 	[63: 0] y;


	wire [63: 0] aExt = { 32'b0, a};
	wire [63: 0] bExt = { 32'b0, b};
	
	always @(mulCtr || a || b) begin
		y <= aExt * bExt;
	end
endmodule