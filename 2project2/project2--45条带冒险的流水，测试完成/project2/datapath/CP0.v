module CP0( clk, cs, sel, busB, cp0Op, cp0OutToReg, cp0OutToPC, PC);
	input             clk;
	input      [ 4:0] cs;
	input      [ 2:0] sel;
	input      [31:0] busB;
	input      [ 2:0] cp0Op;
	input      [31:2] PC;

	output reg [31:0] cp0OutToReg;
	output reg [31:0] cp0OutToPC;

	reg [31:0] C[0:255]; // only use {12,3'b0} = 96;
						 //          {13,3'b0} = 104;
						 //          {14,3'b0} = 112;

	integer i;
	initial begin
		for (i=0;i<256;i=i+1) C[i] = 32'b0;

		cp0OutToPC  = 32'b0;
		cp0OutToReg = 32'b0;
	end

	wire [ 7:0] addr = { cs, sel };

	//-----{写入cp0寄存器}begin
	always @(negedge clk) begin 
		//******MTCO********//
		if (cp0Op == 3'b010)  C[addr] <= busB;
	end
	//-----{写入cp0寄存器}end

	//-----{从cp0寄存器读出}begin
	always @(*) begin 
		//******MFCO********//
		if (cp0Op == 3'b001)  cp0OutToReg <= C[addr];
		//******SYSCALL*****//
		if (cp0Op == 3'b011)  begin
			C[112]      <= { PC, 2'b0 };
			C[104][6:2] <= 5'b01000;
			C[ 96][1]   <= 1'b1;
		end
		//*****ERET*********//
		if (cp0Op == 3'b100)  begin
			C[96][1]    <= 0;
		end
		//******ERERT*****// 通过信号控制是否赋值
		cp0OutToPC <= C[112];// {14,3'b0} = 112
	end
	//-----{从cp0寄存器读出}end
endmodule 