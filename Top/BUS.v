module BUS(clk, reset_n, m_req, m_wr, m_addr, m_dout, s0_dout, s1_dout, m_grant, m_din, s0_sel, s1_sel, s_addr, s_wr, s_din);
	input clk, reset_n, m_req, m_wr;
	input [15:0] m_addr;
	input [63:0] m_dout, s0_dout, s1_dout;
	output m_grant, s0_sel, s1_sel, s_wr;
	output [15:0] s_addr;
	output [63:0] m_din, s_din;
	
	wire [1:0] sel;		// connect value with flip-flop
	
	// instance modules
	_dff_r U0_dff_r(.clk(clk), .reset_n(reset_n), .d(s0_sel), .q(sel[0]));		// using flip-flop to connect select value
	_dff_r U1_dff_r(.clk(clk), .reset_n(reset_n), .d(s1_sel), .q(sel[1]));
	
	// instance mux to select m value
	mux2 U0_mux2(.d0(1'b0), .d1(m_wr), .s(m_grant), .y(s_wr));		// write value
	mux2_16bit U1_mux2_16(.d0(16'b0), .d1(m_addr), .s(m_grant), .y(s_addr));		// address
	mux2_64bit U2_mux2_64(.d0(64'b0), .d1(m_dout), .s(m_grant), .y(s_din));		// m_dout to s_din
	mux3_64bit U3_mux3_64(.d0(s0_dout), .d1(s1_dout), .d2(64'h0), .s(sel), .y(m_din));		// s_dout and 0 to m_din
	
	bus_arbit Unit_arbiter(.clk(clk), .reset_n(reset_n), .m_req(m_req), .m_grant(m_grant));		// instance arbiter
	bus_addr Unit_addr_decoder(.s_address(s_addr), .m_req(m_req), .s0_sel(s0_sel), .s1_sel(s1_sel));		// instance address decoder
	
endmodule
