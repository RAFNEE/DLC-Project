module FactoCore(clk, reset_n, s_sel, s_wr, s_addr, s_din, s_dout, interrupt);
	input clk, reset_n, s_sel, s_wr;
	input [15:0] s_addr;
	input [63:0] s_din;
	output [63:0] s_dout;
	output reg interrupt;
	
	wire mul_done, mul_start, mul_clear;		// multiplier signals
	wire [63:0] opstart, opclear, opdone, intrEn, operand, result_h, result_l, multiplier;		// to connect registers in instantiated modules
	wire [127:0] result;
	
	// instance Factorial controller and booth multiplier
	FactoCtrl Unit_FactoCtrl(.clk(clk), .reset_n(reset_n), .mul_done(mul_done), .mul_start(mul_start), .mul_clear(mul_clear), .s_sel(s_sel), .s_wr(s_wr), .s_addr(s_addr), .s_din(s_din), .result(result), .opstart(opstart), .opclear(opclear), .opdone(opdone), .intrEn(intrEn), .operand(operand), .result_h(result_h), .result_l(result_l), .s_dout(s_dout), .multiplier(multiplier));
	multiplier Unit_multiplier(.clk(clk), .reset_n(reset_n), .multiplier(multiplier), .multiplicand(operand), .op_start(mul_start), .op_clear(mul_clear), .op_done(mul_done), .result(result));
	
	// set interrupt by opdone and intrEn
	always @ (*) begin
	
		if (opdone[1:0] == 2'b11 && intrEn[0] == 1)
			interrupt = 1'b1;
		else
			interrupt = 1'b0;
			
	end
	
endmodule
