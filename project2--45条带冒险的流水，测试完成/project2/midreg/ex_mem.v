module ex_mem( Clk,          ex_Zero,        ex_alu_result, ex_busB,          ex_Rw,
               ex_RegWr,     ex_MemWr,       ex_MemtoReg,   mem_Zero,         mem_alu_result,
               mem_busB,     mem_Rw,         mem_RegWr,     mem_MemWr,        mem_MemtoReg,
               ex_MemRead,   mem_MemRead,
               //----{mul}begin
               ex_busA_mux3, ex_mul_result,  ex_regToMul,   ex_mulToReg,      ex_mulRead,
               mem_busA,     mem_mul_result, mem_regToMul,  mem_mulToReg,     mem_mulRead,
               //----{mul}end
               //----{cp0}begin
               ex_cs,        ex_sel,         ex_cp0Op,      ex_PC,
               mem_cs,       mem_sel,        mem_cp0Op,     mem_PC
               //----{cp0}end
               );
        
        input              Clk;
        input              ex_Zero;
        input       [31:0] ex_alu_result;
        input       [31:0] ex_busB;
        input       [4:0]  ex_Rw;        
        input              ex_RegWr;
        input       [1:0]  ex_MemWr;
        input              ex_MemtoReg;
	      input       [1:0]  ex_MemRead;
        //----{mul}begin
        input       [31:0] ex_busA_mux3;
        input       [63:0] ex_mul_result;
        input       [ 1:0] ex_regToMul;
        input              ex_mulToReg;
        input              ex_mulRead;
        //----{mul}end
        //----{cp0}begin
        input       [ 4:0] ex_cs;
        input       [ 2:0] ex_sel;
        input       [ 2:0] ex_cp0Op;
        input       [31:2] ex_PC;
        //----{cp0}end

        //control
        output reg         mem_Zero;
        output reg [31:0]  mem_alu_result;
        output reg [31:0]  mem_busB;
        output reg [4:0]   mem_Rw;
        output reg         mem_RegWr;
        output reg [1:0]   mem_MemWr;
        output reg         mem_MemtoReg;
        output reg [1:0]   mem_MemRead;

        //----{mul}begin
        output reg [31:0]  mem_busA;
        output reg [63:0]  mem_mul_result;
        output reg [ 1:0]  mem_regToMul;
        output reg         mem_mulToReg;
        output reg         mem_mulRead;
        //----{mul}end
        //----{cp0}begin
        output reg [ 4:0]  mem_cs;
        output reg [ 2:0]  mem_sel;
        output reg [ 2:0]  mem_cp0Op;
        output reg [31:2]  mem_PC;
        //----{cp0}end  
        initial begin
          mem_Zero       = 0;
          mem_alu_result = 32'd0;
          mem_busB       = 32'd0;
          mem_Rw         = 5'd0;
          mem_RegWr      = 0;    // 寄存器写控制信号
          mem_MemWr      = 2'd0; // 数据内存写控制信号
          mem_MemtoReg   = 0;    // 数据内存数据写入寄存器控制信号MUX
          mem_MemRead    = 2'd0;
          //----{mul}begin
          mem_busA       = 32'd0;
          mem_mul_result = 63'd0;
          mem_regToMul   = 2'd0;
          mem_mulToReg   = 0;
          mem_mulRead    = 0;
          //----{mul}end
          //----{cp0}begin
          mem_cs         = 5'd0;
          mem_sel        = 3'd0;
          mem_cp0Op      = 3'd0;
          mem_PC         = 30'd0;
          //----{cp0}end  
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
          mem_MemRead    <= ex_MemRead;    

          //----{mul}begin
          mem_busA       <= ex_busA_mux3;
          mem_mul_result <= ex_mul_result;
          mem_regToMul   <= ex_regToMul;
          mem_mulToReg   <= ex_mulToReg;
          mem_mulRead    <= ex_mulRead;
          //----{mul}end

          //----{cp0}begin
          mem_cs         <= ex_cs;
          mem_sel        <= ex_sel;
          mem_cp0Op      <= ex_cp0Op;
          mem_PC         <= ex_PC;
          //----{cp0}end 
        end
endmodule