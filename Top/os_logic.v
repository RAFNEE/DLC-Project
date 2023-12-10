module os_logic(clk, reset_n, op_clear, multiplier, multiplicand, count, state, op_done, result);
	input clk, reset_n, op_clear;
	input [63:0] multiplier, multiplicand;
	input [6:0] count;
	input state;
	output op_done;
	output [127:0] result;
	
	reg op_done;
	reg [127:0] result;
	
	reg [127:0] next_result, temp_result;		// store next result and temporary result
	reg m_bit, sign_bit;		// to store x-1 bit and sign bit
	reg [63:0] add, sub;		// to store addition value and subtraction value
	
	wire [63:0] w_add, w_sub;		// to connect addition value and subtraction value
	
	parameter IDLE_STATE = 1'b0;
	parameter MUL_STATE = 1'b1;
	
	// instance addition or subtraction to use when result bit is 01 or 10
	cla64 U0_cla64(.a(next_result[127:64]), .b(multiplicand[63:0]), .ci(1'b0), .s(w_add));
	cla64 U1_cla64(.a(next_result[127:64]), .b(~multiplicand[63:0]), .ci(1'b1), .s(w_sub));
	
	// if reset_n is 0, reset all value
	always @ (posedge clk or negedge reset_n) begin
	
		if (reset_n == 0) begin
			result <= 128'b0;
			add = 64'b0;
			sub = 64'b0;
		end
		else begin
			if (op_clear == 1) result <= 128'b0;
			else result <= next_result;
			add = w_add;
			sub = w_sub;
		end
	end
	
	always @ (*) begin
		
		case (state)
		
		// IDLE STATE : initiate all register values
		IDLE_STATE: begin
			op_done = 1'b0;
			if (op_clear == 1) next_result = 128'b0;		// if op_clear is 1, set next_result is 0
			else next_result = {64'b0, multiplier};		// if not, set next_result
			temp_result = 128'b0;
			m_bit = 1'b0;
			sign_bit = 1'b0;
		end
		
		// MUL STATE : set register values correctly
		MUL_STATE: begin
			// if op_clear is 1, set all register values are zero
			if (op_clear == 1) begin
				op_done = 1'b0;
				next_result = 128'b0;
				temp_result = 128'b0;
				m_bit = 1'b0;
				sign_bit = 1'b0;
			end
			// if multiplying is end, set op_done and maintain current values
			if (count == 7'b1000000) begin
				op_done = 1'b1;
				next_result = result;
				temp_result = 128'b0;
				m_bit = 1'b0;
				sign_bit = 1'b0;
			end
			else begin	
			
				case ({result[0], m_bit})
				
				// 00, shift only
				{1'b0, 1'b0}: begin
					temp_result = result;		// store result in temporary result
					m_bit = result[0];		// set x-1 bit
					sign_bit = temp_result[127];		// store MSB in sign_bit
					next_result = {sign_bit, temp_result[127:1]};		// store arithmetic shift right result in next_result
				end
				
				// 01, add and shift
				{1'b0, 1'b1}: begin
					// store result in temporary result and addition value
					temp_result[127:64] = add;
					temp_result[63:0] = result[63:0];
					m_bit = result[0];		// set x-1 bit
					sign_bit = temp_result[127];		// set sign bit
					next_result = {sign_bit, temp_result[127:1]};		// store arithmetic shift right result in next_result
				end
				
				// 10, subtract and shift
				{1'b1, 1'b0}: begin
					// store result in temporary result and subtration value
					temp_result[127:64] = sub;
					temp_result[63:0] = result[63:0];
					m_bit = result[0];		// set x-1 bit
					sign_bit = temp_result[127];		// set sign bit
					next_result = {sign_bit, temp_result[127:1]};		// store arithmetic shift right result in next_result
				end
				
				// 11, shift only
				{1'b1, 1'b1}: begin
					temp_result = result;		// store result in temporary result
					m_bit = result[0];		// set x-1 bit
					sign_bit = temp_result[127];		// store MSB in sign_bit
					next_result = {sign_bit, temp_result[127:1]};		// store arithmetic shift right result in next_result
				end
				
				default: begin
					temp_result = result;
					op_done = 1'b0;
					m_bit = 1'b0;
					next_result = 128'b0;
				end
				
				endcase
				
			end
			
		end
			
		default: begin
			temp_result = result;
			op_done = 1'bx;
			m_bit = 1'bx;
			next_result = 128'bx;
		end
		
		endcase
		
	end
	
endmodule
