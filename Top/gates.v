module _and2(a, b, y);		// 2 to 1 and gate
	input a, b;
	output y;
	
	assign y = a & b;
	
endmodule

module _nand2(a, b, y);		// 2 to 1 nand gate
	input a, b;
	output y;
	
	assign y = ~(a & b);
	
endmodule

module _or2(a, b, y);		// 2 to 1 or gate
	input a, b;
	output y;
	
	assign y = a | b;
	
endmodule

module _inv(a, y);		// inverter
	input a;
	output y;
	
	assign y = ~a;
	
endmodule

module _xor2(a, b, y);		// 2 to 1 exclusive or gate
	input a, b;
	output y;
	wire inv_a, inv_b;
	wire w0, w1;
	
	// inverting a and b
	_inv inv0(.a(a), .y(inv_a));
	_inv inv1(.a(b), .y(inv_b));
	
	// use two and gates for between a and not b or between not a and b
	_and2 ad20(a, inv_b, w0);
	_and2 ad21(b, inv_a, w1);
	
	// connect both result of two and gates with or gate
	_or2 or20(w0, w1, y);
	
endmodule

module _and3(a, b, c, y);		// 3 to 1 and gate
	input a, b, c;
	output y;
	
	assign y = a & b & c;
	
endmodule

module _and4(a, b, c, d, y);		// 4 to 1 and gate
	input a, b, c, d;
	output y;
	
	assign y = a & b & c & d;
	
endmodule

module _and5(a, b, c, d, e, y);		// 5 to 1 and gadte
	input a, b, c, d, e;
	output y;
	
	assign y = a & b & c & d & e;
	
endmodule

module _or3(a, b, c, y);		// 3 to 1 or gate
	input a, b, c;
	output y;
	
	assign y = a | b | c;
	
endmodule

module _or4(a, b, c, d, y);		// 4 to 1 or gate
	input a, b, c, d;
	output y;
	
	assign y = a | b | c | d;
	
endmodule

module _or5(a, b, c, d, e, y);		// 5 to 1 or gate
	input a, b, c, d, e;
	output y;
	
	assign y = a | b | c | d | e;
	
endmodule

module _inv_4bits(a, y);		// 4-bit inverter
	input [3:0] a;
	output [3:0] y;
	
	assign y = ~a;
	
endmodule

module _and2_4bits(a, b, y);		// 4-bit 2 to 1 and gate
	input [3:0] a, b;
	output [3:0] y;
	
	assign y = a & b;
	
endmodule

module _or2_4bits(a, b, y);		// 4-bit 2 to 1 or gate
	input [3:0] a, b;
	output [3:0] y;
	
	assign y = a | b;
	
endmodule

module _xor2_4bits(a, b, y);		// 4-bit 2 to 1 xor gate
	input [3:0] a, b;
	output [3:0] y;
	
	// instance 1-bit 2 to 1 xor gate
	_xor2 xor20(.a(a[0]), .b(b[0]), .y(y[0]));
	_xor2 xor21(.a(a[1]), .b(b[1]), .y(y[1]));
	_xor2 xor22(.a(a[2]), .b(b[2]), .y(y[2]));
	_xor2 xor23(.a(a[3]), .b(b[3]), .y(y[3]));
	
endmodule

module _xnor2_4bits(a, b, y);		// 4-bit 2 to 1 xnor gate
	input [3:0] a, b;
	output [3:0] y;
	wire [3:0] w;
	
	// use 4-bit 2 to 1 xor gate and inverting result with 4-bit inverter to get result of xnor
	_xor2_4bits xor20_4bits(.a(a), .b(b), .y(w));
	_inv_4bits inv_bits(.a(w), .y(y));
	
endmodule

module _inv_32bits(a, y);		// 32-bit inverter
	input [31:0] a;
	output [31:0] y;
	
	assign y = ~a;

endmodule

module _and2_32bits(a, b, y);		// 32-bit 2 to 1 and gate

	input [31:0] a, b;
	output [31:0] y;
	
	assign y = a & b;
	
endmodule

module _or2_32bits(a, b, y);		// 32-bit 2 to 1 or gate
	input [31:0] a, b;
	output [31:0] y;
	
	assign y = a | b;

endmodule

module _xor2_32bits(a, b, y);		// 32-bit 2 to 1 xor gate
	input [31:0] a, b;
	output [31:0] y;
	
	// instance 2 to 1 4-bit xor gate
	_xor2_4bits X0_xor2_4bits(.a(a[3:0]), .b(b[3:0]), .y(y[3:0]));
	_xor2_4bits X1_xor2_4bits(.a(a[7:4]), .b(b[7:4]), .y(y[7:4]));
	_xor2_4bits X2_xor2_4bits(.a(a[11:8]), .b(b[11:8]), .y(y[11:8]));
	_xor2_4bits X3_xor2_4bits(.a(a[15:12]), .b(b[15:12]), .y(y[15:12]));
	_xor2_4bits X4_xor2_4bits(.a(a[19:16]), .b(b[19:16]), .y(y[19:16]));
	_xor2_4bits X5_xor2_4bits(.a(a[23:20]), .b(b[23:20]), .y(y[23:20]));
	_xor2_4bits X6_xor2_4bits(.a(a[27:24]), .b(b[27:24]), .y(y[27:24]));
	_xor2_4bits X7_xor2_4bits(.a(a[31:28]), .b(b[31:28]), .y(y[31:28]));
	
endmodule

module _xnor2_32bits(a, b, y);		// 32-bit 2 to 1 xnor gate
	input [31:0] a, b;
	output [31:0] y;
	
	// instance 2 to 1 4-bit xnor gate
	_xnor2_4bits XN0_xnor2_4bits(.a(a[3:0]), .b(b[3:0]), .y(y[3:0]));
	_xnor2_4bits XN1_xnor2_4bits(.a(a[7:4]), .b(b[7:4]), .y(y[7:4]));
	_xnor2_4bits XN2_xnor2_4bits(.a(a[11:8]), .b(b[11:8]), .y(y[11:8]));
	_xnor2_4bits XN3_xnor2_4bits(.a(a[15:12]), .b(b[15:12]), .y(y[15:12]));
	_xnor2_4bits xN4_xnor2_4bits(.a(a[19:16]), .b(b[19:16]), .y(y[19:16]));
	_xnor2_4bits XN5_xnor2_4bits(.a(a[23:20]), .b(b[23:20]), .y(y[23:20]));
	_xnor2_4bits XN6_xnor2_4bits(.a(a[27:24]), .b(b[27:24]), .y(y[27:24]));
	_xnor2_4bits XN7_xnor2_4bits(.a(a[31:28]), .b(b[31:28]), .y(y[31:28]));
	
endmodule
