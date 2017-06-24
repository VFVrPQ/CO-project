module Cp0BubbleUnit (
	id_Ra, id_Rb, ex_Rw, ex_cp0Op, mem_Rw, mem_cp0Op, cp0Bubble
);
	input 		[4:0] id_Ra;
	input 		[4:0] id_Rb;
	input 		[4:0] ex_Rw;
	input       [2:0] ex_cp0Op;
	input       [4:0] mem_Rw;
	input       [2:0] mem_cp0Op;

	output reg        cp0Bubble;

	//*************MFCO-usem冒险**********//
	always @(*) begin 
		//************相邻指令************//
		if (   ( ex_cp0Op  == 3'b001 && ex_Rw  != 0 && (ex_Rw  == id_Ra || ex_Rw  == id_Rb) )
			|| ( mem_cp0Op == 3'b001 && mem_Rw != 0 && (mem_Rw == id_Ra || mem_Rw == id_Rb) )) begin
				cp0Bubble <= 1;
		end else 
				cp0Bubble <= 0;
	
	end
endmodule