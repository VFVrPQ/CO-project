

module ALU #(parameter WIDTH = 32)
	(A,B,ALUctr,Zero,Overflow,Result);//no Overflow
  //define
  input [WIDTH-1:0] A,B;
  input [2:0] ALUctr;
  output Zero;
  output Overflow;
  output reg [WIDTH-1:0] Result;
  
  wire [WIDTH-1:0] Ext0,Ext1;

  wire zeroEx;wire oneEx;
  assign zeroEx = 0;
  assign oneEx = 1;
  SignExt1 #WIDTH SignExt_Zero(zeroEx,Ext0);//32{0}
  SignExt1 #WIDTH SignExt_One(oneEx,Ext1);//32{1}

  //wire
  wire SUBctr,OVctr,SIGctr;
  wire [1:0] OPctr;

  assign SUBctr = ALUctr[2];
  assign OVctr = !ALUctr[1]&ALUctr[0];//no use
  assign SIGctr = ALUctr[0];
  assign OPctr[1] = ALUctr[2]&ALUctr[1];
  assign OPctr[0] = !ALUctr[2]&ALUctr[1]&!ALUctr[0];

  //get B^SignExt(SUBctr)
  wire[WIDTH-1:0] SUBctrSignExt;
  SignExt1 #WIDTH SE1_SUBctr(SUBctr,SUBctrSignExt);
  
  wire[WIDTH-1:0] BSignExt;
  assign BSignExt = B ^ SUBctrSignExt;//NewB

  wire Cin ; 
  assign Cin = SUBctr;

  //adder
  wire Add_Carry,Add_Overflow,Add_Sign;
  wire[WIDTH-1:0] Add_Result;
  ADDER #WIDTH ADDER_AB(A,BSignExt,Cin,Add_Carry,Zero,Add_Overflow,Add_Sign,Add_Result);//Zero is ok
  
  wire Overflow = OVctr & Add_Overflow; // Overflow is ok

  //cin^Add_Carry 
  wire CinAdd_Carry;
  assign CinAdd_Carry = Cin^Add_Carry;

  //
  wire Add_OverflowAdd_Sign;
  assign Add_OverflowAdd_Sign = Add_Overflow^Add_Sign;

  //compare
  wire Less ; 
  MUX2 #1 MUX2_Less(CinAdd_Carry,Add_OverflowAdd_Sign,SIGctr,Less);
  
  //
  wire[WIDTH-1:0] Lessnum;
  MUX2 #WIDTH MUX2_Lessnum(Ext0,Ext1,Less,Lessnum);
  //Zero is ok

  always @ (ALUctr or A or B)
  begin
    case(OPctr)
      2'b00: assign Result = Add_Result;
      2'b01: assign Result = A|B;
      2'b10: assign Result = Lessnum;
      default: assign Result = Ext0;
    endcase	
  end
endmodule
