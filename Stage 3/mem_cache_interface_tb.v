module mem_cache_interface_tb ();

reg clk, rst;
reg fsm_busy;				// busy signal from cache fsm
reg write_data_array;		// fsm_write_data
reg write_tag_array;		// fsm_write_tag
reg data_cache_write;		// MEM_MemWrite
reg D_miss;				// Miss signal from D-cache
reg I_miss;				// Miss signal from I-cache
reg [15:0] D_addr;		// MEM_ALU_result
reg [15:0] D_data;		// MEM_data_write
reg [15:0] memory_data;	// data read from memory
reg [15:0] I_addr;		// Current PC value to read instruction

wire miss_detected;		// Indicates a D-cache or I-cache miss
wire mem_en;				// High when writing to mem or a cache miss
wire mem_write;			// Write enable for memory
wire D_write_data, D_write_tag;				// Write enable for D-cache
wire I_write_data, I_write_tag;				// Write-enable for I-cache
wire D_stall;
wire I_stall;
wire [15:0] miss_address;	// Address that missed
wire [15:0] mem_data_in;	// Data to write to memory
wire [15:0] D_new_block;	// Data to write to D-cache
wire [15:0] I_new_block;	// Data to write to I-cache

mem_cache_interface dut (.fsm_busy(fsm_busy), .write_data_array(write_data_array), .write_tag_array(write_tag_array), .data_cache_write(data_cache_write), .D_miss(D_miss), .I_miss(I_miss),
							.D_addr(D_addr), .D_data(D_data), .memory_data(memory_data), .I_addr(I_addr), .miss_detected(miss_detected), .mem_en(mem_en), .mem_write(mem_write), .D_write_tag(D_write_tag),
							.D_write_data(D_write_data), .I_write_tag(I_write_tag), .I_write_data(I_write_data), .miss_address(miss_address), .mem_data_in(mem_data_in), .D_new_block(D_new_block),
							.I_new_block(I_new_block), .clk(clk), .rst(rst), .I_stall(I_stall), .D_stall(D_stall));
							
initial begin
clk = 0;
rst = 1;
fsm_busy = 0;
write_data_array=0;
write_tag_array=0;
data_cache_write=0;
D_miss=0;
I_miss=0;
D_addr=16'h0000;
D_data = 16'h0000;
memory_data=16'h0000;
I_addr = 16'h0000;
#10;

rst = 0;
#10;

I_miss=1'b1;
write_tag_array=1'b1;
write_data_array=1'b1;



end

always
	#5 clk = ~clk;

endmodule
