//one bit sign extend
module SignExt1 #(parameter WIDTH=32)
	(a,y);
	input a;
	output [WIDTH-1:0] y;
	
	assign y = {0+WIDTH{a}};
endmodule
