module branchOrNot(busA,busB,Branch,Branch_ok);
	input[31:0] busA;
	input[31:0] busB;
	input[2:0]  Branch;
	output reg  Branch_ok;

	initial begin
		Branch_ok = 0;
	end

	always @(*) begin
		//*****NO*******//
		if (Branch == 3'b000) begin
			Branch_ok = 0;
		end else 
		//*****BEQ******//
		if (Branch == 3'b001) begin
			Branch_ok = (busA == busB);
		end else 
		//*****BNE******//
		if (Branch == 3'b010) begin
			Branch_ok = (busA != busB);
		end else 
		//*****BGEZ******//
		if (Branch == 3'b011) begin
			Branch_ok = (busA >= 32'b0);
		//*****BGTZ******//
		end else
		if (Branch == 3'b100) begin
			Branch_ok = (busA >  32'b0);
		end else 
		//*****BLEZ******//
		if (Branch == 3'b101) begin
			Branch_ok = (busA <= 32'b0);
		end else
		//*****BLTZ******//
		if (Branch == 3'b110) begin
			Branch_ok = (busA <  32'b0);
		end 
	end
endmodule