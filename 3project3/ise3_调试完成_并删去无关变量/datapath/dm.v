`timescale 1ns / 1ps
module dm_4k( addr, din, we, clk, dout, memRead, mem_addr, mem_data, Reset) ;
	input      [11:0]  addr ;  // address bus  ,[11:2] -> [11:0]
    input      [31:0]  din ;   // 32-bit input data
    input      [ 1:0]  we ;    // memory write enable
    input              clk ;   // clock
    input      [ 1:0]  memRead;
    input              Reset;

	output reg [31:0]  dout ;  // 32-bit memory output

	reg        [31:0]  dm[127:0] ;
	
	integer d;


   //----{ISE}begin
   	input      [31:0]  mem_addr;
   	output reg [31:0]  mem_data;

   	always @(*) begin 
   		mem_data <= dm[ mem_addr[8:2] ];
   	end
   //----{ISE}end

	initial begin
		for (d=0;d<128;d=d+1)
			dm[d] = 32'h0000_0000;
	end
	

	/*always @(posedge clk) begin 
		if(Reset) begin
			for (d=0;d<128;d=d+1)
				dm[d] <= 32'h0000_0000;	
		end 
	end*/
	//************数据写入存储�**********//
	always @(posedge clk)//!!!后半周期
	begin
		//*******SW*********//
		if (we == 2'b01) dm[ addr[8:2] ] <= din; 
		//*******SB*********//			
		else if (we == 2'b10) begin
			if (addr[1:0] == 2'b00) dm[ addr[8:2] ][ 7: 0] <= din[7:0];else 
			if (addr[1:0] == 2'b01) dm[ addr[8:2] ][15: 8] <= din[7:0];else 
			if (addr[1:0] == 2'b10) dm[ addr[8:2] ][23:16] <= din[7:0];else 
			if (addr[1:0] == 2'b11) dm[ addr[8:2] ][31:24] <= din[7:0];
			/*if (addr[1:0] == 2'b00) dm[ addr[8:2] ] <= {24'd0, din[7:0]};else 
			if (addr[1:0] == 2'b01) dm[ addr[8:2] ] <= {16'd0, din[7:0], 8'd0};else 
			if (addr[1:0] == 2'b10) dm[ addr[8:2] ] <= {8'd0,  din[7:0], 16'd0};else 
			if (addr[1:0] == 2'b11) dm[ addr[8:2] ] <= {din[7:0], 24'd0};*/
		end
	end

	//************存储器读出数�**********//
	/*wire [7:0] d0 = dm[ addr[8:2] ][ 7: 0];
	wire [7:0] d1 = dm[ addr[8:2] ][15: 8];
	wire [7:0] d2 = dm[ addr[8:2] ][23:16];
	wire [7:0] d3 = dm[ addr[8:2] ][31:24];*/
	always @(*) begin
		//******NO********//
		if (memRead == 2'b00) begin
			dout <= 32'b0;
		end else 
		//******LW********//
		if (memRead == 2'b01) begin
			dout <= dm[ addr[8:2] ];
		end else 
		//******LB********//
		if (memRead == 2'b10) begin
			if (addr[1:0] == 2'b00) begin
				dout <= { {24{dm[ addr[8:2] ][7]}}, dm[ addr[8:2] ][ 7: 0]};
			end else 
			if (addr[1:0] == 2'b01) begin
				dout <= { {24{dm[ addr[8:2] ][15]}}, dm[ addr[8:2] ][15: 8]};
			end else 
			if (addr[1:0] == 2'b10) begin
				dout <= { {24{dm[ addr[8:2] ][23]}}, dm[ addr[8:2] ][23:16]};
			end else
			if (addr[1:0] == 2'b11) begin
				dout <= { {24{dm[ addr[8:2] ][31]}}, dm[ addr[8:2] ][31:24]};
			end
		end else 
		//******LBU*******//
		if (memRead == 2'b11) begin
			if (addr[1:0] == 2'b00) begin
				dout <= { 24'b0, dm[ addr[8:2] ][ 7: 0]};
			end else 
			if (addr[1:0] == 2'b01) begin
				dout <= { 24'b0, dm[ addr[8:2] ][15: 8]};
			end else 
			if (addr[1:0] == 2'b10) begin
				dout <= { 24'b0, dm[ addr[8:2] ][23:16]};
			end else
			if (addr[1:0] == 2'b11) begin
				dout <= { 24'b0, dm[ addr[8:2] ][31:24]};
			end
		end
	end
endmodule 