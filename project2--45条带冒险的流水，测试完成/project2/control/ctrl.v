module ctrl(clk,    op,        func,   ALUctr,
			Branch, Jump,      RegDst, ALUsrc,  MemtoReg, 
			RegWr,  MemWr,     ExtOp,  MemRead, ALUshf,
			R31Wr,  Rb,        cp0Op);//Rb是为了区分分支的BLTZ==BGEZ
									   //cp0Op是MFCO指令的RegWr为1

	input 			 clk;
	input      [5:0] op,func;
	//----{分支BLTZ，BGEZ的区分}begin
	input      [4:0] Rb;
	//----{分支BLTZ，BGEZ的区分}end
	//----{cp0Op是MFCO指令的RegWr为1，其余信号为0}begin
	input      [2:0] cp0Op;
	//----{cp0Op是MFCO指令的RegWr为1，其余信号为0}end
	output reg [3:0] ALUctr;
	output reg [2:0] Branch;
	output reg [1:0] Jump;
	output reg       RegDst;
	output reg		 ALUsrc;//WrEn
	output reg 		 MemtoReg;
	output reg  	 RegWr;
	output reg [1:0] MemWr;
	output reg 		 ExtOp;
	output reg [1:0] MemRead;
	output reg 		 ALUshf;
	output reg 		 R31Wr;

	//*********op*********//
	parameter R     = 6'b000000, ADDIU    = 6'b001001, LUI  = 6'b001111, SLTI = 6'b001010, SLTIU = 6'b001011,
			  ANDI  = 6'b001100, ORI      = 6'b001101, XORI = 6'b001110, BEQ  = 6'b000100, BNE   = 6'b000101,
			  BGEZ  = 6'b000001, BGTZ     = 6'b000111, BLEZ = 6'b000110, BLTZ = 6'b000001, LW    = 6'b100011,//BLTZ==BGEZ
			  SW    = 6'b101011, LB       = 6'b100000, LBU  = 6'b100100, SB   = 6'b101000, J     = 6'b000010,
			  JAL   = 6'b000011, CP0_OP   = 6'b010000;/*{CP0_OP不包括SYSCALL}*/
	//JR = 6'b000000, JALR = 6'b000000

	//********func********// op = 6'b000000
    parameter ADDU = 6'b100001, SUBU = 6'b100011, SLT  = 6'b101010, AND  = 6'b100100, NOR  = 6'b100111,
              OR   = 6'b100101, XOR  = 6'b100110, SLTU = 6'b101011, SLLV = 6'b000100, SRAV = 6'b000111,
              SRLV = 6'b000110, SLL  = 6'b000000, SRL  = 6'b000010, SRA  = 6'b000011, JR   = 6'b001000,
              JALR = 6'b001001;

    //********Mul_func******// op = 6'b000000
	parameter MULT = 6'b011000, MFLO = 6'b010010, MFHI = 6'b010000,
			  MTLO = 6'b010011, MTHI = 6'b010001;

	//********CP0_func{仅SYSCALL}******// op = 6'b000000
	parameter SYSCALL = 6'b001100;

    //*******ALUctr******//
    parameter Addu = 4'b0000, Subu = 4'b0001, Slt = 4'b0010, And = 4'b0011, Nor  = 4'b0100,
    		  Or   = 4'b0101, Xor  = 4'b0110, Sll = 4'b0111, Srl = 4'b1000, Sltu = 4'b1001,
    		  Sra  = 4'b1010, Lui  = 4'b1011, 
    		  Nop  = 4'b0000;

    //*******Initial*****//
    initial begin
    	ALUctr		= 4'd0;
     	Branch		= 3'd0;
    	Jump		= 2'b0;
    	RegDst		= 0;
    	ALUsrc		= 0;
    	MemtoReg	= 0;
    	RegWr 	 	= 0;
    	MemWr		= 2'b0;
    	ExtOp		= 0;
    	MemRead     = 2'b0;
    	ALUshf		= 0;
    end

    //******Always*******//
	always @(*)begin
		//----{R31Wr,写回31号寄存器的控制信号}begin
		if (op == JAL || (op == R && func == JALR)) begin
			R31Wr = 1;
		end else begin
			R31Wr = 0;
		end
		//----{R31Wr,写回31号寄存器的控制信号}end
		case (op)
			R:begin
				//----{JR && JALR}begin
				if (func == JR || func == JALR) begin 
					Branch = 3'b000;
					Jump   = 2'b10;
					RegDst = 0;
					ALUsrc = 0;
						
					MemtoReg = 0;
					RegWr    = 0;
					MemWr    = 0;
					ExtOp    = 0;
					MemRead  = 2'b00;
					ALUshf   = 0;
					case (func)
						JR:   ALUctr = Nop;
						JALR: ALUctr = Nop;
					endcase 
				end 
				//----{JR && JALR}end
				//----{mul}begin
				else if (func == MULT || func == MFLO || func == MFHI || func == MTLO || func == MTHI) begin
					Branch = 3'b000;
					Jump   = 2'b0;
					if (func == MFLO || func == MFHI) RegDst = 1; else RegDst = 0;
					ALUsrc = 0;
						
					MemtoReg = 0;
					if (func == MFLO || func == MFHI) RegWr  = 1; else RegWr  = 0;
					MemWr    = 2'b0;
					ExtOp    = 0;
					MemRead  = 2'b00;			
					ALUshf   = 0;
					ALUctr   = 3'b000;	
				end 
				//----{mul}end
				//----{cp0_SYSCALL}begin
				else if (func == SYSCALL) begin
					Branch = 3'b000;
					Jump   = 2'b0;
					RegDst = 0;
					ALUsrc = 0;
						
					MemtoReg = 0;
					RegWr    = 0;
					MemWr    = 2'b0;
					ExtOp    = 0;
					MemRead  = 2'b00;
					ALUshf   = 0;
					ALUctr   = 3'b000;
				end
				//----{cp0_SYSCALL}end
				//----{R_else}begin
				else begin
					Branch = 3'b000;
					Jump   = 2'b0;
					RegDst = 1;
					ALUsrc = 0;
						
					MemtoReg = 0;
					RegWr    = 1;
					MemWr    = 2'b0;
					ExtOp    = 0;
					MemRead  = 2'b00;
					ALUshf   = (func == 6'b000000) || (func == 6'b000010) || (func == 6'b000011);
					
					case (func)
						ADDU: ALUctr = Addu;
						SUBU: ALUctr = Subu;
						SLT : ALUctr = Slt;
						AND : ALUctr = And;
						NOR : ALUctr = Nor;
						OR  : ALUctr = Or;
						XOR : ALUctr = Xor;
						SLTU: ALUctr = Sltu;
						SLLV: ALUctr = Sll;
						SRAV: ALUctr = Sra;
						SRLV: ALUctr = Srl;
						SLL : ALUctr = Sll;
						SRL : ALUctr = Srl;
						SRA : ALUctr = Sra;
						JR  : ALUctr = Nop;
						JALR: ALUctr = Nop;
						default: ALUctr = Nop;
					endcase 
				end
				//----{R_else}end
			end//end R
			ADDIU:begin
				Branch   = 3'b000;
				Jump     = 2'b0;
				RegDst   = 0;
				ALUsrc   = 1;
					
				MemtoReg = 0;
				RegWr    = 1;
				MemWr    = 2'b0;
				ExtOp    = 1;
				MemRead  = 2'b00;
				ALUshf   = 0;

				ALUctr   = Addu;
			end
			LUI:begin
				Branch   = 3'b000;
				Jump     = 2'b0;
				RegDst   = 0;
				ALUsrc   = 1;
					
				MemtoReg = 0;
				RegWr    = 1;
				MemWr    = 2'b0;
				ExtOp    = 0;
				MemRead  = 2'b00;
				ALUshf   = 0;

				ALUctr   = Lui;
			end 
			SLTI:begin
				Branch   = 3'b000;
				Jump     = 2'b0;
				RegDst   = 0;
				ALUsrc   = 1;
					
				MemtoReg = 0;
				RegWr    = 1;
				MemWr    = 2'b0;
				ExtOp    = 1;
				MemRead  = 2'b00;
				ALUshf   = 0;

				ALUctr   = Slt;
			end
			SLTIU:begin
				Branch   = 3'b000;
				Jump     = 2'b0;
				RegDst   = 0;
				ALUsrc   = 1;
					
				MemtoReg = 0;
				RegWr    = 1;
				MemWr    = 2'b0;
				ExtOp    = 1;
				MemRead  = 2'b00;
				ALUshf   = 0;

				ALUctr   = Sltu;
			end
			ANDI:begin
				Branch   = 3'b000;
				Jump     = 2'b0;
				RegDst   = 0;
				ALUsrc   = 1;
					
				MemtoReg = 0;
				RegWr    = 1;
				MemWr    = 2'b0;
				ExtOp    = 0;
				MemRead  = 2'b00;
				ALUshf   = 0;

				ALUctr   = And;
			end
			ORI:begin
				Branch   = 3'b000;
				Jump     = 2'b0;
				RegDst   = 0;
				ALUsrc   = 1;
					
				MemtoReg = 0;
				RegWr    = 1;
				MemWr    = 2'b0;
				ExtOp    = 0;
				MemRead  = 2'b00;
				ALUshf   = 0;

				ALUctr   = Or;
			end
			XORI:begin
				Branch   = 3'b000;
				Jump     = 2'b0;
				RegDst   = 0;
				ALUsrc   = 1;
					
				MemtoReg = 0;
				RegWr    = 1;
				MemWr    = 2'b0;
				ExtOp    = 0;
				MemRead  = 2'b00;
				ALUshf   = 0;

				ALUctr   = Xor;
			end
			BEQ:begin
				Branch   = 3'b001;
				Jump     = 2'b0;
				RegDst   = 0;
				ALUsrc   = 0;
					
				MemtoReg = 0;
				RegWr    = 0;
				MemWr    = 2'b0;
				ExtOp    = 1;
				MemRead  = 2'b00;
				ALUshf   = 0;

				ALUctr   = Nop;
			end
			BNE:begin
				Branch   = 3'b010;
				Jump     = 2'b0;
				RegDst   = 0;
				ALUsrc   = 0;
					
				MemtoReg = 0;
				RegWr    = 0;
				MemWr    = 2'b0;
				ExtOp    = 1;
				MemRead  = 2'b00;
				ALUshf   = 0;

				ALUctr   = Nop;
			end
			BGEZ:begin//BLTZ==BGEZ，所以只写一个就可以了
				if (Rb == 5'b00001)      Branch = 3'b011;
				else if (Rb == 5'b00000) Branch = 3'b110;  

				Jump     = 2'b0;
				RegDst   = 0;
				ALUsrc   = 0;
					
				MemtoReg = 0;
				RegWr    = 0;
				MemWr    = 2'b0;
				ExtOp    = 1;
				MemRead  = 2'b00;
				ALUshf   = 0;			

				ALUctr   = Nop;
			end
			BGTZ:begin
				Branch   = 3'b100;
				Jump     = 2'b0;
				RegDst   = 0;
				ALUsrc   = 0;
					
				MemtoReg = 0;
				RegWr    = 0;
				MemWr    = 2'b0;
				ExtOp    = 1;
				MemRead  = 2'b00;
				ALUshf   = 0;

				ALUctr   = Nop;
			end
			BLEZ:begin
				Branch   = 3'b101;
				Jump     = 2'b0;
				RegDst   = 0;
				ALUsrc   = 0;
					
				MemtoReg = 0;
				RegWr    = 0;
				MemWr    = 2'b0;
				ExtOp    = 1;
				MemRead  = 2'b00;
				ALUshf   = 0;

				ALUctr   = Nop;
			end
			LW:begin
				Branch   = 3'b000;
				Jump     = 2'b0;
				RegDst   = 0;
				ALUsrc   = 1;
					
				MemtoReg = 1;
				RegWr    = 1;
				MemWr    = 2'b0;
				ExtOp    = 1;
				MemRead  = 2'b01;
				ALUshf   = 0;

				ALUctr   = Addu;
			end
			SW:begin
				Branch   = 3'b000;
				Jump     = 2'b0;
				RegDst   = 0;
				ALUsrc   = 1;
					
				MemtoReg = 0;
				RegWr    = 0;
				MemWr    = 2'b01;
				ExtOp    = 1;
				MemRead  = 2'b00;
				ALUshf   = 0;

				ALUctr   = Addu;
			end
			LB:begin
				Branch   = 3'b000;
				Jump     = 2'b0;
				RegDst   = 0;
				ALUsrc   = 1;
					
				MemtoReg = 1;
				RegWr    = 1;
				MemWr    = 2'b0;
				ExtOp    = 1;
				MemRead  = 2'b10;
				ALUshf   = 0;

				ALUctr   = Addu;
			end
			LBU:begin
				Branch   = 3'b000;
				Jump     = 2'b0;
				RegDst   = 0;
				ALUsrc   = 1;
					
				MemtoReg = 1;
				RegWr    = 1;
				MemWr    = 2'b0;
				ExtOp    = 1;
				MemRead  = 2'b11;
				ALUshf   = 0;

				ALUctr   = Addu;
			end
			SB:begin
				Branch   = 3'b000;
				Jump     = 2'b0;
				RegDst   = 0;
				ALUsrc   = 1;
					
				MemtoReg = 0;
				RegWr    = 0;
				MemWr    = 2'b10;
				ExtOp    = 1;
				MemRead  = 2'b00;
				ALUshf   = 0;

				ALUctr   = Addu;
			end
			J:begin
				Branch   = 3'b000;
				Jump     = 2'b01;
				RegDst   = 0;
				ALUsrc   = 0;
					
				MemtoReg = 0;
				RegWr    = 0;
				MemWr    = 2'b00;
				ExtOp    = 0;
				MemRead  = 2'b00;
				ALUshf   = 0;

				ALUctr   = Nop;
			end
			JAL:begin
				Branch   = 3'b000;
				Jump     = 2'b01;
				RegDst   = 0;
				ALUsrc   = 0;
					
				MemtoReg = 0;
				RegWr    = 0;
				MemWr    = 2'b00;
				ExtOp    = 0;
				MemRead  = 2'b00;
				ALUshf   = 0;

				ALUctr   = Nop;
			end
			CP0_OP:begin
				Branch   = 3'b000;
				Jump     = 2'b00;
				RegDst   = 0;//rt
				ALUsrc   = 0;
					
				MemtoReg = 0;
				if (cp0Op == 3'b001) RegWr = 1; else RegWr = 0;
				MemWr    = 2'b00;
				ExtOp    = 0;
				MemRead  = 2'b00;
				ALUshf   = 0;

				ALUctr   = Nop;				
			end
			default:begin
				Branch   = 3'b000;
				Jump     = 2'b00;
				RegDst   = 0;
				ALUsrc   = 0;
					
				MemtoReg = 0;
				RegWr    = 0;
				MemWr    = 2'b00;
				ExtOp    = 0;
				MemRead  = 2'b00;
				ALUshf   = 0;

				ALUctr   = Nop;				
			end
		endcase
	end
endmodule 