
module dm_4k( addr, din, we, clk, dout ) ;     

input   [11:0]  addr ;  // address bus 
input   [31:0]  din ;   // 32-bit input data     
input	[2:0]    we ;    // memory write enable     
input           clk ;   // clock 
output  reg [31:0]  dout ;  // 32-bit memory output   

wire [31:0] dout1;
reg  [31:0]  dm[1023:0] ; 

integer d;

initial 
begin 
	for (d=0;d<1024;d=d+1)
		dm[d] = 32'h0000_0000;
end

assign dout1 = dm[addr[11:2]];

always @ (we or addr)
  begin
	case (we[2:0])
		3'b000 : assign  dout = dout1;
		3'b010 : begin
			if(addr[1:0]==2'b00)	assign dout =  {	{	24{dout1[7]}},	dout1[7:0]};
			else if(addr[1:0]==2'b01)	assign dout =  {	{	24{dout1[15]}},	dout1[15:8]};
			else if(addr[1:0]==2'b10)	assign dout =  {	{	24{dout1[23]}},	dout1[23:16]};
			else if(addr[1:0]==2'b11)	assign dout =  {	{	24{dout1[31]}},	dout1[31:24]};
		end
		3'b011 :	begin
			if(addr[1:0]==2'b00)	assign dout =  {	{	24{1'b0}},	dout1[7:0]};
			else if(addr[1:0]==2'b01)	assign dout =  {	{	24{1'b0}},	dout1[15:8]};
			else if(addr[1:0]==2'b10)	assign dout =  {	{	24{1'b0}},	dout1[23:16]};
			else if(addr[1:0]==2'b11)	assign dout =  {	{	24{1'b0}},	dout1[31:24]};
		end
endcase
  end

always @ (negedge clk)
begin

	if(we==3'b001)
		dm[addr[11:2]] <= din;
	else if(we==3'b101)
	begin
		if(addr[1:0]==2'b00)	 dm[addr[11:2]][7:0] =  din[7:0];
		else if(addr[1:0]==2'b01)	 dm[addr[11:2]][15:8] = din[7:0];
		else if(addr[1:0]==2'b10)	 dm[addr[11:2]][23:16] =  din[7:0];
		else if(addr[1:0]==2'b11)	 dm[addr[11:2]][31:24] =  din[7:0];
	end
end

endmodule
