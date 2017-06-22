module BranchForwardingUnit(id_Ra, id_Rb, mem_Rw, mem_RegWr, mem_MemtoReg,
                            BranchForwardA, BranchForwardB);
	input [4:0] id_Ra;
	input [4:0] id_Rb;
	input [4:0] mem_Rw;
	input 		mem_MemtoReg;
	input 		mem_RegWr;
	output  reg BranchForwardA;
	output	reg BranchForwardB;

	initial begin
		BranchForwardA = 0;
		BranchForwardB = 0;
	end
	always @(*) begin
		if (mem_RegWr == 1 && mem_Rw != 0 && mem_Rw == id_Ra)
			 BranchForwardA <= 1 ; 
		else 
			 BranchForwardA <= 0 ;

		if (mem_RegWr == 1 && mem_Rw != 0 && mem_Rw == id_Rb)
			 BranchForwardA <= 1 ; 
		else 
		     BranchForwardA <= 0 ;
	end
endmodule