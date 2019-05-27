
module im_4k( addr, dout ) ;
	input   [31:2]  addr ;  // address bus
	output  [31:0]  dout ;  // 32-bit memory output

	reg     [31:0]  im[1023:0] ;
	
	integer i;
	initial 
	begin
		for (i=0;i<1024;i=i+1) im[i] = 32'b0;

		$readmemh("code.txt",im);
	end
	
	assign dout = (addr == 30'b0 ) ? 0 : im[ addr[11:2] ];
endmodule
