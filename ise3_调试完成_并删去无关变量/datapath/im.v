`timescale 1ns / 1ps
module im_4k( addr, dout ) ;
	input   [31:2]  addr ;  // address bus
	output  [31:0]  dout ;  // 32-bit memory output

	reg     [31:0]  im[127:0] ;
	
	integer i;
	initial 
	begin
		for (i=0;i<128;i=i+1) im[i] = 32'b0;

		$readmemh("code.txt",im);
	end
	
	assign dout = im[ addr[8:2] ];
endmodule
