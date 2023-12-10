`timescale 1ns/100ps

module tb_Top;
	reg clk, m_req, m_wr, reset_n;
	reg [15:0] m_addr;
	reg [63:0] m_dout;
	
	wire m_grant, interrupt;
	wire [63:0] m_din;
	
	// instance top module
	Top Unit_Top(.clk(clk), .reset_n(reset_n), .m_req(m_req), .m_wr(m_wr), .m_addr(m_addr), .m_dout(m_dout), .m_grant(m_grant), .m_din(m_din), .interrupt(interrupt));
	
	always begin
	
	#5; clk = ~clk;		// generate clock
	
	end
	
	initial begin
	
	// initialize signals
	reset_n = 0; m_req = 0; m_wr = 0; clk = 0; m_addr = 16'h7000; m_dout = 64'd1;
	
	// clear
	#10; reset_n = 1; m_wr = 1; m_addr = 16'h7008; m_dout = 64'd0;
	#10; m_addr = 16'h7008; m_dout = 64'd1;
	#10; m_addr = 16'h7008; m_dout = 64'd0;
	
	// 616!
	#10; m_wr = 1;	m_req = 1; m_addr = 16'h7020; m_dout = 64'd616;		// write operand
	#10; m_req = 1; m_addr = 16'h701B; m_dout = 64'd1;		// write interrupt
	#10; m_addr = 16'h7004; m_dout = 64'd1;		// write opstart
	#10; m_addr = 16'h7013; m_wr = 0;		// read opdone
	#500000; m_addr = 16'h7029;		// read result_h
	#200; m_addr = 16'h7036;		// read result_l
	
	#100; m_wr = 1; m_req = 1; m_dout = m_din; m_addr = 16'h07EE;		// store result in memory[0x07EE]
	#10; m_addr = 16'h7008; m_dout = 64'd1;		// write opclear to 1
	#10; m_dout = 64'd0;		// write opclear to 0
	
	#10; m_wr = 1; m_req = 1; m_dout = 64'h1234_9876; m_addr = 16'h0000;		// write dout in memory[0x0000]
	#10; m_req = 1; m_wr = 0;		// read
	#10; m_addr = 16'h07EE;		// read value in memory[0x07EE]
	#10; m_wr = 1; m_dout = 64'hFFFF_EEEE_9999_3333; m_addr = 16'h0ABE;		// write dout in memory[0x0ABE]
	#10; m_addr = 16'h0ABE; m_wr = 0;		// read value in memory[0x0ABE]
	
	#10; m_wr = 1; m_addr = 16'h7008; m_dout = 64'd1;		// write opclear to 1
	#10; m_dout = 64'd0;		// write opclear to 0
	
	// 10!
	#10; m_wr = 1;	m_req = 1; m_addr = 16'h7020; m_dout = 64'd10;		// write operand
	#10; m_req = 1; m_addr = 16'h7018; m_dout = 64'd1;		// write interrupt
	#10; m_addr = 16'h7000; m_dout = 64'd1;		// write opstart
	#10; m_addr = 16'h7010; m_wr = 0;		// read opdone
	#6500; m_addr = 16'h7028;		// read result_h
	#200; m_addr = 16'h7030;		// read result_l
	
	#100; m_wr = 1; m_req = 1; m_dout = m_din; m_addr = 16'h03AB;		// store result in memory[0x03AB]
	#10; m_addr = 16'h7008; m_dout = 64'd1;		// write opclear to 1
	#10; m_dout = 64'd0;		// write opclear to 0
	
	#10; m_wr = 1; m_req = 1; m_dout = 64'hAAAA_BBBB; m_addr = 16'h00FF;		// write dout in memory[0x00FF]
	#10; m_req = 1; m_wr = 0;		// read
	#10; m_addr = 16'h00FF;		// read value in memory[0x00FF]
	#10; m_wr = 1; m_dout = 64'hABCD_1234; m_addr = 16'h0123;		// write dout in memory[0x0123]
	#10; m_addr = 16'h0123; m_wr = 0;		// read value in memory[0x0123]
	
	#10; m_addr = 16'h7008; m_dout = 64'd1;		// write opclear to 1
	#10; m_dout = 64'd0;		// write opclear to 0
	
	// finish the simulation
	#100; $finish;
	end
	
endmodule
