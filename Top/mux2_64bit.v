module mux2_64bit(d0, d1, s, y);
	input [63:0] d0, d1;
	input s;
	output [63:0] y;
	
	// instance 2 to 1 mux
	mux2_32bit U0_mux2_32(.d0(d0[31:0]), .d1(d1[31:0]), .s(s), .y(y[31:0]));
	mux2_32bit U1_mux2_32(.d0(d0[63:32]), .d1(d1[63:32]), .s(s), .y(y[63:32]));
	
endmodule
