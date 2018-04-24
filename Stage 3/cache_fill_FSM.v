module cache_fill_FSM(clk, rst, miss_detected, miss_address, fsm_busy, write_data_array, 
						write_tag_array, memory_address, memory_data, memory_data_valid);

input clk, rst;
input miss_detected;				// high when tag match logic detecs a miss
input memory_data_valid;			// high when valid data on memory_data line
input [15:0] miss_address;			// address that missed in cache
input [15:0] memory_data;			// data returned by memory

output reg fsm_busy;				// high when FSM handling a miss
output reg write_data_array;		// enable for writing from memory data to cache data array
output reg write_tag_array;			// enable for writing tag and valid bit in cache data array
output reg [15:0] memory_address;	// address being read from memory

// Internal signals
wire [3:0] state;
reg [3:0] nxt_state;

// FF for state
dff STATE0(.clk(clk), .rst(rst), .d(nxt_state[0]), .q(state[0]), .wen(1'b1));
dff STATE1(.clk(clk), .rst(rst), .d(nxt_state[1]), .q(state[1]), .wen(1'b1));
dff STATE2(.clk(clk), .rst(rst), .d(nxt_state[2]), .q(state[2]), .wen(1'b1));
dff STATE3(.clk(clk), .rst(rst), .d(nxt_state[3]), .q(state[3]), .wen(1'b1));

always @* begin
// Default signals
fsm_busy = 0;
write_data_array = 0;
write_tag_array = 0;
nxt_state = 0;

// State keeps track of # of 2 byte chuncks recieved
case (state)
	4'h0: begin		// IDLE
		fsm_busy = (miss_detected) ? 1 : 0;
		memory_address = (miss_detected) ? miss_address : 16'hxxxx;
		nxt_state = (miss_detected) ? 4'h1 : 4'h0;
	end
	4'h1: begin		// WAIT1
		fsm_busy = 1;
		write_data_array = (memory_data_valid) ? 1 : 0;
		nxt_state = (memory_data_valid) ? 4'h2 : 4'h1;
	end
	4'h2: begin		// WAIT2
		fsm_busy = 1;
		write_data_array = (memory_data_valid) ? 1 : 0;
		nxt_state = (memory_data_valid) ? 4'h3 : 4'h2;
	end
	4'h3: begin		// WAIT3
		fsm_busy = 1;
		write_data_array = (memory_data_valid) ? 1 : 0;
		nxt_state = (memory_data_valid) ? 4'h4 : 4'h3;
	end
	4'h4: begin		// WAIT4
		fsm_busy = 1;
		write_data_array = (memory_data_valid) ? 1 : 0;
		nxt_state = (memory_data_valid) ? 4'h5 : 4'h4;
	end
	4'h5: begin		// WAIT5
		fsm_busy = 1;
		write_data_array = (memory_data_valid) ? 1 : 0;
		nxt_state = (memory_data_valid) ? 4'h6 : 4'h5;
	end
	4'h6: begin		// WAIT6
		fsm_busy = 1;
		write_data_array = (memory_data_valid) ? 1 : 0;
		nxt_state = (memory_data_valid) ? 4'h7 : 4'h6;
	end
	4'h7: begin		// WAIT7
		fsm_busy = 1;
		write_data_array = (memory_data_valid) ? 1 : 0;
		nxt_state = (memory_data_valid) ? 4'h8 : 4'h7;
	end
	4'h8: begin		// WAIT8
		fsm_busy = 1;
		write_data_array = (memory_data_valid) ? 1 : 0;
		write_tag_array = (memory_data_valid) ? 1 : 0;
		nxt_state = (memory_data_valid) ? 4'h0 : 4'h8;
	end
endcase

end

endmodule
