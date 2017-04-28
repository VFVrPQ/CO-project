module testbench();
	reg clk,rst;

	initial begin
		clk = 0;
		rst = 1;
		#60 rst = 0;
	end
	always #50 clk = ~clk;

	mips mips(clk,rst);
endmodule 