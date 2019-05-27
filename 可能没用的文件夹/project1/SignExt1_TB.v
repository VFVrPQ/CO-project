
module SignExt1_TB();

wire WIDTH;
assign WIDTH = 32;

reg a;
wire [31:0] y;

SignExt1 SE_TB(.a(a),.y(y));
initial 
begin
   a = 0;
   #100 a= ~a;
end
endmodule 