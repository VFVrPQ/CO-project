
module dm_4k( addr, din, we, clk, dout ) ;
	input   [11:2]  addr ;  // address bus
    input   [31:0]  din ;   // 32-bit input data
    input           we ;    // memory write enable
    input           clk ;   // clock
	output  [31:0]  dout ;  // 32-bit memory output

	reg     [31:0]  dm[1023:0] ;
	
	integer d;

	initial begin
		for (d=0;d<1024;d=d+1)
			dm[d] = 32'h0000_0000;
	end
	assign  dout = dm[ addr[11:2] ];
	always @(negedge clk)//!!!后半周期
	begin
		if (we) dm[ addr[11:2] ] <= din;
	end
endmodule 