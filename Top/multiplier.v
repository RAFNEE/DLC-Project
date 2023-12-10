module multiplier(clk, reset_n, multiplier, multiplicand, op_start, op_clear, op_done, result);
	input clk, reset_n, op_start, op_clear;
	input [63:0] multiplier, multiplicand;
	output op_done;
	output [127:0] result;
	
	wire state;
	wire [6:0] count;
	
	// instance ns logic and os logic to multiply
	ns_logic Unit_ns_logic(.clk(clk), .reset_n(reset_n), .count(count), .op_start(op_start), .op_clear(op_clear), .op_done(op_done), .state(state));
	os_logic Unit_os_logic(.clk(clk), .reset_n(reset_n), .op_clear(op_clear), .multiplier(multiplier), .multiplicand(multiplicand), .count(count), .op_done(op_done), .state(state), .result(result));
	
endmodule
