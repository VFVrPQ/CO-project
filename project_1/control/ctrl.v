
//complete add,sub,and,or,slt,lw,sw,beq,J
//R:add(32),sub(34),slt(42),and(36),or(37)
//  
//add:  add, lw, sw	000
//sub:  sub, beq	001
//and:  and		010
//or :  or 		011
//slt:  slt             100
module ctrl(op,func,RegWr,RegDst,ExtOp,ALUsrc,Branch,Jump,ALUctr,MemWr,MemtoReg);
	input [5:0] op,func;
	output reg RegWr,RegDst,ExtOp,ALUsrc,Branch,Jump,MemWr,MemtoReg;//WrEn
	output reg [2:0] ALUctr;

	parameter R = 6'b000000, LW = 6'b100011, SW = 6'b101011, BEQ = 6'b000100, J = 6'b000010;
        parameter ADD = 6'b100000, SUB = 6'b100010, SLT = 6'b101010, AND = 6'b100100 , OR = 6'b100101;

	always @(*)begin
	case (op)
		R:begin
			assign Branch = 0;
			assign Jump = 0;
			assign RegDst = 1;
			assign ALUsrc = 0;
				
			assign MemtoReg = 0;
			assign RegWr = 1;
			assign MemWr = 0;
			assign ExtOp = 0;//ren yi 
			
			case (func)
				ADD: assign ALUctr = 3'b000;
				SUB: assign ALUctr = 3'b001;
				SLT: assign ALUctr = 3'b100;
				AND: assign ALUctr = 3'b010;
				OR : assign ALUctr = 3'b011;
			endcase 
		end
		LW:begin
			assign Branch = 0;
			assign Jump = 0;
			assign RegDst = 0;
			assign ALUsrc = 1;
				
			assign MemtoReg = 1;
			assign RegWr = 1;
			assign MemWr = 0;
			assign ExtOp = 1;
			
			assign ALUctr = 3'b000;
		end
		SW:begin
			assign Branch = 0;
			assign Jump = 0;
			assign RegDst = 0;//x
			assign ALUsrc = 1;
				
			assign MemtoReg = 1;//x
			assign RegWr = 0;
			assign MemWr = 1;
			assign ExtOp = 1;

			assign ALUctr = 3'b000;		
		end
		BEQ:begin
			assign Branch = 1;
			assign Jump = 0;
			assign RegDst = 0;//x
			assign ALUsrc = 0;
				
			assign MemtoReg = 1;//x
			assign RegWr = 0;
			assign MemWr = 1;
			assign ExtOp = 1;

			assign ALUctr = 3'b001;		
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
			
			assign ALUctr = 3'b000;//xx	
		end
	endcase
	end
endmodule 