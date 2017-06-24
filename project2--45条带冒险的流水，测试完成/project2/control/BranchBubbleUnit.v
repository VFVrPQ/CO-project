module BranchBubbleUnit(id_Ra, id_Rb, ex_RegWr, ex_Rw, mem_RegWr, 
                        mem_MemtoReg, mem_Rw, BranchBubble, id_Branch,id_Jump);
	input [4:0] id_Ra;
	input [4:0] id_Rb;
	input       ex_RegWr;
	input [4:0] ex_Rw;
	input       mem_RegWr;
	input       mem_MemtoReg;
	input [4:0] mem_Rw;
	input [2:0]	id_Branch;
	input [1:0] id_Jump;
	output reg  BranchBubble;

	initial begin
		BranchBubble = 0;
	end

	//*********branch & JR && JALR插空气泡*******// Jump=2‘b10的时候是JR和JALR
	//branch>0的时候jump=0
	//jump=0的时候branch=0
	always @(*) begin
		if (id_Branch == 3'b000) begin
			//************JR & JALR*************//
			if (id_Jump == 2'b10) begin
				//******************相邻指令************//
				if (((ex_RegWr==1) && (ex_Rw != 0 && ex_Rw == id_Ra)) || 
				//******************lw指令**************//
				     ((mem_MemtoReg==1) && (mem_Rw!=0 && mem_Rw == id_Ra))) begin
				  	 BranchBubble <= 1;
				end else begin
				 	 BranchBubble <= 0; 	
				end 		
			end //end id_Jump
			else begin
				BranchBubble <= 0;
			end
		end else
		//***********BEQ & BNE ****************//
		if (id_Branch == 3'b001 || id_Branch == 3'b010) begin 
			//******************相邻指令************//
			if (((ex_RegWr==1) && (ex_Rw != 0 && (ex_Rw == id_Ra || ex_Rw == id_Rb))) || 
			//******************lw指令**************//
			     ((mem_MemtoReg==1) && (mem_Rw!=0 && (mem_Rw == id_Ra || mem_Rw == id_Rb)))) begin 
			  	 BranchBubble <= 1;
			end else begin
			 	 BranchBubble <= 0; 	
			end 
		end else begin //BGEZ,BGTZ,BLEZ,BLTZ ,busB 没有用到
			//******************相邻指令************//
			if (((ex_RegWr==1) && (ex_Rw != 0 && ex_Rw == id_Ra)) ||
			//******************lw指令**************//
			     ((mem_MemtoReg==1) && (mem_Rw!=0 && mem_Rw == id_Ra))) begin
			  	 BranchBubble <= 1;
			end else begin
			 	 BranchBubble <= 0; 	
			end 						
		end
	end
endmodule
 	