
module ctrl( op, func, RegWr, RegDst, ExtOp, ALUSrc, branop, Branch, Jump, MemWr, MemtoReg);

input [5:0]op,func;
input [4:0]branop;
output reg RegWr,  ALUSrc, ExtOp;
output reg [1:0] Jump,RegDst;
output reg [1:0] MemtoReg;
output reg [2:0] Branch,MemWr;


parameter R = 6'b000000, LW = 6'b100011, ORI = 6'b001101, ADDIU = 6'b001001, SW = 6'b101011, BEQ = 6'b000100, J = 6'b000010, ADDI = 6'b001000;
parameter BNE = 6'b000101, LUI = 6'b001111, SLTI = 6'b001010, SLTIU = 6'b001011;
parameter BEGZ = 6'b000001, BGTZ = 6'b000111, BLEZ = 6'b000110, BLTZ = 6'b000001;
parameter LB = 6'b100000, LBU = 6'b100100, SB = 6'b101000;
parameter ANDI = 6'b001100, XORI = 6'b001110;
parameter JAL = 6'b000011;

initial begin
	assign RegWr    = 0;
        assign RegDst   = 00; 
        assign ExtOp    = 0;
        assign ALUSrc   = 0;
        assign Branch   = 000;
      //  assign Jump     = 00;
        
        assign MemWr    = 000;
        assign MemtoReg = 00;
end

