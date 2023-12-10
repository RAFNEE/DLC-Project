module mux2_8bit(d0, d1, s, y);
	input [7:0] d0, d1;
	input s;
	output [7:0] y;
	
	// instance 2 to 1 mux
	mux2 mux20(.d0(d0[0]), .d1(d1[0]), .s(s), .y(y[0]));
	mux2 mux21(.d0(d0[1]), .d1(d1[1]), .s(s), .y(y[1]));
	mux2 mux22(.d0(d0[2]), .d1(d1[2]), .s(s), .y(y[2]));
	mux2 mux23(.d0(d0[3]), .d1(d1[3]), .s(s), .y(y[3]));
	mux2 mux24(.d0(d0[4]), .d1(d1[4]), .s(s), .y(y[4]));
	mux2 mux25(.d0(d0[5]), .d1(d1[5]), .s(s), .y(y[5]));
	mux2 mux26(.d0(d0[6]), .d1(d1[6]), .s(s), .y(y[6]));
	mux2 mux27(.d0(d0[7]), .d1(d1[7]), .s(s), .y(y[7]));
	
endmodule
