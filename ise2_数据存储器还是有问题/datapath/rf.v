`timescale 1ns / 1ps

module rf(Clk,WrEn,Ra,Rb,Rw,busW,busA,busB,R31Wr,R31,rf_addr,rf_data,Reset);
	input           Reset;
	input 			Clk;
	input 			WrEn;
	input  [4:0]	Ra,Rb,Rw;
	input  [31:0]	busW;
	input  			R31Wr;
	input  [31:2]   R31;

	output [31:0]	busA,busB;
	reg    [31:0] 	R[0:31];


	//----{link to ISE}begin
	input      [4:0]    rf_addr;
	output reg [31:0]   rf_data;

	always @(*) begin 
		rf_data <= R[rf_addr];
	end
	//----{link to ISE}end


	integer i;
	initial begin		
		for (i=0;i<32;i=i+1) R[i] = 0;
		//R[8] =  32'd5;
		//R[9] =  32'd1;
		//R[10] = 32'b0;
		//R[11] = 32'b0;
		//R[12] = 32'd2;
	end

	/*always @(posedge Clk) begin
		if (Reset) 
			for (i=0;i<32;i=i+1) R[i] <= 0;
	end*/
	always @(posedge Clk)	begin//是否要判断Rw�1的大小关�
		if(WrEn)  R[Rw] <= busW;	//非阻塞赋�
		if(R31Wr) R[31] <= {R31, 2'b0};
		//$display(ex_Ra);
		//$display(R[ex_Ra]);
	end

	assign busA = (Ra != 5'd0)? R[Ra]: 32'd0;
	assign busB = (Rb != 5'd0)? R[Rb]: 32'd0;
endmodule 
