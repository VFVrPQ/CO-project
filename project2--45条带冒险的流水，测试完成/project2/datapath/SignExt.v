
//one bit sign extend
module SignExt1 #(parameter WIDTH=32) (a,y);
	input 			   a;
	output [WIDTH-1:0] y;
	
	assign y = {0+WIDTH{a}};
endmodule


//16 bits
module SignExt16 #(parameter WIDTH=32) (ExtOp,a,y);
	input 			   ExtOp;
	input  [15:0]      a;
	output [WIDTH-1:0] y;
	
	assign y = (ExtOp==0) ? {16'b0, a} : {{WIDTH-16{a[15]}},a };
endmodule 

//5 bits
module SignExt5 #(parameter WIDTH=32) (a,y);
	input  [4:0]       a;
	output [WIDTH-1:0] y;
	
	assign y = {28'b0, a};
endmodule 