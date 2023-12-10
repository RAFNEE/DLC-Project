module FactoCtrl(clk, reset_n, mul_done, mul_start, mul_clear, s_sel, s_wr, s_addr, s_din, result, opstart, opclear, opdone, intrEn, operand, result_h, result_l, s_dout, multiplier);
	input clk, reset_n, mul_done, s_sel, s_wr;
	input [15:0] s_addr;
	input [63:0] s_din;
	input [127:0] result;
	output [63:0] s_dout;
	output reg mul_start, mul_clear;
	output reg [63:0] opstart, opclear, opdone, intrEn, operand, result_h, result_l, multiplier;		// offset register
	
	reg [2:0] state, next_state;		// state register
	reg [63:0] next_opstart, next_opdone, next_operand, next_result_h, next_result_l;		// next register
	
	wire [63:0] w_opstart, w_operand, w_opclear, w_opdone, w_intrEn, w_s_dout;		// wire for decoder
	wire [127:0] w_result;
	
	// set parameter state
	parameter IDLE = 3'b000;
	parameter START = 3'b001;
	parameter EXEC = 3'b010;
	parameter LAST = 3'b011;
	parameter DONE = 3'b100;
	parameter CLEAR = 3'b101;
	
	// instance decoder
	FactoDecoder Unit_FactoDecoder(.clk(clk), .reset_n(reset_n), .s_sel(s_sel), .s_wr(s_wr), .s_addr(s_addr), .s_din(s_din), .result(w_result), .opstart(w_opstart), .opclear(w_opclear), .opdone(w_opdone), .intrEn(w_intrEn), .operand(w_operand), .s_dout(w_s_dout));
	
	// reset logic when reset_n == 0
	always @ (posedge clk or negedge reset_n) begin
		
		// reset all registers
		if (reset_n == 0) begin
			opstart = 64'd0;
			opclear = 64'd0;
			opdone = 64'd0;
			intrEn = 64'd0;
			operand = 64'd0;
			result_h = 64'd0;
			result_l = 64'd1;
			state = IDLE;
		end
		else begin
			opstart = next_opstart;
			opclear = w_opclear;
			opdone = next_opdone;
			intrEn = w_intrEn;
			operand = next_operand;
			result_h = next_result_h;
			result_l = next_result_l;
			state = next_state;
		end
		
	end
	
	// next state logic
	always @ (*) begin
		
		case (state)
		
		// IDLE state : clear multiplier and set next state by opstart
		IDLE: begin
			mul_start = 1'b0;
			mul_clear = 1'b1;
			if (opstart[0] == 1 && opclear[0] == 0)
				next_state <= START;
			else
				next_state <= IDLE;
		end
		
		// START state : start multiplier and set next state by opclear and opdone in multiplier
		// exception : if operand == 0 or operand == 1, multiplier doesn't calculate factirial and set result for 1
		START: begin
			mul_start = 1'b1;		// set multiplier be start
			mul_clear = 1'b0;
			// exception case
			if (operand == 64'd0) begin
				next_state <= DONE;
				mul_start = 1'b0;
				mul_clear = 1'b1;		// set multiplier be clear
			end
			else if (operand == 64'd1) begin
				next_state <= DONE;
				mul_start = 1'b0;
				mul_clear = 1'b1;		// set multiplier be clear
			end
			// common case
			else begin
				if (opclear[0] == 1) begin
					mul_clear = 1'b1;		// set multiplier be clear
					mul_start = 1'b0;
					next_state <= CLEAR;
				end
				else if (mul_done == 1) begin
					mul_clear = 1'b1;		// set multiplier be clear
					next_state <= EXEC;
				end
			end
		end
		
		// EXEC state : start multiplier and set next state by opclear and opdone in multiplier while operand isn't 2
		EXEC: begin
			mul_start = 1'b1;		// set multiplier be start
			mul_clear = 1'b0;
			if (opclear[0] == 1) begin
				mul_clear = 1'b1;		// set multiplier be clear
				mul_start = 1'b0;
				next_state <= CLEAR;
			end
			else if (operand == 64'd2) begin
				next_state <= LAST;
			end
			else if (mul_done == 1) begin
				mul_clear = 1'b1;		// set multiplier be clear
				next_state <= EXEC;
			end
		end
		
		// LAST state : start multiplier and set next state by opclear and opdone in multiplier when operand is 2
		LAST: begin
			mul_start = 1'b1;		// set multiplier be start
			mul_clear = 1'b0;
			if (opclear[0] == 1) begin
				mul_clear = 1'b1;		// set multiplier be clear
				next_state <= CLEAR;
			end
			else if (mul_done == 1) begin
				next_state <= DONE;
			end
		
		end
		
		// DONE state : if opclear is active high, set next state be CLEAR state.
		// if not, stay DONE state
		DONE: begin
			if (opclear[0] == 1) begin
				mul_clear = 1'b1;		// set multiplier be clear
				mul_start = 1'b0;
				next_state <= CLEAR;
			end
			else
				next_state <= DONE;
		
		end
		
		// CLEAR state : clear registers and set next state
		CLEAR: begin
			mul_clear = 1'b1;		// set multiplier be clear
			mul_start = 1'b0;
			if (opclear[0] == 1)
				next_state <= CLEAR;
			else
				next_state <= IDLE;
		end
		
		endcase
		
	end
	
	always @ (*) begin
		
		case (state)
		
		// IDLE state
		IDLE: begin
			next_opdone = 64'd0;		// set opdone 0, indicating not started
			next_opstart = w_opstart;		// set opstart and opclear by decoder
			next_operand = w_operand;
			next_result_h = 64'd0;		// set result_h and result_l
			next_result_l = 64'd1;
			multiplier = result_l;		// set multiplier
		end
		
		// START state
		START: begin
			// exception operand
			// operand is 0
			if (operand == 64'd0) begin
				next_result_h = 64'd0;		// set result_h = 0
				next_result_l = 64'd1;		// set result_l = 1
				next_opdone = 64'd3;		// end of calculation
			end
			else if (operand == 64'd1) begin
				next_result_h = 64'd0;		//set result_h = 0
				next_result_l = 64'd1;		// set result_l = 1
				next_opdone = 64'd3;		// end of calculation
			end
			// common case
			else begin
				next_opdone = 64'd2;		// start factorail calculation
				next_operand = operand;		// set next_operand
				if (mul_done == 1)		// if multiplier is done
					next_operand = operand - 1;		// set next_operand be operand - 1
				next_result_h = result[127:64];		// set result_h be most 64-bit
				next_result_l = result[63:0];		// set result_l be least 64-bit
			end
			// if result_l == 0
			if (result_l == 64'd0)
				multiplier = result_h;		// set multiplier be result_h
			else
				multiplier = result_l;		// set multiplier be result_l
		end
		
		EXEC: begin
			next_operand = operand;		// set next_operand
			if (mul_done == 1)		// if multiplier is done
				next_operand = operand - 1;		// set next_operand be operand - 1
			next_result_h = result[127:64];		// set result_h be most 64-bit
			next_result_l = result[63:0];		// set result_l be least 64-bit
			// if result_l == 0
			if (result_l == 64'd0)
				multiplier = result_h;		// set multiplier be result_h
			else
				multiplier = result_l;		// set multiplier be result_l
		end
		
		LAST: begin
			next_operand = operand;		// set next_operand
			next_result_h = result[127:64];		// set result_h be most 64-bit
			next_result_l = result[63:0];		// set result_l be least 64-bit
			// if result_l == 0
			if (result_l == 64'd0)
				multiplier = result_h;		// set multiplier be result_h
			else
				multiplier = result_l;		// set multiplier be result_l
		end
		
		DONE: begin
			next_opdone = 64'd3;		// end of calculation
			next_operand = operand;		// set next_operand
			// exception
			if (operand == 64'd0 || operand == 64'd1) begin
				next_result_h = 64'd0;		// set result_h be 0
				next_result_l = 64'd1;		// set result_l be 1
			end
			else begin
				next_result_h = result[127:64];		// set result_h be most result
				next_result_l = result[63:0];		// set result_l be least result
			end
		end
		
		CLEAR: begin
			next_opdone = 64'd0;		// clear opdone
			next_opstart = 64'd0;		// clear opstart
			next_result_h = 64'd0;		// clear result_h
			next_result_l = 64'd1;		// clear result_l
		end
		
		endcase
	
	end
	
	assign s_dout = w_s_dout;		// assign s_dout by s_dout in decoder
	assign w_result[127:64] = result_h;		// assign result for decoder
	assign w_result[63:0] = result_l;		// assign result for decoder
	assign w_opdone = opdone;		// assign opdone for decoder
	
endmodule
