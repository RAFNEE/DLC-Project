module bus_addr(s_address, m_req, s0_sel, s1_sel);
	input m_req;
	input [15:0] s_address;
	output s0_sel, s1_sel;
	
	reg s0_sel, s1_sel;
	
	always @ (*) begin
	
		if (s_address >= 16'h0000 && s_address < 16'h0800 && m_req == 1) begin		// 0x0000 ~ 0x07FF
			s0_sel = 1'b1;
			s1_sel = 1'b0;
		end
		else if (s_address >= 16'h7000 && s_address < 16'h7200 && m_req == 1) begin		// 0x7000 ~ 0x71FF
			s0_sel = 1'b0;
			s1_sel = 1'b1;
		end
		else begin		// else wrong address
			s0_sel = 1'b0;
			s1_sel = 1'b0;
		end
		
	end
	
endmodule
