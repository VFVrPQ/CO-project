
module MUX3 #(parameter WIDTH = 32)
	(a,b,c,ctr,y);
  input  ctr;
  input[WIDTH-1:0] a,b,c;
  output[WIDTH-1:0] y;


  assign y = (ctr==0)?a:((ctr==1)?b:c);
endmodule
