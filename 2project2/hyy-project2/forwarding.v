module forwarding(Ex_Rs, Ex_Rt, Mem_Rw, Mem_RegWr, Wr_Rw, Wr_RegWr, ALUSrcA, ALUSrcB,ALUSrcDin);

input[4:0] Ex_Rs;
input[4:0] Ex_Rt;
input[4:0] Mem_Rw;
input      Mem_RegWr;
input[4:0] Wr_Rw;
input      Wr_RegWr;

output reg [1:0]  ALUSrcA;
output reg [1:0]  ALUSrcB;
output reg [1:0]  ALUSrcDin;

initial
begin
    ALUSrcA = 2'b00;
    ALUSrcB = 2'b00;
    ALUSrcDin = 2'b00;
end

always @(*)
begin
    assign ALUSrcA = 2'b00;
    assign ALUSrcB = 2'b00;
    assign ALUSrcDin = 2'b00;

    if( (Ex_Rs == Mem_Rw) && (Mem_RegWr == 1) && (Mem_Rw != 0) )
    begin
        assign ALUSrcA = 2'b01;//
    end
    else if( (Ex_Rs == Wr_Rw) && (Wr_RegWr == 1) && (Wr_Rw != 0) )
    begin
        assign ALUSrcA = 2'b10;
    end

    if( (Ex_Rt == Mem_Rw) && (Mem_RegWr == 1) && (Mem_Rw != 0) )
    begin
        assign ALUSrcB = 2'b01;
        assign ALUSrcDin = 2'b01;
    end
    else if( (Ex_Rt == Wr_Rw) && (Wr_RegWr == 1) && (Wr_Rw != 0) )
    begin
        assign ALUSrcB = 2'b10;
        assign ALUSrcDin = 2'b10;
    end

end

endmodule

