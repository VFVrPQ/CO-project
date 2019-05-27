
module ALU_TB();
   reg[7:0] A,B;
   reg[2:0] ALUctr;
   wire Zero;
   wire Overflow;
   wire[7:0] Result;

   reg[7:0] one;
   ALU #8 ALU_TB(.A(A),.B(B),.ALUctr(ALUctr),.Zero(Zero),.Overflow(Overflow),.Result(Result));

   initial
   begin
      assign A = 8'b00110010;
      assign B = 8'b00110101;
      assign ALUctr = 3'b110;
      assign one = 32'b1;
   end

   integer i;
   always
   begin
      for (i=0;;i=i+10)
	#i assign A=(A + one);
   end
endmodule 
