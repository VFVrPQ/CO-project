

module rf(Clk,WrEn,Ra,Rb,Rw,busW,busA,busB);

input Clk,WrEn;
input [4:0]Rw,Ra,Rb;
input [31:0]busW;
output [31:0]busA,busB;

reg[31:0] Rf[31:0];

assign busA = (Ra != 0) ? Rf[Ra] : 0;
assign busB = (Rb != 0) ? Rf[Rb] : 0;

integer i;

initial
begin 
	for (i=0;i<32;i=i+1)
	      Rf[i] = 32'd0;
	/*
	Rf[0] = 32'd0;
	Rf[1] = 32'd1;
	Rf[8]  = 32'h0000_0001;
	Rf[11] = 32'h0000_1111;
	Rf[12] = 32'h0000_0000;

	Rf[18] = 32'h0000_0000;		
	Rf[19] = 32'h0000_0000;

	Rf[20] = 32'h0000_000a;		
	Rf[21] = 32'h0000_0005;*/
end

always @ (negedge Clk)
	if(WrEn)
		Rf[Rw] <= busW;

endmodule

