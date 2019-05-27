
module rf(Clk,WrEn,Ra,Rb,Rw,busW,busA,busB);//que shao R
	input Clk;
	input WrEn;
	input [4:0]Ra,Rb,Rw;
	input [31:0]busW;
	output [31:0]busA,busB;
	
	reg [31:0] R[0:31];

	initial begin	
		R[8]  = 32'h0000_0000;// no use

		R[18] = 32'h0000_000A;
		R[19] = 32'h0000_0002;
		R[20] = 32'h0000_3000;
	end
	always @(posedge Clk)	begin
		if(WrEn) R[Rw] <= busW;	
		$display(R[17]);
	end

	assign busA = (Ra != 0)? R[Ra]:0;
	assign busB = (Rb != 0)? R[Rb]:0;
endmodule 
