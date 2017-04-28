
module rf(Clk,WrEn,Ra,Rb,Rw,busW,busA,busB);//que shao R
	input Clk;
	input WrEn;
	input [4:0]Ra,Rb,Rw;
	input [31:0]busW;
	output [31:0]busA,busB;
	
	reg [31:0] R[0:31];
	
	initial begin
		R[18] = 32'h0000_000a;
		R[19] = 32'h0000_0002;
	end
	always @(posedge Clk)	
		if(WrEn) R[Rw] <= busW;	

	assign busA = (Ra != 0)? R[Ra]:0;
	assign busB = (Rb != 0)? R[Rb]:0;
endmodule 
