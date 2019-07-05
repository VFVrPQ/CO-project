module mem_wr(   clk,
                    Mem_pc, Mem_overflow, Mem_dout, Mem_aluout, Mem_ins, Mem_RegWr, Mem_MemtoReg, Mem_Rw,
                    Wr_pc, Wr_overflow, Wr_memout, Wr_aluout, Wr_ins, Wr_RegWr, Wr_MemtoReg, Wr_Rw);

input clk;
input[31:2]   Mem_pc;
input         Mem_overflow;
input[31:0]   Mem_dout;
input[31:0]   Mem_aluout;
input[31:0]   Mem_ins;
input         Mem_RegWr;
input[1:0]    Mem_MemtoReg;
input[4:0]    Mem_Rw;

output reg[31:2]  Wr_pc;
output reg        Wr_overflow;
output reg[31:0]  Wr_memout;
output reg[31:0]  Wr_aluout;
output reg[31:0]  Wr_ins;
output reg        Wr_RegWr;
output reg[1:0]   Wr_MemtoReg;
output reg[4:0]   Wr_Rw;

initial begin
    Wr_pc        =  30'd0;
    Wr_overflow  =  0;
    Wr_memout    =  32'd0;
    Wr_aluout    =  32'd0;
    Wr_ins       =  32'd0;
    Wr_RegWr       =  0;
    Wr_MemtoReg  =  2'd0;
    Wr_Rw        =  5'd0;
end

always @(negedge clk)
begin
    Wr_pc        <=  Mem_pc;
    Wr_overflow  <=  Mem_overflow;
    Wr_memout    <=  Mem_dout;
    Wr_aluout    <=  Mem_aluout;
    Wr_ins       <=  Mem_ins;
    Wr_RegWr     <=  Mem_RegWr;
    Wr_MemtoReg  <=  Mem_MemtoReg;
    Wr_Rw        <=  Mem_Rw;
end
endmodule
