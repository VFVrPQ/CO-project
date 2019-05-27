module id_ex(Clk, hazard, BranchBubble, id_busA, id_busB,
             id_Ra, id_Rb, id_Rw, id_imm16Ext, id_RegWr,
             id_RegDst, id_ALUsrc, id_MemWr, id_MemtoReg,id_ALUctr, id_MemRead, id_shf, id_ALUshf,
             ex_busA,   ex_busB,
             ex_Ra, ex_Rb, ex_Rw, ex_imm16Ext, ex_RegWr,  
             ex_RegDst, ex_ALUsrc,ex_MemWr,ex_MemtoReg,ex_ALUctr,   ex_MemRead, ex_shf, ex_ALUshf);

        input         Clk;
        input         hazard;
        input         BranchBubble;
        input [31:0]  id_busA;
        input [31:0]  id_busB;
        input [4:0]   id_Ra;
        input [4:0]   id_Rb;
        input [4:0]   id_Rw;
        input [31:0]  id_imm16Ext;
        input	      id_RegWr,id_RegDst,id_ALUsrc;
        input [1:0]   id_MemWr;
        input         id_MemtoReg;
	    input [3:0]   id_ALUctr;
        input [1:0]   id_MemRead;
        input [4:0]   id_shf;
	    input         id_ALUshf;

        output reg [4:0]   ex_Ra;
        output reg [4:0]   ex_Rb;
        output reg [4:0]   ex_Rw;
        output reg [31:0]  ex_busA;
        output reg [31:0]  ex_busB;
        output reg [31:0]  ex_imm16Ext;
        output reg         ex_RegWr,ex_RegDst,ex_ALUsrc;
        output reg [1:0]   ex_MemWr;
        output reg         ex_MemtoReg;
	    output reg [3:0]   ex_ALUctr;     
        output reg [1:0]   ex_MemRead;
        output reg [4:0]   ex_shf;
	    output reg         ex_ALUshf;

	   initial begin
             ex_Ra        = 5'd0;
             ex_Rb        = 5'd0;
             ex_Rw        = 5'd0;
             ex_busA      = 32'd0;
             ex_busB      = 32'd0;
             ex_imm16Ext  = 32'd0;
	         ex_RegWr     = 0;
	         ex_RegDst    = 0;
	         ex_ALUsrc    = 0;
	         ex_MemWr     = 2'd0;
	         ex_MemtoReg  = 0;  
             ex_ALUctr    = 4'd0;
             ex_MemRead   = 2'd0;
             ex_shf       = 5'd0;
             ex_ALUshf    = 0;
	    end
        always @(posedge Clk)
        begin
             if (hazard || BranchBubble) begin
                 ex_RegWr     <= 0;
                 ex_RegDst    <= 0;
                 ex_ALUsrc    <= 0;
                 ex_MemWr     <= 2'b0;
                 ex_MemtoReg  <= 0;
                 ex_ALUctr    <= 4'b0;  
                 ex_MemRead   <= 2'b0; 
                 ex_ALUshf    <= 0; 
             end else begin
                 ex_Ra        <= id_Ra;
                 ex_Rb        <= id_Rb;
                 ex_Rw        <= id_Rw;
                 ex_busA      <= id_busA;
                 ex_busB      <= id_busB;
                 ex_imm16Ext  <= id_imm16Ext;
                 ex_shf       <= id_shf;
                //control
                 ex_RegWr     <= id_RegWr;
                 ex_RegDst    <= id_RegDst;
                 ex_ALUsrc    <= id_ALUsrc;
                 ex_MemWr     <= id_MemWr;
                 ex_MemtoReg  <= id_MemtoReg;
                 ex_ALUctr    <= id_ALUctr;    
                 ex_MemRead   <= id_MemRead;
                 ex_ALUshf    <= id_ALUshf;
             end 
        end
endmodule