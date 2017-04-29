
module rf(Clk,WrEn,Ra,Rb,Rw,busW,busA,busB);
	input Clk;
	input WrEn;
	input [4:0]Ra,Rb,Rw;
	input [31:0]busW;
	output [31:0]busA,busB;
	
	reg [31:0] R[0:31];
	
	initial begin
		R[8]  = 32'h0000_0001;
		R[11] = 32'h1111_1111;
		R[12] = 32'h0010_1010;

		R[18] = 32'h0000_000a;
		R[19] = 32'h0000_0002;
	end
	always @(posedge Clk)	
		if(WrEn) R[Rw] <= busW;	

	assign busA = (Ra != 0)? R[Ra]:0;
	assign busB = (Rb != 0)? R[Rb]:0;
endmodule 
