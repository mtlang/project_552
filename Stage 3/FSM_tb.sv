module FSM_tb();

logic clk, rst;
logic miss_detected;
logic memory_data_valid;
logic [15:0] miss_address;
logic [15:0] memory_data;

logic fsm_busy;
logic write_data_array;
logic write_tag_array;
logic [2:0] word;
logic [15:0] memory_address;

cache_fill_FSM DUT(.clk(clk), .rst(rst), .miss_detected(miss_detected), .miss_address(miss_address), .fsm_busy(fsm_busy),
		.write_data_array(write_data_array), .write_tag_array(write_tag_array), .memory_address(memory_address), .memory_data(memory_data),
		.memory_data_valid(memory_data_valid), .word_num(word));

initial begin
clk = 0;
rst = 1;
miss_detected = 0;
memory_data_valid = 0;
miss_address = 16'h0046;
memory_data = 16'h0000;

#10;

rst = 0;

#10;

miss_detected = 1;

#10;

miss_detected = 0;

#25;


memory_data_valid = 1;
memory_data = 16'h4567;

#10;



#40;



#50;
memory_data_valid = 0;

$stop();

end

always
	#5 clk = ~clk;

endmodule
