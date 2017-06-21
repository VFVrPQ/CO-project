module if_id(Clk,if_flush,hazard,if_ins,id_ins,PC_plus_4,id_PC_plus_4);
    input       Clk;
    input[31:0] if_ins;
    input       hazard;
    input       if_flush;
    input[31:2] PC_plus_4;
    
    output reg [31:0] id_ins;
    output reg [31:2] id_PC_plus_4;
    
    initial begin
      id_ins       = 32'd0;
      id_PC_plus_4 = 30'd0;
    end
    always @(posedge Clk)
    begin
      if (if_flush || hazard) begin
          id_ins       <= 32'd0;
          id_PC_plus_4 <= PC_plus_4;
      end else begin
          id_ins       <= if_ins;
          id_PC_plus_4 <= PC_plus_4;
      end
    end

endmodule
