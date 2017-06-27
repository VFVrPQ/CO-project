`timescale 1ns / 1ps
module if_id(Clk,          Reset,        id_Jump,   Branch_ok, 
             hazard,       if_ins,       id_ins,    PC_plus_4, 
             id_PC_plus_4, BranchBubble, PC,        id_PC,        
             id_cp0Op,     cp0Bubble,    id_valid);
    input       Clk;
    input       Reset;
    input[1:0]  id_Jump;
    input[31:0] if_ins;
    input       hazard;
    input       Branch_ok;
    input[31:2] PC_plus_4;
    input       BranchBubble;
    input[31:2] PC;
    input[2:0]  id_cp0Op;
    input       cp0Bubble;

    output reg [31:0] id_ins;
    output reg [31:2] id_PC_plus_4;
    output reg [31:2] id_PC;

    output reg        id_valid;

    parameter SYSCALL = 3'b100, ERET = 3'b011;

    initial begin
      id_ins       = 32'd0;
      id_PC_plus_4 = 30'd0;
      id_PC        = 30'd0;
      id_valid     =  1'd0;
    end
    always @(negedge Clk)
    begin
        if (hazard || BranchBubble || cp0Bubble) begin//如果BranchBubble和Branch_ok同时成立，先插气泡，后再判断分支branch_ok
            id_valid     <= 1'd1;
        end 
        //**************longson中beq和j的下一条指令是要执行的，不需要清零
        /*else if (Branch_ok || id_Jump) begin
            id_ins       <= 32'd0;
            id_PC_plus_4 <= PC_plus_4;
            id_PC        <= PC;
        end */ 
        //************SYSCALL和ERET发生时，需要将下一条指令清零*****//
        else if (id_cp0Op == SYSCALL || id_cp0Op == ERET) begin
            id_ins       <= 32'd0;
            id_PC_plus_4 <= 30'd0;
            id_PC        <= 30'd0;
            id_valid     <= 1'd0;
        end 
        else begin
            id_ins       <= if_ins;
            id_PC_plus_4 <= PC_plus_4;
            id_PC        <= PC;
            id_valid     <= 1'd1;
        end
    end

endmodule


