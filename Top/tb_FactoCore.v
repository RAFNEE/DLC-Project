`timescale 1ns/100ps

module tb_FactoCore;
	reg clk, reset_n, s_sel, s_wr;
	reg [15:0] s_addr;
	reg [63:0] s_din;
	wire interrupt;
	wire [63:0] s_dout;
	
	// instance FactoCore module
	FactoCore Unit_FactoCore(.clk(clk), .reset_n(reset_n), .s_sel(s_sel), .s_wr(s_wr), .s_addr(s_addr), .s_din(s_din), .s_dout(s_dout), .interrupt(interrupt));
	
	always begin
	
	#5; clk = ~clk;		// generate clock
	
	end
	
	initial begin
	
	// initialize signals
	clk = 1; reset_n = 0; s_sel = 0; s_wr = 0; s_addr = 16'b0; s_din = 64'b0;
	
	// 483!, calculation
	#30; reset_n = 1; s_sel = 1; s_addr = 16'h7024; s_din = 64'd483; s_wr = 1;		// operand, 483
	#20; s_addr = 16'h701E; s_din = 64'd1;		// intrEn, 1
	#20; s_addr = 16'h700D; s_din = 64'd0;		// opclear, 0
	#20; s_addr = 16'h7004; s_din = 64'd1;		// opstart, 1
	#20; s_addr = 16'h7015; s_wr = 0;		// check opdone
	
	#310000; s_wr = 0; s_addr = 16'h7010;		// end of calculation, read opdone
	#20; s_addr = 16'h7028;		// read result_h
	#20; s_addr = 16'h7030;		// read result_l
	
	#20; s_wr = 1; s_addr = 16'h7008; s_din = 64'd1;		// write opclear, 1
	#10; s_addr = 16'h7008; s_din = 64'd0;		// write opclear, 0
	
	
	// 7!, calculation
	#10; reset_n = 1; s_sel = 1; s_addr = 16'h7023; s_din = 64'd7; s_wr = 1;		// operand, 7
	#20; s_addr = 16'h7018; s_din = 64'd1;		// intrEn, 1
	#20; s_addr = 16'h7008; s_din = 64'd0;		// opclear, 0
	#20; s_addr = 16'h7000; s_din = 64'd1;		// opstart, 1
	#20; s_addr = 16'h7010; s_wr = 0;		// check opdone
	
	#5000; s_wr = 0; s_addr = 16'h7010;		// end of calculation, read opdone
	#20; s_addr = 16'h7028;		// read result_h
	#20; s_addr = 16'h7030;		// read result_l
	
	#20; s_wr = 1; s_addr = 16'h7008; s_din = 64'd1;		// write opclear, 1
	#10; s_addr = 16'h7008; s_din = 64'd0;		// write opclear, 0
	
	
	// 1!, calculation, result_l : 1
	#10; s_sel = 1; s_addr = 16'h7021; s_din = 64'd1; s_wr = 1;		// operand, 1
	#20; s_addr = 16'h7018; s_din = 64'd1;		// intrEn, 1
	#20; s_addr = 16'h7008; s_din = 64'd0;		// opclear, 0
	#20; s_addr = 16'h7000; s_din = 64'd1;		// opstart, 1
	#20; s_addr = 16'h7010; s_wr = 0;		// check opdone
	
	#100; s_wr = 0; s_addr = 16'h7010;		// end of calculation, read opdone
	#20; s_addr = 16'h7028;		// read result_h
	#20; s_addr = 16'h7030;		// read result_l
	
	#20; s_wr = 1; s_addr = 16'h7008; s_din = 64'd1;		// write opclear, 1
	#10; s_addr = 16'h7008; s_din = 64'd0;		// write opclear, 0
	
	
	// 0!, calculation, result_l: 1
	#10; reset_n = 1; s_sel = 1; s_addr = 16'h7020; s_din = 64'd0; s_wr = 1;		// operand, 0
	#20; s_addr = 16'h7018; s_din = 64'd1;		// intrEn, 1
	#20; s_addr = 16'h7008; s_din = 64'd0;		// opclear, 0
	#20; s_addr = 16'h7000; s_din = 64'd1;		// opstart, 1
	#20; s_addr = 16'h7010; s_wr = 0;		// check opdone
	
	#100; s_wr = 0; s_addr = 16'h7010;		// end of calculation, read opdone
	#20; s_addr = 16'h7028;		// read result_h
	#20; s_addr = 16'h7030;		// read result_l
	
	
	// finish the simulation
	#1000; $finish;
	
	end

endmodule
