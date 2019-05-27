
module rf(Clk,WrEn,Ra,Rb,Rw,busW,busA,busB);//que shao R
	input Clk;
	input WrEn;
	input [4:0]Ra,Rb,Rw;
	input [31:0]busW;
	output [31:0]busA,busB;
	
	reg [31:0] R[0:31];

	integer i;
	initial begin		
		for (i=0;i<32;i=i+1) R[i] = 0;
		R[10] = 32'd7;
		R[11] = 32'd15;
	end
	always @(posedge Clk)	begin
		if(WrEn) R[Rw] <= busW;	
		$display("R[10] = %h ",R[10]);
	end

	assign busA = (Ra != 0)? R[Ra]:0;
	assign busB = (Rb != 0)? R[Rb]:0;
endmodule 
