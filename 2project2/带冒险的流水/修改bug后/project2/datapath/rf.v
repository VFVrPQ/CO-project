
module rf(Clk,WrEn,Ra,Rb,Rw,busW,busA,busB,ex_Ra,ex_Rb,ex_busA,ex_busB);//que shao R
	input 			Clk;
	input 			WrEn;
	input  [4:0]	Ra,Rb,Rw;
	input  [31:0]	busW;
	input  [4:0]	ex_Ra,ex_Rb;

	output [31:0]	busA,busB;
	output [31:0]	ex_busA,ex_busB;
	reg    [31:0] 	R[0:31];

	integer i,j;
	initial begin		
		for (i=0;i<32;i=i+1) R[i] = 0;
		R[10] = 32'd7;
		R[11] = 32'd15;
		R[20] = 32'd128;
	end
	always @(posedge Clk)	begin
		if(WrEn) R[Rw] <= busW;	//非阻塞赋值
		//$display(ex_Ra);
		//$display(R[ex_Ra]);
	end

	assign busA = (Ra != 5'd0)? R[Ra]: 32'd0;
	assign busB = (Rb != 5'd0)? R[Rb]: 32'd0;

	assign ex_busA = (ex_Ra != 5'd0)? R[ex_Ra]: 32'd0;
	assign ex_busB = (ex_Rb != 5'd0)? R[ex_Rb]: 32'd0;
endmodule 
