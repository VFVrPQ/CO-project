
module MUX2 #(parameter WIDTH = 32) (a,b,ctr,y);

input ctr;
input[WIDTH-1:0] a,b;
output[WIDTH-1:0] y;

assign y = (ctr==0)? a:b;
endmodule

module MUX3 #(parameter WIDTH = 32) (a,b,c,ctr,y);

input[1:0] ctr;
input[WIDTH-1:0] a,b,c;
output reg [WIDTH-1:0] y;

always @ (ctr or a or b or c)
  begin
	case (ctr[1:0])
		2'b00 : assign  y=a;
		2'b01 : assign  y=b;
		2'b10 :	assign  y=c; 
endcase
  end

endmodule

module MUX4 #(parameter WIDTH = 32) (a,b,c,d,ctr,y);

input[1:0] ctr;
input[WIDTH-1:0] a,b,c,d;
output reg [WIDTH-1:0] y;

always @ (ctr or a or b or c or d)
  begin
	case (ctr[1:0])
		2'b00 : assign  y=a;
		2'b01 : assign  y=b;
		2'b10 :	assign  y=c; 
		2'b11 : assign  y=d;
endcase
  end

endmodule