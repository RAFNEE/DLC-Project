module mux3_64bit(d0, d1, d2, s, y);
	input [63:0] d0, d1, d2;
	input [1:0] s;
	output [63:0] y;
	
	// instance 3 to 1 mux
	mux3_32bit U0_mux3_32(.d0(d0[31:0]), .d1(d1[31:0]), .d2(d2[31:0]), .s(s), .y(y[31:0]));
	mux3_32bit U1_mux3_32(.d0(d0[63:32]), .d1(d1[63:32]), .d2(d2[31:0]), .s(s), .y(y[63:32]));
	
endmodule
