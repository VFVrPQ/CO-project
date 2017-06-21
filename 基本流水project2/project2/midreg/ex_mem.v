module ex_mem(Clk,ex_PC_br,ex_Zero,ex_alu_result,ex_busB,ex_Rw,ex_RegWr,ex_Branch,ex_Jump,ex_MemWr,ex_MemtoReg,
            mem_PC_br,mem_Zero,mem_alu_result,mem_busB,mem_Rw,mem_RegWr,mem_Branch,mem_Jump,mem_MemWr,mem_MemtoReg);
        input Clk;
        input[31:2]  ex_PC_br;
        input        ex_Zero;
        input[31:0]  ex_alu_result;
        input[31:0]  ex_busB;
        input[4:0]   ex_Rw;        
        input        ex_RegWr,ex_Branch,ex_Jump,ex_MemWr,ex_MemtoReg;
	       
        output reg [31:2]  mem_PC_br;
        output reg         mem_Zero;
        output reg [31:0]  mem_alu_result;
        output reg [31:0]  mem_busB;
        output reg [4:0]   mem_Rw;
        output reg         mem_RegWr,mem_Branch,mem_Jump,mem_MemWr,mem_MemtoReg;
        
        initial begin
          mem_PC_br      = 30'd0;
          mem_Zero       = 0;
          mem_alu_result = 32'd0;
          mem_busB       = 32'd0;
          mem_Rw         = 5'd0;
          mem_RegWr      = 0;
          mem_Branch     = 0;
          mem_Jump       = 0;
          mem_MemWr      = 0;
          mem_MemtoReg   = 0;
        end
        always @(posedge Clk)
        begin
          mem_PC_br      <= ex_PC_br;
          mem_alu_result <= ex_alu_result;
          mem_busB       <= ex_busB;
          mem_Rw         <= ex_Rw;     
          
          //control
          mem_Zero       <= ex_Zero;
          mem_RegWr      <= ex_RegWr;
          mem_Branch     <= ex_Branch;
          mem_Jump       <= ex_Jump;
          mem_MemWr      <= ex_MemWr;
          mem_MemtoReg   <= ex_MemtoReg;       
        end
endmodule