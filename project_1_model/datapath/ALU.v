
//ALUctr<2:0>
//OPctr : 00 addiu, add, subu, sub
//        10 sltu, slt
//        01 or
module ALU #(parameter WIDTH = 32) (A,B,ALUctr,Zero,Result);
  input [WIDTH-1:0] A,B;
  input [2:0] ALUctr;
  output Zero;
  output reg [WIDTH-1:0]  Result;
  
  wire [WIDTH-1:0] Ext0,Ext1;
  wire [1:0] OPctr;
  wire SUBctr,SIGctr;
  wire[WIDTH-1:0]  BSignExt ,SUBctrSignExt;
  wire Cin = SUBctr;
  wire Add_Carry,Add_Sign;
  wire[WIDTH-1:0] Add_Result;
  wire CinAdd_Carry;
  wire Less ; 
  wire[WIDTH-1:0] Lessnum;

  assign SUBctr = ALUctr[2];
  assign SIGctr = ALUctr[0];
  assign OPctr[1] = ALUctr[2]&ALUctr[1];
  assign OPctr[0] = !ALUctr[2]&ALUctr[1]&!ALUctr[0];
  assign BSignExt = B ^ SUBctrSignExt;//NewB
  assign CinAdd_Carry = Cin^Add_Carry; //cin^Add_Carry
  
  Ext #(1,WIDTH) b_unSignedExt_Zero(1'b0,1'b1,Ext0);
  Ext #(1,WIDTH) b_unSignedExt_One(1'b0,1'b0,Ext1);//Ext0=32'b0 , Ext1 = 32'b1
  Ext #(1,WIDTH) b_Ext_SUBctr(1'b1,SUBctr,SUBctrSignExt);//get B^SignExt(SUBctr)
  ADDER #WIDTH b_ADDER_AB(A,BSignExt,Cin,Add_Carry,Zero,Add_Sign,Add_Result);//Zero is ok,//adder
  MUX2 #1 b_MUX2_Less(CinAdd_Carry,Add_Sign,SIGctr,Less);
  MUX2 #WIDTH b_MUX2_Lessnum(Ext0,Ext1,Less,Lessnum);
  
  always @ (ALUctr or A or B)
  begin
	case (OPctr)
		2'b00 :assign Result = Add_Result; // add assign is ok? why... I know ,  
		2'b01 :assign Result = A|B;
		2'b10 :assign Result = Lessnum;
	endcase
  end
endmodule
