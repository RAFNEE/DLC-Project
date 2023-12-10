module cla64(a, b, ci, co, s);
	input [63:0] a, b;
	input ci;
	output co;
	output [63:0] s;
	wire c;
	
	// instance 64-bit CLA with 32-bit CLA
	cla32 U0_cla32(.a(a[31:0]), .b(b[31:0]), .ci(ci), .co(c), .s(s[31:0]));
	cla32 U1_cla32(.a(a[63:32]), .b(b[63:32]), .ci(c), .co(co), .s(s[63:32]));
	
endmodule
