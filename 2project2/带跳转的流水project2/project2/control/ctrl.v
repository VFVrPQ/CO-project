
//complete add,sub,and,or,slt,lw,sw,beq,J
//R:add(32),sub(34),slt(42),and(36),or(37)
//  
//add:  add, lw, sw	000
//sub:  sub, beq	001
//and:  and		010
//or :  or 		011
//slt:  slt             100
module ctrl(clk,op,func,RegWr,RegDst,ExtOp,ALUsrc,Branch,Jump,ALUctr,MemWr,MemtoReg);
	input 		clk;
	input [5:0] op,func;
	output reg RegWr,RegDst,ExtOp,ALUsrc,Branch,Jump,MemWr,MemtoReg;//WrEn
	output reg [2:0] ALUctr;

	parameter R = 6'b000000, LW = 6'b100011, SW = 6'b101011, BEQ = 6'b000100, J = 6'b000010;
        parameter ADD = 6'b100000, SUB = 6'b100010, SLT = 6'b101010, AND = 6'b100100 , OR = 6'b100101;

    initial begin
    	RegWr 	 	= 0;
    	RegDst		= 0;
    	ExtOp		= 0;
    	ALUsrc		= 0;
    	Branch		= 0;
    	Jump		= 0;
    	MemWr		= 0;
    	MemtoReg	= 0;
		ALUctr		= 3'd0;
    end
	always @(posedge clk)begin
	case (op)
		R:begin
			Branch <= 0;
			Jump <= 0;
			RegDst <= 1;
			ALUsrc <= 0;
				
			MemtoReg <= 0;
			RegWr <= 1;
			MemWr <= 0;
			ExtOp <= 0;//ren yi 
			
			case (func)
				ADD: ALUctr <= 3'b000;
				SUB: ALUctr <= 3'b001;
				SLT: ALUctr <= 3'b100;
				AND: ALUctr <= 3'b010;
				OR : ALUctr <= 3'b011;
			endcase 
		end
		LW:begin
			Branch <= 0;
			Jump <= 0;
			RegDst <= 0;
			ALUsrc <= 1;
				
			MemtoReg <= 1;
			RegWr <= 1;
			MemWr <= 0;
			ExtOp <= 1;
			
			ALUctr <= 3'b000;
		end
		SW:begin
			Branch <= 0;
			Jump <= 0;
			RegDst <= 0;//x
			ALUsrc <= 1;
				
			MemtoReg <= 0;//x
			RegWr <= 0;
			MemWr <= 1;
			ExtOp <= 1;

			ALUctr <= 3'b000;		
		end
		BEQ:begin
			Branch <= 1;
			Jump <= 0;
			RegDst <= 0;//x
			ALUsrc <= 0;
				
			MemtoReg <= 0;//x
			RegWr <= 0;
			MemWr <= 1;
			ExtOp <= 1;

			ALUctr <= 3'b001;		
		end
		J:begin
			Branch <= 0;
			Jump <= 1;
			RegDst <= 0;//x
			ALUsrc <= 0;//x
				
			MemtoReg <= 1;//x
			RegWr <= 0;
			MemWr <= 0;
			ExtOp <= 1;//x
			
			ALUctr <= 3'b000;//xx	
		end
	endcase
	end
endmodule 