
module ctrl( op, RegWr, RegDst, ExtOp, ALUSrc, Branch, Jump, MemWr, MemtoReg);

input [5:0]op;
output reg RegWr, RegDst, ExtOp, ALUSrc, Branch, Jump, MemWr, MemtoReg;


parameter R = 6'b000000, LW = 6'b100011, ORI = 6'b001101, ADDIU = 6'b001001, SW = 6'b101011, BEQ = 6'b000100, J = 6'b000010, ADDI = 6'b001000;

initial begin
	assign RegWr    = 0;
        assign RegDst   = 0; 
        assign ExtOp    = 0;
        assign ALUSrc   = 0;
        assign Branch   = 0;
        assign Jump     = 0;
        assign MemWr    = 0;
        assign MemtoReg = 0;
end

always @(*)begin

/*
    //Branch = beq
    assign Branch   = !op[5]&!op[4]&!op[3]&op[2]&!op[1]&!op[0];
    //Jump = jump
    assign Jump     = !op[5]&!op[4]&!op[3]&!op[2]&op[1]&!op[0];
    //RegDst = R-type
    assign RegDst   = !op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0]; 
    //ALUsrc = ori+addiu+lw+sw
    assign ALUsrc   = !op[5]&!op[4]&op[3]&op[2]&!op[1]&op[0]+!op[5]&!op[4]&op[3]&!op[2]&!op[1]&op[0]+op[5]&!op[4]&!op[3]&!op[2]&op[1]&op[0]+op[5]&!op[4]&op[3]&!op[2]&op[1]&op[0];
    //Memtoreg = lw
    assign MemtoReg = op[5]&!op[4]&!op[3]&!op[2]&op[1]&op[0];
    //RegWr = R-type+ori+addiu+lw
    assign RegWr    = !op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0]+!op[5]&!op[4]&op[3]&op[2]&!op[1]&op[0]+!op[5]&!op[4]&op[3]&!op[2]&!op[1]&op[0]+op[5]&!op[4]&!op[3]&!op[2]&op[1]&op[0];
    //MemWr = sw
    assign MemWr    = op[5]&!op[4]&op[3]&!op[2]&op[1]&op[0];
    //Extop = addiu+lw+sw
    assign ExtOp    = !op[5]&!op[4]&op[3]&!op[2]&!op[1]&op[0]+op[5]&!op[4]&!op[3]&!op[2]&op[1]&op[0]+op[5]&!op[4]&op[3]&!op[2]&op[1]&op[0];

*/
    
    case(op)
    R:begin//R  add,sub,addu,slt,or,and
        assign RegWr    = 1;
        assign RegDst   = 1; 
        assign ExtOp    = 0;//x
        assign ALUSrc   = 0;
        assign Branch   = 0;
        assign Jump     = 0;
        assign MemWr    = 0;
        assign MemtoReg = 0;
    end
    ORI:begin//ori
        assign RegWr    = 1;
        assign RegDst   = 0; 
        assign ExtOp    = 0;
        assign ALUSrc   = 1;
        assign Branch   = 0;
        assign Jump     = 0;
        assign MemWr    = 0;
        assign MemtoReg = 0;
    end
    ADDIU:begin//addiu
        assign RegWr    = 1;
        assign RegDst   = 0; 
        assign ExtOp    = 1;
        assign ALUSrc   = 1;
        assign Branch   = 0;
        assign Jump     = 0;
        assign MemWr    = 0;
        assign MemtoReg = 0;
    end
    LW:begin//lw
        assign RegWr    = 1;
        assign RegDst   = 0; 
        assign ExtOp    = 1;
        assign ALUSrc   = 1;
        assign Branch   = 0;
        assign Jump     = 0;
        assign MemWr    = 0;
        assign MemtoReg = 1;
    end
    SW:begin//sw
        assign RegWr    = 0;
        assign RegDst   = 0;//x
        assign ExtOp    = 1;
        assign ALUSrc   = 1;
        assign Branch   = 0;
        assign Jump     = 0;
        assign MemWr    = 1;
        assign MemtoReg = 0;//x
    end
    BEQ:begin//beq
        assign RegWr    = 0;
        assign RegDst   = 0;//x
        assign ExtOp    = 0;//x
        assign ALUSrc   = 0;
        assign Branch   = 1;
        assign Jump     = 0;
        assign MemWr    = 0;
        assign MemtoReg = 0;//x
    end
    J:begin//jump
        assign RegWr    = 0;
        assign RegDst   = 0;//x 
        assign ExtOp    = 0;//x
        assign ALUSrc   = 0;//x
        assign Branch   = 0;
        assign Jump     = 1;
        assign MemWr    = 0;
        assign MemtoReg = 0;//x
    end
    ADDI:begin//addi
        assign RegWr    = 1;
        assign RegDst   = 0;//x 
        assign ExtOp    = 1;//x
        assign ALUSrc   = 1;//x
        assign Branch   = 0;
        assign Jump     = 0;
        assign MemWr    = 0;
        assign MemtoReg = 0;//x
    end
    endcase

end
endmodule