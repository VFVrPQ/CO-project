module testbench();
	reg clk,rst;

	initial begin
		clk = 0;
		rst = 1;
		#45 rst = 0;
	end
	always #40 clk = ~clk;

	mips mips(clk,rst);
endmodule 