
module if_id( clk, IF_ins, ID_ins, PC, ID_pc, ID_Ra, ID_Rb, ID_Rw, ID_imm16);

input clk;
input[31:0] IF_ins;
input[31:2] PC;

output reg [31:2] ID_pc;
output reg [31:0] ID_ins;
output reg [4:0]  ID_Ra,ID_Rb,ID_Rw;
output reg [15:0] ID_imm16;

initial begin
    ID_ins = 32'd0;
    ID_Ra = 5'd0;
    ID_Rb = 5'd0;
    ID_Rw = 5'd0;
    ID_imm16 = 16'd0;
    ID_pc = 30'd0;
end

always @(negedge clk)
begin
    ID_ins <= IF_ins;
    ID_pc <= PC;
    ID_Ra <= IF_ins[25:21];
    ID_Rb <= IF_ins[20:16];
    ID_Rw <= IF_ins[15:11];
    ID_imm16 <= IF_ins[15:0];
end

endmodule
