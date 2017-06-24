module HI_LO( clk,     regToMul,   mulToReg, mulRead, 
			  busA,    result,     HI_LOout);

	input clk;
	input      [1:0]  regToMul;
	input             mulToReg;
	input             mulRead;
	input      [31:0] busA;
	input      [63:0] result;

	output reg [31:0] HI_LOout;

	reg [31:0] HI;
	reg [31:0] LO;

	initial begin
		HI       = 32'd0;
		LO       = 32'd0;
		HI_LOout = 32'd0;
	end

	//------------{从HI_LO读出}begin
	always @(*)begin
		HI_LOout <= (mulRead == 1) ? HI : LO;
	end
	
	//------------{从HI_LO读出}end


	//------------{向HI_LO写入}begin
	always @(negedge clk) begin 
		//****MTLO*******//
		if (regToMul == 2'b01) LO <= busA;
		//****MTHI*******//
		if (regToMul == 2'b10) HI <= busA;
		//****MULT*******//
		if (regToMul == 2'b11) {HI, LO} <= result;

		$display("HI is %h",HI);
		$display("LO is %h",LO);
	end	
	//------------{向HI_LO写入}end	
endmodule