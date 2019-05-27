
module im_4k( addr, dout ) ;
	input   [31:2]  addr ;  // address bus
	output  [31:0]  dout ;  // 32-bit memory output

	reg     [31:0]  im[1023:0] ;
	
	initial 
	begin
		$readmemh("code.txt",im);

		//dout = 32'd0;
	end
	
	assign dout = (addr == 30'b0 ) ? 0 : im[ addr[11:2] ];
endmodule
