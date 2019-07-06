module ex_mem    ( clk, Ex_ins, Ex_pc, Ex_zero, Ex_overflow, Ex_aluout, 
                   Ex_busA/*begz bgtz blez bltz*/, Ex_mux_din, Ex_mux_Rw, Ex_RegWr, Ex_MemtoReg, Ex_MemWr, Ex_Branch, Ex_Jump,
                   Mem_ins, Mem_pc, Mem_zero, Mem_overflow, Mem_aluout,
                   Mem_busA, Mem_din, Mem_Rw, Mem_RegWr, Mem_MemtoReg, Mem_MemWr, Mem_Branch, Mem_Jump  );

input clk;
input[31:0] Ex_ins;
input[31:2] Ex_pc;
input       Ex_zero;
input       Ex_overflow;
input[31:0] Ex_aluout;

input[31:0] Ex_busA;
input[31:0] Ex_mux_din;
input[4:0]  Ex_mux_Rw;

input       Ex_RegWr;
input[1:0]  Ex_MemtoReg;
input[2:0]  Ex_MemWr;
input[2:0]  Ex_Branch;
input[1:0]  Ex_Jump;

output reg [31:0] Mem_ins;
output reg [31:2] Mem_pc;
output reg        Mem_zero;
output reg        Mem_overflow;
output reg [31:0] Mem_aluout;

output reg [31:0] Mem_busA;
output reg [31:0] Mem_din;
output reg [4:0]  Mem_Rw;

output reg        Mem_RegWr;
output reg [1:0]  Mem_MemtoReg;
output reg [2:0]  Mem_MemWr;
output reg [2:0]  Mem_Branch;
output reg [1:0]  Mem_Jump;

initial begin
    Mem_ins          = 32'd0;
    Mem_pc           = 30'd0;
    Mem_zero         = 0;
    Mem_overflow     = 0;
    Mem_aluout       = 32'd0;
    Mem_busA         = 32'd0;
    Mem_din          = 32'd0;
    Mem_Rw           = 5'd0;
    Mem_RegWr        = 0;
    Mem_MemtoReg     = 2'd0;
    Mem_MemWr        = 3'd0;
    Mem_Branch       = 3'd0;
    Mem_Jump         = 2'd0;
end

always @(negedge clk)
begin
    Mem_ins          <= Ex_ins;
    Mem_pc           <= Ex_pc;
    Mem_zero         <= Ex_zero;
    Mem_overflow     <= Ex_overflow;
    Mem_aluout       <= Ex_aluout;
    Mem_busA         <= Ex_busA;
    Mem_din          <= Ex_mux_din;
    Mem_Rw           <= Ex_mux_Rw;
    Mem_RegWr        <= Ex_RegWr;
    Mem_MemtoReg     <= Ex_MemtoReg;
    Mem_MemWr        <= Ex_MemWr;
    Mem_Branch       <= Ex_Branch;
    Mem_Jump         <= Ex_Jump;
end

endmodule
