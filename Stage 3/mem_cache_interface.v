module mem_cache_interface(fsm_busy, write_data_array, write_tag_array, data_cache_write, D_miss, I_miss,
							D_addr, D_data, memory_data, I_addr, miss_detected, mem_en, mem_write, D_write_tag,
							D_write_data, I_write_tag, I_write_data, miss_address, mem_data_in, D_new_block,
							I_new_block, clk, rst, I_stall, D_stall);

input clk, rst;
input fsm_busy;				// busy signal from cache fsm
input write_data_array;		// fsm_write_data
input write_tag_array;		// fsm_write_tag
input data_cache_write;		// MEM_MemWrite
input D_miss;				// Miss signal from D-cache
input I_miss;				// Miss signal from I-cache
input [15:0] D_addr;		// MEM_ALU_result
input [15:0] D_data;		// MEM_data_write
input [15:0] memory_data;	// data read from memory
input [15:0] I_addr;		// Current PC value to read instruction

output miss_detected;		// Indicates a D-cache or I-cache miss
output mem_en;				// High when writing to mem or a cache miss
output mem_write;			// Write enable for memory
output D_write_data, D_write_tag;				// Write enable for D-cache
output I_write_data, I_write_tag;				// Write-enable for I-cache
output D_stall;
output I_stall;
output [15:0] miss_address;	// Address that missed
output [15:0] mem_data_in;	// Data to write to memory
output [15:0] D_new_block;	// Data to write to D-cache
output [15:0] I_new_block;	// Data to write to I-cache

// Internal signals
wire d_st;

dff d_stall(.clk(clk), .rst(rst), .d(D_miss), .q(d_st), .wen(D_miss));

// Assign outputs
assign miss_detected = D_miss | I_miss;
assign miss_address = (I_miss) ? I_addr : D_addr;

assign mem_en = fsm_busy;
assign mem_data_in = (data_cache_write & D_miss) ? D_data : 16'hxxxx;
assign mem_write = (data_cache_write & ~D_miss & ~I_miss);

assign D_write_tag =  D_miss & write_tag_array & data_cache_write & ~I_miss; 
assign D_write_data = (data_cache_write & ~I_miss) ? 1'b1 : D_miss & write_data_array & ~I_miss;
assign D_new_block = (write_data_array) ? D_data : (data_cache_write) ? memory_data : D_data;

assign I_write_tag = (I_miss & write_tag_array);
assign I_write_data = (I_miss & write_data_array);
assign I_new_block = memory_data;

assign D_stall = D_miss;
assign I_stall = I_miss;

endmodule
