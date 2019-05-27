module if_id(Clk,ins,if_flush,PC_plus_4,Ra,Rb,Rw,imm16,id_PC_plus_4);
    input Clk;
    input[31:0] ins;
    input       if_flush;
    input[31:2] PC_plus_4;
    
    output reg [4:0] Ra;
    output reg [4:0] Rb;
    output reg [4:0] Rw;
    output reg [15:0] imm16;
    output reg [31:2] id_PC_plus_4;
    
    initial begin
      Ra           = 5'd0;
      Rb           = 5'd0;
      Rw           = 5'd0;
      imm16        = 16'd0;
      id_PC_plus_4 = 30'd0;
    end
    always @(posedge Clk)
    begin
      if (if_flush) begin
          Ra           <= 5'd0;
          Rb           <= 5'd0;
          Rw           <= 5'd0;
          imm16        <= 16'd0;
          id_PC_plus_4 <= PC_plus_4;
      end else begin
          Ra           <= ins[25:21];
          Rb           <= ins[20:16];
          Rw           <= ins[15:11];
          imm16        <= ins[15:0];
          id_PC_plus_4 <= PC_plus_4;
      end
    end

endmodule
