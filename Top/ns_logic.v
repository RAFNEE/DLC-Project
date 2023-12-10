module ns_logic(clk, reset_n, op_start, op_clear, op_done, state, count);
	input clk, reset_n, op_start, op_clear, op_done;
	output state;
	output [6:0] count;
	
	reg state, next_state;
	reg [6:0] count, next_count;
	
	reg [6:0] cla_count;
	wire [7:0] added_cla;
	
	parameter IDLE_STATE = 1'b0;
	parameter MUL_STATE = 1'b1;
	
	initial begin
		state = IDLE_STATE;
		next_count = 7'b0;
	end
	
	cla8 U0_cla8(.a({1'b0, next_count}), .b(8'b0000_0001), .ci(1'b0), .s(added_cla));		// count up
	
	always @ (posedge clk or negedge reset_n or posedge op_clear) begin
		if(reset_n == 0 || op_clear == 1) cla_count = 7'b0;
		else cla_count = added_cla[6:0];
	end
		
	// booth multiplication logic which move state or maintain current state
	always @ (*) begin
		if (op_clear == 1'b1) begin
			next_state = IDLE_STATE;
			next_count = 7'b0;
		end
		
		case(state)
		
		// IDLE STATE : select state by multiply condition
		IDLE_STATE: begin
			// transition to MUL_STATE by condition
			if (op_start == 1'b1 && op_clear == 1'b0 && op_done == 1'b0) begin
				next_state <= MUL_STATE;
				next_count <= cla_count;
			end
			// stay state
			else begin
				next_state <= IDLE_STATE;
				next_count <= count;
			end
			// if op_clear is 1, initialize state
			if (op_clear == 1'b1) begin
				next_state <= IDLE_STATE;
				next_count <= 7'b0;
			end
		end
		// MUL STATE : if multiplication is done, keep count. if not, multiply	
		MUL_STATE: begin
			// if op_clear is 1, initialize state
			if (op_clear == 1'b1) begin
				next_state <= IDLE_STATE;
				next_count <= 7'b0;
			end
			else begin
				// if multiplying is done, stay current state and count
				if (count == 7'b1000000) begin
					next_state <= MUL_STATE;
					next_count <= count;
				end
				// multiplying
				else begin
					next_state <= MUL_STATE;
					next_count <= cla_count;
				end
			end
		end
		
		default: begin
			next_state = 1'bx;
			next_count = 7'bx;
		end
		
		endcase
		
	end
	
	// reset logic
	always @ (posedge clk or negedge reset_n) begin
		if(reset_n == 0) begin
			state <= IDLE_STATE;
			count <= 7'b0;
		end
		else begin
			state <= next_state;
			count <= next_count;
		end
	end
	
endmodule
