`timescale 1ns / 1ps
module CP0( clk, cs, sel, busB, cp0Op, cp0OutToReg, cp0OutToPC, PC);
	input             clk;
	input      [ 4:0] cs;
	input      [ 2:0] sel;
	input      [31:0] busB;
	input      [ 2:0] cp0Op;
	input      [31:2] PC;

	output reg [31:0] cp0OutToReg;
	output reg [31:0] cp0OutToPC;

	//reg [31:0] C[0:255]; // only use {12,3'b0} = 96;
						 //          {13,3'b0} = 104;
						 //          {14,3'b0} = 112;
	reg [31:0] C96;
	reg [31:0] C104;
	reg [31:0] C112;

	//integer i;
	initial begin
		//for (i=0;i<256;i=i+1) C[i] = 32'b0;
		C96         = 32'b0;
		C104		= 32'b0;
		C112        = 32'b0;
		cp0OutToPC  = 32'b0;
		cp0OutToReg = 32'b0;
	end

	wire [ 7:0] addr = { cs, sel };

	wire [31:0] C_mid;
	wire [31:0] C112_mid;
	assign C_mid    = (( addr == 8'd96  ) ? C96  :
				      (( addr == 8'd104 ) ? C104 :
				      (( addr == 8'd112 ) ? C112 : 32'd0)));
	assign C112_mid = C112;

	//-----{从cp0寄存器读出}begin
	always @(*) begin 
		//******MFCO********//
		if (cp0Op == 3'b001)  begin
			cp0OutToReg <= C_mid;
			/*case (addr)
				8'd96 : cp0OutToReg <= C96;
				8'd104: cp0OutToReg <= C104;
				8'd112: cp0OutToReg <= C112;
			endcase // addr*/
		end
		//*****ERET*********//
		else if (cp0Op == 3'b100)  begin
			cp0OutToPC  <= C112_mid;// {14,3'b0} = 112
		end 
    end
    //-----{从cp0寄存器读出}end

    //-----{写入cp0寄存器}begin
    always @(posedge clk) begin
    	//******MTCO********//
		if (cp0Op == 3'b010)  begin
			//C[addr] <= busB;
			case (addr)
				8'd96 : C96  <= busB;
				8'd104: C104 <= busB;
				8'd112: C112 <= busB;
			endcase // addr
		end
		//******SYSCALL*****//
		else if (cp0Op == 3'b011)  begin
			C112      <= { PC, 2'b0 };
			C104[6:2] <= 5'b01000;
			C96 [1]   <= 1'b1;
		end
		//*****ERET*********//
		else if (cp0Op == 3'b100)  begin
			C96[1]      <= 0;
		end 
    end
    //-----{写入cp0寄存器}end
	
endmodule 