always @(*)begin
    
    case(op)
    R:begin//R  add,sub,addu,slt,or,and
        assign RegWr    = (func==6'b001000) ? 0:1;
       // assign RegDst   = 01; 
        assign ExtOp    = 0;//x
        assign ALUSrc   = 0;
        assign Branch   = 000;
        //assign Jump     = 00;
        assign MemWr    = 000;
        //assign MemtoReg = 00;
        assign Jump = (func==6'b001001||func==6'b001000)  ? 2'b10 : 2'b00;
        assign RegDst = (func==6'b001001)  ? 2'b10 : 2'b01;
        assign MemtoReg = (func==6'b001001)  ? 2'b11 : 2'b00;
    end
    ORI:begin//ori
        assign RegWr    = 1;
        assign RegDst   = 00; 
        assign ExtOp    = 0;
        assign ALUSrc   = 1;
        assign Branch   = 000;
        assign Jump     = 00;
        assign MemWr    = 000;
        assign MemtoReg = 00;
    end
    ADDIU:begin//addiu
        assign RegWr    = 1;
        assign RegDst   = 00; 
        assign ExtOp    = 1;
        assign ALUSrc   = 1;
        assign Branch   = 000;
        assign Jump     = 00;
        assign MemWr    = 000;
        assign MemtoReg = 00;
    end
    LW:begin//lw
        assign RegWr    = 1;
        assign RegDst   = 00; 
        assign ExtOp    = 1;
        assign ALUSrc   = 1;
        assign Branch   = 000;
        assign Jump     = 00;
        assign MemWr    = 000;
        assign MemtoReg = 01;
    end
    SW:begin//sw
        assign RegWr    = 0;
        assign RegDst   = 00;//x
        assign ExtOp    = 1;
        assign ALUSrc   = 1;
        assign Branch   = 000;
        assign Jump     = 00;
        assign MemWr    = 001;
        assign MemtoReg = 00;//x
    end
    J:begin//jump
        assign RegWr    = 0;
        assign RegDst   = 00;//x 
        assign ExtOp    = 0;//x
        assign ALUSrc   = 0;//x
        assign Branch   = 000;
        assign Jump     = 01;
        assign MemWr    = 000;
        assign MemtoReg = 00;//x
    end
    ADDI:begin//addi
        assign RegWr    = 1;
        assign RegDst   = 00;//x 
        assign ExtOp    = 1;//x
        assign ALUSrc   = 1;//x
        assign Branch   = 000;
        assign Jump     = 00;
        assign MemWr    = 000;
        assign MemtoReg = 00;//x
    end
    BEQ:begin//beq
        assign RegWr    = 0;
        assign RegDst   = 00;//x
        assign ExtOp    = 0;//x
        assign ALUSrc   = 0;
        assign Branch   = 001;
        assign Jump     = 00;
        assign MemWr    = 000;
        assign MemtoReg = 00;//x
    end
    BNE:begin//beq
        assign RegWr    = 0;
        assign RegDst   = 00;//x
        assign ExtOp    = 0;//x
        assign ALUSrc   = 0;
        assign Branch   = 010;
        assign Jump     = 00;
        assign MemWr    = 000;
        assign MemtoReg = 00;//x
    end
    
    BEGZ:begin//beq
        assign RegWr    = 0;
        assign RegDst   = 00;//x
        assign ExtOp    = 0;//x
        assign ALUSrc   = 0;
        assign Branch   = (branop==5'b00001) ? 3'b011:3'b110;
        assign Jump     = 00;
        assign MemWr    = 000;
        assign MemtoReg = 00;//x
    end
    BGTZ:begin//beq
        assign RegWr    = 0;
        assign RegDst   = 00;//x
        assign ExtOp    = 0;//x
        assign ALUSrc   = 0;
        assign Branch   = 100;
        assign Jump     = 00;
        assign MemWr    = 000;
        assign MemtoReg = 00;//x
    end    
    BLEZ:begin//beq
        assign RegWr    = 0;
        assign RegDst   = 00;//x
        assign ExtOp    = 0;//x
        assign ALUSrc   = 0;
        assign Branch   = 101;
        assign Jump     = 00;
        assign MemWr    = 000;
        assign MemtoReg = 00;//x
    end
    SLTI:begin
        assign RegWr    = 1;
        assign RegDst   = 00;//x
        assign ExtOp    = 1;//x
        assign ALUSrc   = 1;
        assign Branch   = 000;
        assign Jump     = 00;
        assign MemWr    = 000;
        assign MemtoReg = 00;//x
    end
    SLTIU:begin
        assign RegWr    = 1;
        assign RegDst   = 00;//x
        assign ExtOp    = 1;//x
        assign ALUSrc   = 1;
        assign Branch   = 000;
        assign Jump     = 00;
        assign MemWr    = 000;
        assign MemtoReg = 00;//x
    end
    ANDI:begin
        assign RegWr    = 1;
        assign RegDst   = 00;//x
        assign ExtOp    = 0;//x
        assign ALUSrc   = 1;
        assign Branch   = 000;
        assign Jump     = 00;
        assign MemWr    = 000;
        assign MemtoReg = 00;//x
    end
    XORI:begin
        assign RegWr    = 1;
        assign RegDst   = 00;//x
        assign ExtOp    = 0;//x
        assign ALUSrc   = 1;
        assign Branch   = 000;
        assign Jump     = 00;
        assign MemWr    = 000;
        assign MemtoReg = 00;//x
    end
    LUI:begin
        assign RegWr    = 1;
        assign RegDst   = 00;//x
        assign ExtOp    = 0;//x
        assign ALUSrc   = 0;
        assign Branch   = 000;
        assign Jump     = 00;
        assign MemWr    = 000;
        assign MemtoReg = 10;
    end
    
    LB:begin
        assign RegWr    = 1;
        assign RegDst   = 00;
        assign ExtOp    = 1;
        assign ALUSrc   = 1;
        assign Branch   = 000;
        assign Jump     = 00;
        assign MemWr    = 010;
        assign MemtoReg = 01;
    end

    LBU:begin
        assign RegWr    = 1;
        assign RegDst   = 00;
        assign ExtOp    = 1;
        assign ALUSrc   = 1;
        assign Branch   = 000;
        assign Jump     = 00;
        assign MemWr    = 011;
        assign MemtoReg = 01;
    end
    
    SB:begin
        assign RegWr    = 1;
        assign RegDst   = 00;//x
        assign ExtOp    = 1;
        assign ALUSrc   = 1;
        assign Branch   = 000;
        assign Jump     = 00;
        assign MemWr    = 101;
        assign MemtoReg = 00;//x
    end

        
    JAL:begin
        assign RegWr    = 1;
        assign RegDst   = 10;//x
        assign ExtOp    = 0;
        assign ALUSrc   = 0;
        assign Branch   = 000;
        assign Jump     = 01;
        assign MemWr    = 000;
        assign MemtoReg = 11;//x
    end
        

    endcase

end



endmodule