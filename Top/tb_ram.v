`timescale 1ns/100ps

module tb_ram;
	reg clk, cen, wen;
	reg [7:0] s_addr;
	reg [63:0] s_din;
	wire [63:0] s_dout;
	
	// instance ram module
	ram Unit_ram(.clk(clk), .cen(cen), .wen(wen), .s_addr(s_addr), .s_din(s_din), .s_dout(s_dout));
	
	always begin
	
	#5; clk = ~clk;		// generate clock
	
	end
	
	initial begin
	
	// initialize signal
	clk = 1; cen = 0; wen = 0; s_addr = 8'b0; s_din = 64'b0;
	
	// write case
	#20; cen = 1; wen = 1; s_addr = 8'h00; s_din = 64'h1111_2222_EEEE_FFFF;
	#20; s_addr = 8'h02; s_din = 64'h1234_2345_3456_4567;
	#20; s_addr = 8'h05; s_din = 64'hAAAA_BBBB_CCCC_DDDD;
	
	// chip disable
	#20; cen = 0;
	#20; s_addr = 8'h10; s_din = 64'h0000_1111_FFFF_AAAA;
	
	// read case
	#20; cen = 1; wen = 0;
	#20; s_addr = 8'h00;
	#20; s_addr = 8'h02;
	#20; s_addr = 8'h05;
	#20; s_addr = 8'h10;
	
	// finish the simulation
	#50; $finish;
		
	end
endmodule 
