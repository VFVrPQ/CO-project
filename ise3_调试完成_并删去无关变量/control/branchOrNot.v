`timescale 1ns / 1ps

//该文件不需要用到。。因为loongson指令中branch的下一条也要执行，不需要冲刷
module branchOrNot(busA,busB,Branch,Branch_ok);
	input[31:0] busA;
	input[31:0] busB;
	input[2:0]  Branch;
	output reg  Branch_ok;

	initial begin
		Branch_ok = 0;
	end
	//**********<是无符号位比较！！！
	always @(*) begin
		//*****NO*******//
		if (Branch == 3'b000) begin
			Branch_ok <= 0;
		end else 
		//*****BEQ******//
		if (Branch == 3'b001) begin
			Branch_ok <= (busA == busB);
		end else 
		//*****BNE******//
		if (Branch == 3'b010) begin
			Branch_ok <= (busA != busB);
		end else 
		//*****BGEZ******//
		//busA是非负数//
		if (Branch == 3'b011) begin
			Branch_ok <= (busA[31] == 1'b0);
		end else
		//*****BGTZ******//
		//busA是正数//
		if (Branch == 3'b100) begin
			Branch_ok <= (busA[31] == 1'b0 && busA != 32'b0);
		end else 
		//*****BLEZ******//
		//busA是非正数//
		if (Branch == 3'b101) begin
			Branch_ok <= (busA[31] == 1'b1 || busA == 32'b0);
		end else 
		//*****BLTZ******//
		//busA是负数//
		if (Branch == 3'b110) begin
			Branch_ok <= (busA[31] == 1'b1);
		end 
	end
endmodule