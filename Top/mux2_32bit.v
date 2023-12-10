module mux2_32bit(d0, d1, s, y);
	input [31:0] d0, d1;
	input s;
	output [31:0] y;
	
	// instance 2 to 1 mux
	mux2_8bit U0_mux2_8(.d0(d0[7:0]), .d1(d1[7:0]), .s(s), .y(y[7:0]));
	mux2_8bit U1_mux2_8(.d0(d0[15:8]), .d1(d1[15:8]), .s(s), .y(y[15:8]));
	mux2_8bit U2_mux2_8(.d0(d0[23:16]), .d1(d1[23:16]), .s(s), .y(y[23:16]));
	mux2_8bit U3_mux2_8(.d0(d0[31:24]), .d1(d1[31:24]), .s(s), .y(y[31:24]));
	
endmodule
