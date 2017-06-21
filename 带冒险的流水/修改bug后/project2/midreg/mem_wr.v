module mem_wr(Clk,mem_dout,mem_alu_result,mem_Rw,mem_RegWr,mem_Jump,mem_MemtoReg,
             wr_dout,wr_alu_result,wr_Rw,wr_RegWr,wr_Jump,wr_MemtoReg);
    input       Clk;
    input[31:0] mem_dout;
    input[31:0] mem_alu_result;
    input[4:0]  mem_Rw;
    input       mem_RegWr,mem_Jump,mem_MemtoReg;
    
    output reg [31:0] wr_dout;
    output reg [31:0] wr_alu_result;
    output reg [4:0]  wr_Rw;
    output reg        wr_RegWr,wr_Jump,wr_MemtoReg;
    
    initial begin
      wr_dout       = 32'd0;
      wr_alu_result = 32'd0;
      wr_Rw         = 5'd0;
      wr_RegWr      = 0;
      wr_Jump       = 0;
      wr_MemtoReg   = 0; 
    end
    always @(posedge Clk)
    begin
      wr_dout       <= mem_dout;
      wr_alu_result <= mem_alu_result;
      wr_Rw         <= mem_Rw; 
      //control
      wr_RegWr      <= mem_RegWr;
      wr_Jump       <= mem_Jump;
      wr_MemtoReg   <= mem_MemtoReg;
    end
endmodule
