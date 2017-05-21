module MUX2 #(parameter WIDTH = 32)
	(a,b,ctr,y);
  input  ctr;
  input[WIDTH-1:0] a,b;
  output[WIDTH-1:0] y;

  assign y = (ctr==1)?b:a;
endmodule

