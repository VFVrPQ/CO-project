module id_ex   (    clk, ID_pc,  ID_ins,  ID_busA, ID_busB, ID_imm16, 
                    ID_Rb, ID_Rw, ID_ExtOp, ID_ALUSrc, ID_RegDst, ID_MemWr, ID_Branch, ID_Jump, ID_MemtoReg, ID_RegWr, ID_ALUctr,
                    Ex_pc, Ex_ins, Ex_busA, Ex_busB, Ex_imm16,
                    Ex_Rt, Ex_Rd, Ex_ExtOp, Ex_ALUSrc, Ex_RegDst, Ex_MemWr, Ex_Branch, Ex_Jump, Ex_MemtoReg, Ex_RegWr, Ex_ALUctr );

input clk;
input[31:2] ID_pc;
input[31:0] ID_ins;
input[31:0] ID_busA;
input[31:0] ID_busB;
input[15:0] ID_imm16;

input[4:0] ID_Rb;
input[4:0] ID_Rw;

input[1:0] ID_Jump;
input      ID_ExtOp;
input      ID_ALUSrc;
input[1:0] ID_RegDst;
input[2:0] ID_MemWr;
input[2:0] ID_Branch;
input[1:0] ID_MemtoReg;
input      ID_RegWr;
input[3:0] ID_ALUctr;

output reg [31:2] Ex_pc;
output reg [31:0] Ex_ins;
output reg [31:0] Ex_busA;
output reg [31:0] Ex_busB;
output reg [15:0] Ex_imm16;

output reg [4:0] Ex_Rt;
output reg [4:0] Ex_Rd;

output reg [1:0] Ex_Jump;
output reg       Ex_ExtOp;
output reg       Ex_ALUSrc;
output reg [1:0] Ex_RegDst;
output reg [2:0] Ex_MemWr;
output reg [2:0] Ex_Branch;
output reg [1:0] Ex_MemtoReg;
output reg       Ex_RegWr;
output reg [3:0] Ex_ALUctr;


initial begin
    Ex_pc         = 30'd0;
    Ex_ins        = 32'd0;
    Ex_busA       = 32'd0;
    Ex_busB       = 32'd0;
    Ex_imm16      = 16'd0;
    Ex_Rt         = 5'd0;
    Ex_Rd         = 5'd0;

    Ex_ExtOp      = 1'd0;
	Ex_RegWr      = 1'd0;
	Ex_RegDst     = 2'd0;
	Ex_ALUSrc     = 1'd0;
	Ex_Branch     = 3'd0;
	Ex_Jump       = 2'd0;
	Ex_MemWr      = 3'd0;
    Ex_MemtoReg   = 2'd0;  
    Ex_ALUctr     = 4'd0;
    end


always @(negedge clk)
        begin
             Ex_pc        <= ID_pc;
             Ex_ins       <= ID_ins;
             Ex_busA      <= ID_busA;
             Ex_busB      <= ID_busB;
             Ex_Rt        <= ID_Rb;
             Ex_Rd        <= ID_Rw;
             Ex_imm16     <= ID_imm16;

            //ctrl
             Ex_ExtOp     <= ID_ExtOp;
             Ex_RegWr     <= ID_RegWr;
             Ex_RegDst    <= ID_RegDst;
             Ex_ALUSrc    <= ID_ALUSrc;
             Ex_Branch    <= ID_Branch;
             Ex_Jump      <= ID_Jump;
             Ex_MemWr     <= ID_MemWr;
             Ex_MemtoReg  <= ID_MemtoReg;
             Ex_ALUctr    <= ID_ALUctr;
        end
endmodule

