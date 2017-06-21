module ex_mem( Clk,      ex_Zero,  ex_alu_result, ex_busB,   ex_Rw,
               ex_RegWr, ex_MemWr, ex_MemtoReg,   mem_Zero,  mem_alu_result,
               mem_busB, mem_Rw,   mem_RegWr,     mem_MemWr, mem_MemtoReg);
        
        input              Clk;
        input              ex_Zero;
        input       [31:0] ex_alu_result;
        input       [31:0] ex_busB;
        input       [4:0]  ex_Rw;        
        input              ex_RegWr,ex_MemWr,ex_MemtoReg;
	       
        output reg         mem_Zero;
        output reg [31:0]  mem_alu_result;
        output reg [31:0]  mem_busB;
        output reg [4:0]   mem_Rw;
        output reg         mem_RegWr,mem_MemWr,mem_MemtoReg;
        
        initial begin
          mem_Zero       = 0;
          mem_alu_result = 32'd0;
          mem_busB       = 32'd0;
          mem_Rw         = 5'd0;
          mem_RegWr      = 0; // 寄存器写控制信号
          mem_MemWr      = 0; // 数据内存写控制信号
          mem_MemtoReg   = 0; // 数据内存数据写入寄存器控制信号MUX
        end
        always @(posedge Clk)
        begin
          mem_alu_result <= ex_alu_result;
          mem_busB       <= ex_busB;
          mem_Rw         <= ex_Rw;     
          
          //control
          mem_Zero       <= ex_Zero;
          mem_RegWr      <= ex_RegWr;
          mem_MemWr      <= ex_MemWr;
          mem_MemtoReg   <= ex_MemtoReg;       
        end
endmodule