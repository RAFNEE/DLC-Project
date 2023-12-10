module ram(clk, cen, wen, s_addr, s_din, s_dout);
	input clk, cen, wen;
	input [7:0] s_addr;
	input [63:0] s_din;
	output reg [63:0] s_dout;
	
	reg [63:0] mem [0:255];
	
	// initialize mem memory
	integer i;
	initial begin
		for (i = 0; i < 256; i = i + 1) begin
			mem[i] = 64'h0;
		end
	end
	
	always @ (posedge clk) begin
		
		// if cen == 1 && wen == 1, write s_din in mem
		if (cen == 1 && wen == 1) begin
			mem[s_addr] = s_din;
			s_dout = 64'h0;
		end
		// if cen == 1 && wen == 0, read s_dout in mem
		else if (cen == 1 && wen == 0) begin
			s_dout = mem[s_addr];
		end
		// if cen == 0, s_dout must be 0
		else if (cen == 0) begin
			s_dout = 64'h0;
		end
		else begin
			s_dout = 64'hx;
		end
	
	end
	
endmodule
