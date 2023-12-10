module FactoDecoder(clk, reset_n, s_sel, s_wr, s_addr, s_din, result, opstart, opclear, opdone, intrEn, operand, s_dout);
	input clk, reset_n, s_sel, s_wr;
	input [15:0] s_addr;
	input [63:0] s_din, opdone;		// input register offset
	input [127:0] result;
	
	output reg [63:0] opstart, opclear, intrEn, operand, s_dout;		// output register offset
	
	reg [63:0] result_h, result_l;		// result register
	reg [12:0] upper_bit;		// address most 13-bit of s_addr
	
	always @ (*) begin
		
		upper_bit = s_addr[15:3];		// set upper_bit
		result_h = result[127:64];		// set result_h be most result 64-bit
		result_l = result[63:0];		// set result_l be least result 64-bit
		
		// reset logic
		if (reset_n == 0) begin
		
			opstart = 64'd0;
			opclear = 64'd0;
			intrEn = 64'd0;
			operand = 64'd0;
			result_h = 64'd0;
			result_l = 64'd1;
			s_dout = 64'd0;
			
		end
		// else selected
		else if (reset_n == 1 && s_sel == 1) begin
			
			case ({upper_bit, s_wr})
				
				{13'b0111_0000_0000_0, 1'b1}:		// offset == 0x7000
					if(opdone[1:0] == 2'b00) opstart = s_din;		// if factorial core isn't calculating
				{13'b0111_0000_0000_1, 1'b1}:		// offset == 0x7008
					opclear = s_din;		// set opclear
				{13'b0111_0000_0001_0, 1'b0}:		// offset == 0x7010
					s_dout = opdone;		// set s_dout by opdone
				{13'b0111_0000_0001_1, 1'b1}:		// offset == 0x7018
					intrEn = s_din;		// set intrEn
				{13'b0111_0000_0010_0, 1'b1}:		// offset == 0x7020
					operand = s_din;		// set operand
				{13'b0111_0000_0010_1, 1'b0}:		// offset == 0x7028
					s_dout = result_h;		// set s_dout by result_h
				{13'b0111_0000_0011_0, 1'b0}:		// offset == 0x7030
					s_dout = result_l;		// set s_dout by result_l
					
			endcase
				
		end
		
	end
	
endmodule
