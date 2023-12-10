module fa_v2(a, b, ci, s);
	input a, b, ci;
	output s;
	wire w0;
	
	// full adder without carry out
	_xor2 fa_xor20(.a(a), .b(b), .y(w0));
	_xor2 fa_xor21(.a(ci), .b(w0), .y(s));
	
endmodule
