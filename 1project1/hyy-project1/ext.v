


module ext#(parameter ORIGIN = 16,parameter WIDTH = 32)(input Extop,input [ORIGIN-1:0]a,output [WIDTH:0]y);


assign y = (Extop == 0) ? { {WIDTH-ORIGIN{1'b0}},a} : { { WIDTH-ORIGIN{a[ORIGIN-1]}},a};

endmodule
