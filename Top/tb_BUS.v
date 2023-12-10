`timescale 1ns/100ps

module tb_BUS;
	reg clk, reset_n, m_req, m_wr;
	reg [15:0] m_addr;
	reg [63:0] m_dout, s0_dout, s1_dout;
	wire m_grant, s0_sel, s1_sel, s_wr;
	wire [15:0] s_addr;
	wire [63:0] m_din, s_din;
	
	// instance BUS module
	BUS Unit_BUS(.clk(clk), .reset_n(reset_n), .m_req(m_req), .m_wr(m_wr), .m_addr(m_addr), .m_dout(m_dout), .s0_dout(s0_dout), .s1_dout(s1_dout), .m_grant(m_grant), .m_din(m_din), .s0_sel(s0_sel), .s1_sel(s1_sel), .s_addr(s_addr), .s_wr(s_wr), .s_din(s_din));
	
	always begin
	
	#5; clk = ~clk;		// generate clock
	
	end
	
	initial begin
	
	// initialize signal
	clk = 1; reset_n = 0; m_req = 0; m_wr = 0; m_addr = 16'b0; m_dout = 64'b0; s0_dout = 64'b0; s1_dout = 64'b0;
	
	// m_req = 1
	#10; reset_n = 1; m_req = 1;
	
	// slave 0
	#10; m_addr = 16'h0056; s0_dout = 64'h1111_FFFF; m_dout = 64'hABCD;
	#10; m_wr = 1;
	#10; s0_dout = 64'h2222_3333; m_dout = 64'h9876;
	#10; m_wr = 0;
	
	// slave 1
	#10; m_addr = 16'h7001; s1_dout = 64'd500; m_dout = 64'd100;
	#10; m_wr = 1;
	#10; m_addr = 16'h7100;
	#10; s1_dout = 64'd312; m_dout = 64'd192;
	
	// not selected
	#10 m_addr = 16'hFFEE; m_dout = 64'd10;
	
	// finish the simulation
	#10; $finish;
	end
endmodule

