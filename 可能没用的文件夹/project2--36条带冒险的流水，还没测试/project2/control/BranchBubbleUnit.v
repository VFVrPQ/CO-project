module BranchBubbleUnit(id_Ra, id_Rb, ex_RegWr, ex_Rw, mem_RegWr, 
                        mem_MemtoReg, mem_Rw, BranchBubble, id_Branch);
	input [4:0] id_Ra;
	input [4:0] id_Rb;
	input       ex_RegWr;
	input [4:0] ex_Rw;
	input       mem_RegWr;
	input       mem_MemtoReg;
	input [4:0] mem_Rw;
	input [2:0]	id_Branch;
	output reg  BranchBubble;

	initial begin
		BranchBubble = 0;
	end
	always @(*) begin
		if (id_Branch == 3'b001 || id_Branch == 3'b010) begin //BEQ,BNE
			if (((ex_RegWr==1) && (ex_Rw != 0 && (ex_Rw == id_Ra || ex_Rw == id_Rb))) || //相邻指令
			     ((mem_MemtoReg==1) && (mem_Rw!=0 && (mem_Rw == id_Ra || mem_Rw == id_Rb)))) begin //lw指令
			  	 BranchBubble <= 1;
			end else begin
			 	 BranchBubble <= 0; 	
			end 
		end else 
		if (id_Branch == 3'b000) begin
				 BranchBubble <= 0;
		end else begin //BEGEZ,BGTZ,BLEZ,BLTZ ,busB 没有用到
			if (((ex_RegWr==1) && (ex_Rw != 0 && ex_Rw == id_Ra)) || //相邻指令
			     ((mem_MemtoReg==1) && (mem_Rw!=0 && mem_Rw == id_Ra))) begin //lw指令
			  	 BranchBubble <= 1;
			end else begin
			 	 BranchBubble <= 0; 	
			end 						
		end
	end
endmodule
 	