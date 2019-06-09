module ALU( A, B, ALUctr, zero, overflow, result);

input [31:0]A,B;
input [2:0]ALUctr;
output zero, overflow;
output reg [31:0]result;

wire SUBctr;
wire OVctr;
wire SIGctr;
wire [1:0]OPctr;

wire Cin;
reg  ADD_Carry;
wire ADD_Overflow; 
wire ADD_Sign;
wire CF;
wire SO;
wire less;
wire [31:0]ext0,ext1;

wire [31:0]Ext_result;
wire [31:0]XOR_result;
wire [31:0]Less_result;
reg [31:0]ADD_result;


assign SUBctr = ALUctr[2];
assign OVctr  = !ALUctr[1]&ALUctr[0];
assign SIGctr = ALUctr[0];
assign OPctr[1] = (ALUctr[2]&ALUctr[1])+(ALUctr[1]&ALUctr[0]);
assign OPctr[0] = !ALUctr[2]&ALUctr[1];

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


//
assign overflow = ADD_Overflow & OVctr;

always @ (ALUctr or A or B)
  begin
	case (OPctr)
		2'b00 :assign result = ADD_result; 
		2'b01 :assign result = A|B;
		2'b10 :assign result = Less_result;
		2'b11 :assign result = A&B;
	endcase
  end

endmodule