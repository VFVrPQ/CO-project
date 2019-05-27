module branchOrNot(ra,rb,Branch,if_flush);
	input[4:0] ra;
	input[4:0] rb;
	input 	   Branch;
	output reg if_flush;

	wire 	   Zero = (ra == rb) ? 1: 0;

	initial begin
		if_flush = 0;
	end

	always @(*) begin
		assign if_flush = (Zero&Branch) ? 1 : 0;
	end
	
endmodule