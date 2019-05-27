
module dm_4k( addr, din, we, clk, dout, memRead ) ;
	input      [11:0]  addr ;  // address bus  ,[11:2] -> [11:0]
    input      [31:0]  din ;   // 32-bit input data
    input      [1 :0]  we ;    // memory write enable
    input              clk ;   // clock
    input      [1 :0]  memRead;

	output reg [31:0]  dout ;  // 32-bit memory output

	reg        [31:0]  dm[1023:0] ;
	
	integer d;

	initial begin
		for (d=0;d<1024;d=d+1)
			dm[d] = 32'h0000_0000;
	end
	

	//************数据写入存储器***********//
	always @(negedge clk)//!!!后半周期
	begin
		//*******SW*********//
		if (we == 2'b01) dm[ addr[11:2] ] <= din; 
		//*******SB*********//			
		else if (we == 2'b10) begin
			if (addr[1:0] == 2'b00) dm[ addr[11:2] ][ 7: 0] <= din[7:0];else 
			if (addr[1:0] == 2'b01) dm[ addr[11:2] ][15: 8] <= din[7:0];else 
			if (addr[1:0] == 2'b10) dm[ addr[11:2] ][23:16] <= din[7:0];else 
			if (addr[1:0] == 2'b11) dm[ addr[11:2] ][31:24] <= din[7:0];
		end
	end

	//************存储器读出数据***********//
	wire [7:0] d0 = dm[ addr[11:2] ][ 7: 0];
	wire [7:0] d1 = dm[ addr[11:2] ][15: 8];
	wire [7:0] d2 = dm[ addr[11:2] ][23:16];
	wire [7:0] d3 = dm[ addr[11:2] ][31:24];
	always @(*) begin
		//******NO********//
		if (memRead == 2'b00) begin
			assign dout = 32'b0;
		end else 
		//******LW********//
		if (memRead == 2'b01) begin
			assign dout = dm[ addr[11:2] ];
		end else 
		//******LB********//
		if (memRead == 2'b10) begin
			if (addr[1:0] == 2'b00) begin
				assign dout = { {24{d0[7]}}, d0};
			end else 
			if (addr[1:0] == 2'b01) begin
				assign dout = { {24{d1[7]}}, d1};
			end else 
			if (addr[1:0] == 2'b10) begin
				assign dout = { {24{d2[7]}}, d2};
			end else
			if (addr[1:0] == 2'b11) begin
				assign dout = { {24{d3[7]}}, d3};
			end
		end else 
		//******LBU*******//
		if (memRead == 2'b11) begin
			if (addr[1:0] == 2'b00) begin
				assign dout = { 24'b0, d0};
			end else 
			if (addr[1:0] == 2'b01) begin
				assign dout = { 24'b0, d1};
			end else 
			if (addr[1:0] == 2'b10) begin
				assign dout = { 24'b0, d2};
			end else
			if (addr[1:0] == 2'b11) begin
				assign dout = { 24'b0, d3};
			end
		end
	end
endmodule 