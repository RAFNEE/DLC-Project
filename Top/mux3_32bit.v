module mux3_32bit(d0, d1, d2, s, y);
	input [31:0] d0, d1, d2;
	input [1:0] s;
	output [31:0] y;
	
	wire [31:0] x1, x2;
	
	// instance mux2_32bit
	mux2_32bit U0_mux2(.d0(d0), .d1(d2), .s(~s[0]), .y(x1));
	mux2_32bit U1_mux2(.d0(d1), .d1(d2), .s(s[0]), .y(x2));
	mux2_32bit U2_mux2(.d0(x1), .d1(x2), .s(s[1]), .y(y));
	
endmodule
