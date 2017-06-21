module id_ex(Clk,id_PC_plus_4,id_busA,id_busB,id_Rb,id_Rw,id_imm16Ext,id_RegWr,id_RegDst,id_ALUsrc,id_Branch,id_Jump,id_MemWr,id_MemtoReg,id_ALUctr,
            ex_PC_plus_4,ex_busA,ex_busB,ex_Rb,ex_Rw,ex_imm16Ext,ex_RegWr,ex_RegDst,ex_ALUsrc,ex_Branch,ex_Jump,ex_MemWr,ex_MemtoReg,ex_ALUctr);
        input Clk;
        input [31:2]  id_PC_plus_4;
        input [31:0]  id_busA;
        input [31:0]  id_busB;
        input [4:0]   id_Rb;
        input [4:0]   id_Rw;
        input [31:0]  id_imm16Ext;
        input	        id_RegWr,id_RegDst,id_ALUsrc,id_Branch,id_Jump,id_MemWr,id_MemtoReg;
	      input [2:0]   id_ALUctr;
	      
        output reg [31:2]  ex_PC_plus_4;
        output reg [31:0]  ex_busA;
        output reg [31:0]  ex_busB;
        output reg [4:0]   ex_Rb;
        output reg [4:0]   ex_Rw;
        output reg [31:0]  ex_imm16Ext;
        output reg         ex_RegWr,ex_RegDst,ex_ALUsrc,ex_Branch,ex_Jump,ex_MemWr,ex_MemtoReg;
	    output reg [2:0]   ex_ALUctr;        
	      
	   initial begin
             ex_PC_plus_4 = 30'd0;
             ex_busA      = 32'd0;
             ex_busB      = 32'd0;
             ex_Rb        = 5'd0;
             ex_Rw        = 5'd0;
             ex_imm16Ext  = 32'd0;
	         ex_RegWr     = 0;
	         ex_RegDst    = 0;
	         ex_ALUsrc    = 0;
	         ex_Branch    = 0;
	         ex_Jump      = 0;
	         ex_MemWr     = 0;
	         ex_MemtoReg  = 0;  
             ex_ALUctr    = 3'd0;
	    end
        always @(posedge Clk)
        begin
             ex_PC_plus_4 <= id_PC_plus_4;
             ex_busA      <= id_busA;
             ex_busB      <= id_busB;
             ex_Rb        <= id_Rb;
             ex_Rw        <= id_Rw;
             ex_imm16Ext  <= id_imm16Ext;
            
            //control
             ex_RegWr     <= id_RegWr;
             ex_RegDst    <= id_RegDst;
             ex_ALUsrc    <= id_ALUsrc;
             ex_Branch    <= id_Branch;
             ex_Jump      <= id_Jump;
             ex_MemWr     <= id_MemWr;
             ex_MemtoReg  <= id_MemtoReg;
             ex_ALUctr    <= id_ALUctr;
        end
endmodule