module mux2(d0, d1, s, y);
	input d0, d1, s;
	output y;
	wire sb, w0, w1;
	
	_inv inv0(.a(s), .y(sb));		// inverting s
	_nand2 nand20(.a(d0), .b(sb), .y(w0));		// ~(d0 & ~s)
	_nand2 nand21(.a(d1), .b(s), .y(w1));		// ~(d1 & s)
	_nand2 nand22(.a(w0), .b(w1), .y(y));		// d0s' + d1s
	
endmodule
