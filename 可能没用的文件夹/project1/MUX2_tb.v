module testbench();

reg a, b,ctr;
MUX2 an(.a(a),.b(b),.ctr(ctr),.y(out));

initial
begin
a = 1'b0; 
b = 1'b1;
ctr = 1'b0;
end

always #20 ctr = ~ctr;
endmodule
