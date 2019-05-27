
//Overflow = c(n)^c(n-1) not complete
module ADDER #(parameter WIDTH = 32)
	(A,B,Cin,Carry,Zero,Overflow,Sign,Result);

	//define
	input [WIDTH-1:0] A,B;
	input Cin;
	output Zero,Overflow,Sign;
	output reg Carry;
	output reg [WIDTH-1:0]Result;

	assign Zero = (Result==32'b0)?1:0;
	assign Sign = Result[WIDTH-1];
	assign Overflow = 0; // not complete
	always @ (A or B or Cin)
	begin
		assign {Carry , Result} = A + B + Cin;

	end
endmodule
