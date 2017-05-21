//add:  add, lw, sw	000
//sub:  sub,  beq	001
//and:  and		010
//or :  or 		011
//slt:  slt             100
module ALU #(parameter WIDTH = 32)
	(A,B,ALUctr,Zero,Result);//no Overflow
  //define
  input [WIDTH-1:0] 	  A,B;
  input [2:0]       	  ALUctr;
  output		 	      Zero;
  output reg [WIDTH-1:0]  Result;
  
  assign Zero = ((Result == 0)? 1 : 0);

  always @ (ALUctr or A or B)
  begin
	case (ALUctr)
		3'b000 : assign Result = A + B;//直接得出结果
		3'b001 : assign Result = A - B;
		3'b010 : assign Result = A & B;
		3'b011 : assign Result = A | B;
		3'b100 : assign Result = (A < B) ? 1 : 0;
	endcase
  end
endmodule
