
module rf(Clk,WrEn,Ra,Rb,Rw,busW,busA,busB);
	input 			Clk;
	input 			WrEn;
	input  [4:0]	Ra,Rb,Rw;
	input  [31:0]	busW;

	output [31:0]	busA,busB;
	reg    [31:0] 	R[0:31];

	integer i;
	initial begin		
		for (i=0;i<32;i=i+1) R[i] = 0;
		R[10] = 7;
		R[11] = 15;
		R[20] = 128;
	end
	always @(negedge Clk)	begin
		if(WrEn) R[Rw] <= busW;	//非阻塞赋值
		//$display(ex_Ra);
		//$display(R[ex_Ra]);
	end

	assign busA = (Ra != 5'd0)? R[Ra]: 32'd0;
	assign busB = (Rb != 5'd0)? R[Rb]: 32'd0;
endmodule 
