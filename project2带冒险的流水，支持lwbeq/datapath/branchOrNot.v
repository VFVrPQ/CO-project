module branchOrNot(busA,busB,Branch,Branch_ok);
	input[31:0] busA;
	input[31:0] busB;
	input 	    Branch;
	output reg  Branch_ok;

	wire 	    Zero = (busA == busB) ? 1: 0;

	initial begin
		Branch_ok = 0;
	end

	always @(*) begin
		Branch_ok = (Zero&Branch) ? 1 : 0;
	end
	
endmodule