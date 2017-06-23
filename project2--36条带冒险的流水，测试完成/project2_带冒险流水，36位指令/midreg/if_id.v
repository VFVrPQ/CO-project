module if_id(Clk,id_Jump,Branch_ok,hazard,if_ins,id_ins,PC_plus_4,id_PC_plus_4,BranchBubble);
    input       Clk;
    input[1:0]  id_Jump;
    input[31:0] if_ins;
    input       hazard;
    input       Branch_ok;
    input[31:2] PC_plus_4;
    input       BranchBubble;

    output reg [31:0] id_ins;
    output reg [31:2] id_PC_plus_4;
    
    initial begin
      id_ins       = 32'd0;
      id_PC_plus_4 = 30'd0;
    end
    always @(posedge Clk)
    begin
      if (hazard || BranchBubble) begin//如果BranchBubble和Branch_ok同时成立，先插气泡，后再判断分支branch_ok
           
      end else
      if (Branch_ok || id_Jump) begin
          id_ins       <= 32'd0;
          id_PC_plus_4 <= PC_plus_4;
      end 
      else begin
          id_ins       <= if_ins;
          id_PC_plus_4 <= PC_plus_4;
      end
    end

endmodule
