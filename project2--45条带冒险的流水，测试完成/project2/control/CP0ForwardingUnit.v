module CP0ForwardingUnit(id_cp0Op,
	                     ex_cs,  ex_sel,  ex_cp0Op,
						 mem_cs, mem_sel, mem_cp0Op,
						 cp0Forward);
	
	input      [2:0] id_cp0Op;
	input      [4:0] ex_cs;
	input      [2:0] ex_sel;
	input 	   [2:0] ex_cp0Op;
	input      [4:0] mem_cs;
	input      [2:0] mem_sel;
	input      [2:0] mem_cp0Op;

	output reg [1:0] cp0Forward;


	parameter ERET = 3'b100, MTCO = 3'b010, SYSCALL = 3'b011;
	always @(*) begin
		//*****ID是ERET,EX是MTCO***//
		if (     id_cp0Op == ERET && ex_cp0Op  == MTCO && ex_cs  == 5'd14 && ex_sel  == 3'd0)
			cp0Forward <= 2'b01;
		//*****ID是ERET,MEM是MTCO**//
		else if (id_cp0Op == ERET && mem_cp0Op == MTCO && mem_cs == 5'd14 && mem_sel == 3'd0)
			cp0Forward <= 2'b10;
		//*****ID是SYSCALL*********//
		else if (id_cp0Op == SYSCALL)
			cp0Forward <= 2'b11;
		else 
			cp0Forward <= 0;
	end
endmodule // CP0ForwardingUnit