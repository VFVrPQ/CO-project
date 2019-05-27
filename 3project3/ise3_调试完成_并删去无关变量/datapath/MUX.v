`timescale 1ns / 1ps
module MUX2 #(parameter WIDTH = 32)
	(a,b,ctr,y);
  input             ctr;
  input [WIDTH-1:0] a,b;
  output[WIDTH-1:0] y;

  assign y = (ctr==1)? b : a;
endmodule

`timescale 1ns / 1ps
module MUX3 #(parameter WIDTH = 32)
	(a,b,c,ctr,y);
  input[1:0]        ctr;
  input[WIDTH-1:0]  a,b,c;
  output[WIDTH-1:0] y;

  assign y = (ctr==2'b00)?a:((ctr==2'b01)?b:c);
endmodule
