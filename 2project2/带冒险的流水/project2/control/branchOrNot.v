module branchOrNot(busA,busB,Branch,if_flush);
	input[31:0] busA;
	input[31:0] busB;
	input 	    Branch;
	output reg  if_flush;

	wire 	    Zero = (busA == busB) ? 1: 0;

	initial begin
		if_flush = 0;
	end

	always @(*) begin
		if_flush = (Zero&Branch) ? 1 : 0;
	end
	
endmodule