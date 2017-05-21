module  forwardingUnit(ex_Ra,ex_Rb,mem_Rw,mem_RegWr,wr_Rw,wr_RegWr,forwardA,forwardB);
	input[4:0]      ex_Ra;
	input[4:0]  	ex_Rb;
	input[4:0]  	mem_Rw;
	input       	mem_RegWr;
	input[4:0]  	wr_Rw;
	input       	wr_RegWr;

	output reg [1:0]forwardA;
	output reg [1:0]forwardB;

	initial begin
		forwardA = 2'd0;
		forwardB = 2'd0;
	end

	always @(*) begin
		assign forwardA = 2'b00;
		assign forwardB = 2'b00;

		if (mem_RegWr!=0 && mem_Rw!=0 && mem_Rw == ex_Ra)
		begin
			assign forwardA = 2'b10;
		end else 
		if (wr_RegWr!=0 && wr_Rw!=0 && wr_Rw == ex_Ra)
		begin
			assign forwardA = 2'b01;
		end

		assign forwardB = 2'b00;
		if (mem_RegWr!=0 && mem_Rw!=0 && mem_Rw == ex_Rb)
		begin
			assign forwardB = 2'b10;
		end else 
		if (wr_RegWr!=0 && wr_Rw!=0 && wr_Rw == ex_Rb)
		begin
			assign forwardB = 2'b01;
		end
	end
endmodule