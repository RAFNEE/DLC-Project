module mux2_16bit(d0, d1, s, y);
	input [15:0] d0, d1;
	input s;
	output [15:0] y;
	
	// instance 2 to 1 mux
	mux2_8bit U0_mux2_8(.d0(d0[7:0]), .d1(d1[7:0]), .s(s), .y(y[7:0]));
	mux2_8bit U1_mux2_8(.d0(d0[15:8]), .d1(d1[15:8]), .s(s), .y(y[15:8]));
	
endmodule
