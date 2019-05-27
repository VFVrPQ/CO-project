module HazardDetectionUnit(ex_MemtoReg,ex_Rw,id_Ra,id_Rb,hazard);
	input 	   ex_MemtoReg;
	input[4:0] ex_Rw;
	input[4:0] id_Ra;
	input[4:0] id_Rb;

	output reg hazard;	

	initial begin
		hazard = 0;
	end

	always @(*) begin
		if (ex_MemtoReg!=0 && (ex_Rw == id_Rb || ex_Rw == id_Ra))
			  assign hazard = 1;
		else  assign hazard = 0;
	end
endmodule