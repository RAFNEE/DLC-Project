module Top(clk, reset_n, m_req, m_wr, m_addr, m_dout, m_grant, m_din, interrupt);
	input clk, reset_n, m_req, m_wr;
	input [15:0] m_addr;
	input [63:0] m_dout;
	output m_grant, interrupt;
	output [63:0] m_din;
	
	wire m_grant, s0_sel, s1_sel, s_wr;
	wire [15:0] s_addr;
	wire [63:0] s0_dout, s1_dout, s_din;
	
	// instance BUS, ram, and Factorial Core
	ram Unit_ram(.clk(clk), .cen(s0_sel), .wen(s_wr), .s_addr(s_addr[10:3]), .s_din(s_din), .s_dout(s0_dout));
	BUS Unit_BUS(.clk(clk), .reset_n(reset_n), .m_req(m_req), .m_wr(m_wr), .m_addr(m_addr), .m_dout(m_dout), .s0_dout(s0_dout), .s1_dout(s1_dout), .m_grant(m_grant), .m_din(m_din), .s0_sel(s0_sel), .s1_sel(s1_sel), .s_addr(s_addr), .s_wr(s_wr), .s_din(s_din));
	FactoCore Unit_FactoCore(.clk(clk), .reset_n(reset_n), .s_sel(s1_sel), .s_wr(s_wr), .s_addr(s_addr), .s_din(s_din), .s_dout(s1_dout), .interrupt(interrupt));
   
endmodule
