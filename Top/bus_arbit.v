module bus_arbit(clk, reset_n, m_req, m_grant);
	input clk, reset_n, m_req;
	output reg m_grant;
	
	reg state, next_state;		// state register
	
	parameter IDLE_STATE = 1'b0;
	parameter M_STATE = 1'b1;
	
	
	// if reset is 0
	always @ (posedge clk or negedge reset_n) begin
	
		if(reset_n == 0)
			state = IDLE_STATE;
		else state = next_state;
		
	end
	
	// state transition
	always @ (*) begin
	
		case (state)
		
		// IDLE STATE
		IDLE_STATE: begin
			if (m_req == 1) begin		// req is 1, master
				next_state = M_STATE;
			end
			else if(m_req == 0) begin		// req is 0, IDLE
				next_state = IDLE_STATE;
			end
			else begin
				next_state = 1'bx;
			end
		end
		
		// M STATE
		M_STATE: begin
			if (m_req == 0) begin		// req is 1, master
				next_state = IDLE_STATE;
			end
			else if (m_req == 1) begin		// req is 0, IDLE
				next_state = M_STATE;
			end
			else begin
				next_state = 1'bx;
			end
		end
		
		default: begin		// default value
			next_state = 1'bx;
		end
		
		endcase
		
	end
	
	always @ (*) begin
		
		case (state)
		
		// IDLE STATE, m_grant is 0
		IDLE_STATE: begin
			m_grant = 1'b0;
		end
		
		// M STATE, m_grant is 1
		M_STATE: begin
			m_grant = 1'b1;
		end
		
		default: begin
			m_grant = 1'bx;
		end
		
		endcase
		
	end
	
endmodule
