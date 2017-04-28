//complete add,sub,subu,slt,sltu ; ori,addiu,lw,sw,beq ; J
//R:add(32),sub(34),slt(42),and(36),or(37)
//  
//add:  add, lw, sw	000
//sub:  sub, beq	001
//and:  and		010
//or :  or 		011
//slt:  slt             100
module ctrl(op,RegWr,RegDst,ExtOp,ALUsrc,Branch,Jump,MemWr,MemtoReg);
	input [5:0] op;
	output reg RegWr,RegDst,ExtOp,ALUsrc,Branch,Jump,MemWr,MemtoReg;//WrEn
	//output reg [2:0] ALUctr;

	parameter R = 6'b000000, ORI = 6'b001101, ADDIU = 6'b001001, LW = 6'b100011, SW = 6'b101011, BEQ = 6'b000100, J = 6'b000010;
        //parameter ADD = 6'b100000, SUB = 6'b100010, SLT = 6'b101010, AND = 6'b100100 , OR = 6'b100101;

	always @(*)begin
	case (op)
		R:begin//add,sub,subu,slt,sltu
			assign Branch = 0;
			assign Jump   = 0;
			assign RegDst = 1;
			assign ALUsrc = 0;
				
			assign MemtoReg = 0;
			assign RegWr    = 1;
			assign MemWr    = 0;
			assign ExtOp    = 0;//x	
		end
		ORI:begin
			assign Branch = 0;
			assign Jump   = 0;
			assign RegDst = 0;
			assign ALUsrc = 1;
				
			assign MemtoReg = 0;
			assign RegWr    = 1;
			assign MemWr    = 0;
			assign ExtOp    = 0;
		end
		ADDIU:begin
			assign Branch = 0;
			assign Jump   = 0;
			assign RegDst = 0;
			assign ALUsrc = 1;
				
			assign MemtoReg = 0;
			assign RegWr    = 1;
			assign MemWr    = 0;
			assign ExtOp    = 1;
		end
		LW:begin
			assign Branch = 0;
			assign Jump   = 0;
			assign RegDst = 0;
			assign ALUsrc = 1;
				
			assign MemtoReg = 1;
			assign RegWr = 1;
			assign MemWr = 0;
			assign ExtOp = 1;
		end
		SW:begin
			assign Branch = 0;
			assign Jump = 0;
			assign RegDst = 0;//x
			assign ALUsrc = 1;
				
			assign MemtoReg = 0;//x
			assign RegWr = 0;
			assign MemWr = 1;
			assign ExtOp = 1;
		end
		BEQ:begin
			assign Branch = 1;
			assign Jump = 0;
			assign RegDst = 0;//x
			assign ALUsrc = 0;
				
			assign MemtoReg = 0;//x
			assign RegWr = 0;
			assign MemWr = 1;
			assign ExtOp = 1;
		end
		J:begin
			assign Branch = 0;
			assign Jump = 1;
			assign RegDst = 0;//x
			assign ALUsrc = 0;//x
				
			assign MemtoReg = 1;//x
			assign RegWr = 0;
			assign MemWr = 0;
			assign ExtOp = 1;//x
		end
	endcase
	end
endmodule 