module mem_cache_interface(fsm_busy, write_data_array, write_tag_array, data_cache_write, D_miss, I_miss,
							D_addr, D_data, memory_data, I_addr, miss_detected, mem_en, mem_write, D_write,
							I_write, miss_address, mem_data_in, D_new_block, I_new_block);

// Correct the comments if they are wrong Marshall

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
output D_write;				// Write enable for D-cache
output I_write;				// Write-enable for I-cache
output [15:0] miss_address;	// Address that missed
output [15:0] mem_data_in;	// Data to write to memory
output [15:0] D_new_block;	// Data to write to D-cache
output [15:0] I_new_block;	// Data to write to I-cache

// Internal signals


// Two registers for D_request and I_request. They are set when their respective cache sends a miss signal.
// They reset when the fill fsm is no longer busy.
// If both asserted at once, I_request takes priority


endmodule
