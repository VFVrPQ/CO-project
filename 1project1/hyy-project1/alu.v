module ALU( A, B, C, ALUctr, zero, overflow, result);

input [31:0]A,B;
input [4:0]C;
input [3:0]ALUctr;
output zero, overflow;
output reg [31:0]result;

wire SUBctr;
wire OVctr;
wire SIGctr;
wire [2:0]OPctr;
wire [2:0]Shfctr;

wire Cin;
reg  ADD_Carry;
wire ADD_Overflow; 
wire ADD_Sign;
wire CF;
wire SO;
wire less;
wire [31:0]ext0,ext1;
wire [31:0]shf;

wire [31:0]Ext_result;
wire [31:0]XOR_result;
wire [31:0]Less_result;
reg [31:0]Shf_result;
reg [31:0]ADD_result;


assign SUBctr = ALUctr[2];
assign OVctr  = !ALUctr[1]&ALUctr[0];
assign SIGctr = ALUctr[0];
assign OPctr[2] = ALUctr[3];
assign OPctr[1] = (!ALUctr[3]&ALUctr[2]&ALUctr[1])+(ALUctr[3]&!ALUctr[2]&ALUctr[1])+(!ALUctr[3]&!ALUctr[2]&ALUctr[1]&ALUctr[0])+(ALUctr[3]&ALUctr[2]);
assign OPctr[0] = (!ALUctr[3]&!ALUctr[2]&ALUctr[1])+(ALUctr[3]&!ALUctr[2]&!ALUctr[1]&ALUctr[0]);
assign Shfctr[2] = (ALUctr[3]&ALUctr[2]&ALUctr[1])+(ALUctr[3]&ALUctr[2]&!ALUctr[1]&!ALUctr[0]);
assign Shfctr[1] = (ALUctr[3]&ALUctr[2]&!ALUctr[1]&ALUctr[0])+(ALUctr[3]&ALUctr[2]&ALUctr[1]&!ALUctr[0]);
assign Shfctr[0] = (ALUctr[3]&ALUctr[2]&!ALUctr[1]&ALUctr[0])+(ALUctr[3]&!ALUctr[2]&ALUctr[1]&ALUctr[0])+(ALUctr[3]&ALUctr[2]&ALUctr[1]);

//add
assign Cin = SUBctr;
ext #(1,32) ext_Ext_result(SUBctr,SUBctr,Ext_result);
assign XOR_result[31:0] = B[31:0]^Ext_result[31:0];

always @ (A or B or Cin)
begin
		assign{ADD_Carry, ADD_result} = A + XOR_result + Cin;
end

assign ADD_Sign = ADD_result[31];
assign zero = (ADD_result==32'b0) ? 1:0;
assign ADD_Overflow = A[31]^XOR_result[31]^ADD_result[31]^ADD_Carry;

//slt sltu
assign CF = Cin^ADD_Carry;
assign SO = ADD_Sign^ADD_Overflow;
ext #(1,32) get_ext0(1'b0,1'b0,ext0);
ext #(1,32) get_Ext1(1'b0,1'b1,ext1);
MUX2  #1 mux_less(CF,SO,SIGctr,less);
MUX2  #32 smux_Less_result(ext0,ext1,less,Less_result);


//sll srl sllv sra srav srlv
assign shf = (Shfctr[2]==1)? A:C;
wire [63:0] temp;
assign temp = {   {32{B[31]}},B[31:0]}>>shf;
always @ (Shfctr or shf or B)
  begin
	case (Shfctr[1:0])
		2'b00 : assign  Shf_result[31:0] = B<<shf;
		2'b01 : assign  Shf_result[31:0] = B>>shf;
		2'b11 :	assign  Shf_result[31:0] = temp[31:0];
		//( { {31{B}}, 1'b0 } << (~shf[4:0]) ) | ( B >> shf ); 
endcase
  end


//final result
assign overflow = ADD_Overflow & OVctr;

always @ (ALUctr or A or B or C)
  begin
	case (OPctr)
		3'b000 :assign result = ADD_result; 
		3'b001 :assign result = A|B;
		3'b010 :assign result = Less_result;
		3'b011 :assign result = A&B;
		3'b100 :assign result = ~(A|B);
		3'b101 :assign result = A^B;
		3'b110 :assign result = Shf_result;
	endcase
  end

endmodule