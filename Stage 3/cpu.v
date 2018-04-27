module cpu(clk, rst_n, hlt, pc);

input clk;			// System clock
input rst_n;		// when low, resets processor and start address -> 0x0000

output hlt;			// Assert when instruction prior to HLT instruction is finished processing
output [15:0] pc;	// PC val of program

//////////////////////
// Internal Signals //
//////////////////////
// Global Signals
wire rst;

// Control Signals
wire IMM;						// Control signal for when an immediate value is needed by ALU and want to read reg from instruction[11:8] for read 2
wire PCS;						// Control signal for getting data to write to Data Memory
wire BR;						// Control signal for getting PC value from BR instruction
wire MemToReg;					// Control signal for write data from Data Memory to Register
wire MemRead;					// Control signal for reading from Data Memory
wire MemWrite;					// Control signal for writing to Data Memory
wire RegWrite;					// Control signal for writng to Register File
wire FlagWrite;					// Control signal for writing the Flag Register
wire BRANCH;					// Control signal for if instruction is a branch
wire SHIFT;						// Control signal for if instruction is a shift/rotate
wire Stall;						// Control signal for stalling the pipeline
wire Flush;						// Control signal for flushing data from IF/ID stage
wire [3:0] ALU_OP;				// Control signal for ALU Operation to be performed
wire halt;

// Instruction Memory Signals
wire [2:0] cc;					// Condition codes for branch instructions
wire [3:0] srcReg1;				// First source register
wire [3:0] srcReg2;				// Second source register
wire [3:0] dstReg;				// Destination register
wire [8:0] immediate;			// Immediate value for Branch instruction
wire [15:0] extended_immediate; // Immediate used for ALU ops
wire [15:0] instruction;		// Instruction obtained from PC val

// Register File Signals
wire [15:0] data_write_reg;		// Data to be written to a register
wire [15:0] src_data1;			// Data from reg1
wire [15:0] src_data2;			// Data from reg2

// Data Memory Signals
wire [15:0] data_write;			// Result of data to be written to Data Memory
wire [15:0] data_out;			// Data out from Data Memory
wire [15:0] data_out_final;		// Final output data (ALU result or Data Mem data)

// PC Signals
wire pc_branch;					// Branch signal determined by condition codes
wire [2:0] flags;				// Output from Flag register
wire [8:0] I_shift;				// Value of immediate left shifted by 1
wire [15:0] PC_in;				// Value of PC read from PC Reg
wire [15:0] PC_plus_two;		// Value of current pc + 2 for PCS instruction
wire [15:0] PC_branchi;			// Value of PC+2+(Imm<<1)
wire [15:0] PC_next;			// Value of PC after PC_control
wire [15:0] PC_final;			// Next value of PC after current instructions execution

// ALU Signals
wire [1:0] ALU_in1_sel;			// Select for 3:1 mux of ALU input 1
wire [1:0] ALU_in2_sel;			// Select for 3:1 mux of ALU input 2
wire [2:0] ALU_flags;			// Flag values of ALU operation
wire [15:0] ALU_in1;			// First input to ALU
wire [15:0] ALU_in2;			// Second input to ALU
wire [15:0] ALU_result;			// Result of ALU operation
wire [15:0] ALU_in1_int;		// Intermediate result for ALU in1

////////////////////
// Pipeline Signals
// ID
wire ID_BR;
wire [3:0] ID_ALU_OP;
wire [15:0] ID_PC_plus_two;
wire [15:0] ID_instruction;

// EX
wire EX_PCS;
wire EX_BR;
wire EX_BRANCH;
wire EX_IMM;
wire EX_MemWrite;
wire EX_MemRead;
wire EX_MemToReg;
wire EX_FlagWrite;
wire EX_halt;
wire [2:0] EX_cc;
wire [3:0] EX_dstReg;
wire [3:0] EX_Rs;
wire [3:0] EX_Rt;
wire [3:0] EX_ALU_OP;
wire [15:0] EX_PC_plus_two;
wire [15:0] EX_instruction;
wire [15:0] EX_PC_branchi;
wire [15:0] EX_extended_immediate;
wire [15:0] EX_src_data1;
wire [15:0] EX_src_data2;

// MEM
wire MEM_PCS;
wire MEM_halt;
wire MEM_MemWrite;
wire MEM_MemRead;
wire MEM_MemToReg;
wire [3:0] MEM_dstreg;
wire [3:0] MEM_Rd;
wire [15:0] MEM_data_write;
wire [15:0] MEM_ALU_result;
wire [15:0] MEM_PC_plus_two;
wire [15:0] MEM_instruction;

// WB
wire WB_PCS;
wire WB_halt;
wire WB_MemToReg;
wire [3:0] WB_Rd;
wire [15:0] WB_PC_plus_two;
wire [15:0] WB_instruction;
wire [15:0] WB_data_out;
wire [15:0] WB_ALU_result;

////////////////////
// Cache Signals
wire fsm_busy;					// Indicates a read from main memory is occuring
wire fsm_write_data;			// Signal to write data to cache
wire fsm_write_tag;				// Signal to write tag bits in cache
wire miss_detected;				// Indicates when a miss was detected by either cache
wire memory_data_valid;			// Indicates if the data read from memory is valid or not
wire mem_en;					// Enable for memory reads/writes
wire I_miss;					
wire D_miss;
wire I_write_data;
wire I_write_tag;
wire D_write_tag;
wire D_write_data;
wire I_stall;
wire D_stall;

wire [2:0] word_num;
wire [15:0] mem_addr;			// Address that main memory reads from
wire [15:0] miss_address;		// Address that resulted in a cache miss
wire [15:0] memory_data;		// Data that comes from main memory
wire [15:0] D_new_block;		// Data to write to the D-cache
wire [15:0] I_new_block;		// Data to write to the I-cache
wire [15:0] mem_data_in;		// Data to write to main memory


////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////
// Instantiate required modules //
//////////////////////////////////

// Register File
RegisterFile Regs(.clk(clk), .rst(rst), .SrcReg1(srcReg1), .SrcReg2(srcReg2), .DstReg(dstReg), 
			.WriteReg(WB_RegWrite), .DstData(data_write_reg), .SrcData1(src_data1), .SrcData2(src_data2));

// Flag Register
Flag_Reg F(.clk(clk), .rst(rst), .D(ALU_flags), .WriteReg(EX_FlagWrite), .Q(flags));

// Instruction Control block
instruction_control Control(.opcode(ID_instruction[15:12]), .ALU_OP(ALU_OP), .HLT(halt), .BR(BR), 
							.IMM(IMM), .PCS(PCS), .MemWrite(MemWrite), .MemRead(MemRead), 
							.MemToReg(MemToReg), .RegWrite(RegWrite), .FlagWrite(FlagWrite), 
							.BRANCH(BRANCH), .SHIFT(SHIFT));

// ALU
ALU_16bit ALU(.ALU_OP(EX_ALU_OP), .SrcData1(ALU_in1), .SrcData2(ALU_in2), .Flags(ALU_flags),
				.Result(ALU_result), .rst(rst));

// PC
PC_Reg PC(.clk(clk), .rst(rst), .D(PC_final), .WriteReg(~(Stall | D_stall | I_stall)), .Q(PC_in));

// Hazard Detection Unit
hazard_detection_unit HDU(.HLT(halt), .Branch(EX_BRANCH & pc_branch), .ID_instruction(ID_instruction[7:0]), 
						.EX_BR(EX_BR & pc_branch), .EX_dstreg(EX_dstReg), .EX_MemRead(EX_MemRead), 
						.Stall(Stall), .Flush(Flush));

// Data Forwarding Unit
forwarding FWD(.ALU_in1_sel(ALU_in1_sel), .ALU_in2_sel(ALU_in2_sel), .EX_Rs(EX_Rs), .EX_Rt(EX_Rt), .MEM_Rd(MEM_Rd), .WB_Rd(WB_Rd));

////////////////////////
// Pipeline Registers //
////////////////////////
IF_ID_reg ifid(.clk(clk), .rst(rst), .write(~(Stall | D_stall | I_stall)), .PC_plus_two(PC_plus_two), .instruction(instruction), 
				.flush(Flush | I_stall), .ID_PC_plus_two(ID_PC_plus_two), .ID_instruction(ID_instruction));
				
ID_EX_reg idex(.clk(clk), .rst(rst), .write(~D_stall), .ID_PC_plus_two(ID_PC_plus_two), .ID_instruction(ID_instruction), 
				.src_data1(src_data1), .src_data2(src_data2), .extended_immediate(extended_immediate), 
				.PC_branchi(PC_branchi), .ALU_OP(ALU_OP), .IMM(IMM), .cc(cc), .FlagWrite(FlagWrite),
				.BRANCH(BRANCH), .BR(BR), .RegWrite(RegWrite), .MemWrite(MemWrite), .MemRead(MemRead), 
				.MemToReg(MemToReg), .EX_PC_plus_two(EX_PC_plus_two), .EX_src_data1(EX_src_data1), 
				.EX_src_data2(EX_src_data2), .EX_extended_immediate(EX_extended_immediate), 
				.EX_PC_branchi(EX_PC_branchi), .EX_ALU_OP(EX_ALU_OP), .EX_Rs(EX_Rs), .EX_Rt(EX_Rt), 
				.EX_dstReg(EX_dstReg), .EX_IMM(EX_IMM), .EX_cc(EX_cc), .EX_FlagWrite(EX_FlagWrite), 
				.EX_BRANCH(EX_BRANCH), .EX_BR(EX_BR), .EX_RegWrite(EX_RegWrite), 
				.EX_MemWrite(EX_MemWrite), .EX_MemRead(EX_MemRead), .EX_MemToReg(EX_MemToReg),
				.EX_halt(EX_halt), .halt(halt), .SHIFT(SHIFT), .EX_SHIFT(), .EX_PCS(EX_PCS), .PCS(PCS));

EX_MEM_reg exmem(.clk(clk), .rst(rst), .write(~D_stall), .ALU_result(ALU_result), .EX_PC_plus_two(EX_PC_plus_two), 
				.data_write(data_write), .EX_dstReg(EX_dstReg), .EX_RegWrite(EX_RegWrite), 
				.EX_MemWrite(EX_MemWrite), .EX_MemRead(EX_MemRead), .MEM_ALU_result(MEM_ALU_result), 
				.MEM_PC_plus_two(MEM_PC_plus_two), .MEM_data_write(MEM_data_write), .MEM_Rd(MEM_Rd), 
				.MEM_RegWrite(MEM_RegWrite), .MEM_MemWrite(MEM_MemWrite), .MEM_MemRead(MEM_MemRead), 
				.EX_MemToReg(EX_MemToReg), .MEM_MemToReg(MEM_MemToReg), .EX_halt(EX_halt), 
				.MEM_halt(MEM_halt), .EX_PCS(EX_PCS), .MEM_PCS(MEM_PCS));

MEM_WB_reg memwb(.clk(clk), .rst(rst), .write(~D_stall), .MEM_ALU_result(MEM_ALU_result), .data_out(data_out), 
				.MEM_PC_plus_two(MEM_PC_plus_two), .MEM_Rd(MEM_Rd), .MEM_RegWrite(MEM_RegWrite), 
				.WB_ALU_result(WB_ALU_result), .WB_data_out(WB_data_out), .WB_PC_plus_two(WB_PC_plus_two), 
				.WB_Rd(WB_Rd), .WB_RegWrite(WB_RegWrite),.MEM_MemToReg(MEM_MemToReg), .WB_MemToReg(WB_MemToReg),
				.WB_halt(WB_halt), .MEM_halt(MEM_halt), .MEM_PCS(MEM_PCS), .WB_PCS(WB_PCS));

///////////////////
// Cache Modules //
///////////////////
cache_fill_FSM cache_fsm(.clk(clk), .rst(rst), .miss_detected(miss_detected), 
					.miss_address(miss_address), .fsm_busy(fsm_busy), .write_data_array(fsm_write_data), 
					.write_tag_array(fsm_write_tag), .memory_address(mem_addr),
					.memory_data(memory_data), .memory_data_valid(memory_data_valid), .word_num(word_num));

mem_cache_interface cache_interface(.fsm_busy(fsm_busy), .write_data_array(fsm_write_data), 
					.write_tag_array(fsm_write_tag), .data_cache_write(MEM_MemWrite), .D_miss(D_miss), 
					.I_miss(I_miss), .D_addr(MEM_ALU_result), .D_data(MEM_data_write), 
					.memory_data(memory_data), .I_addr(PC_in), .miss_detected(miss_detected),
					.mem_en(mem_en), .mem_write(mem_write), .D_write_tag(D_write_tag),
					.miss_address(miss_address), .mem_data_in(mem_data_in), .D_new_block(D_new_block),
					.I_new_block(I_new_block), .clk(clk), .rst(rst), .D_write_data(D_write_data),
					.I_write_data(I_write_data), .I_stall(I_stall), .D_stall(D_stall), 
					.I_write_tag(I_write_tag));

memory4c main_memory(.data_out(memory_data), .data_in(mem_data_in), .addr(mem_addr), .enable(mem_en), 
					.wr(mem_write), .clk(clk), .rst(rst), .data_valid(memory_data_valid));
					
cache D_Cache(.clk(clk), .rst(rst), .Address(MEM_ALU_result), .Data_In(D_new_block), 
				.Data_Out(data_out), .Write_Data_Array(D_write_data), .Write_Tag_Array(D_write_tag),
				.Miss(D_miss), .Read_Enable(MEM_MemRead), .Word_Num(word_num));

cache I_Cache(.clk(clk), .rst(rst), .Address(PC_in), .Data_In(I_new_block), 
				.Data_Out(instruction), .Write_Data_Array(I_write_data), .Write_Tag_Array(I_write_tag), 
				.Miss(I_miss), .Read_Enable(1'b1), .Word_Num(word_num));

////////////////
// PC Control //
////////////////
assign pc_branch = (cc == 3'b000) ? ~flags[2] :					// Not Equal (Z=0)
		(cc == 3'b001) ? flags[2] :							// Equal (Z=1)
		(cc == 3'b010) ? ~flags[2] & ~flags[0] :					// Greater than (Z=N=0)
		(cc == 3'b011) ? flags[0] : 							// Less than (N=1)
		(cc == 3'b100) ? flags[2] | (~flags[2] & ~flags[0]) : 		// Greater than or Equal (Z=1 or Z=N=0)
		(cc == 3'b101) ? flags[2] | flags[0] :					// Less than or Equal (N=1 or Z=1)
		(cc == 3'b110) ? flags[1] :							// Overflow (V=1)
		1'b1;											// Unconditional

assign I_shift = {immediate[7:0], 1'b0};

addsub_16bit adder1(.Sum(PC_plus_two), .Ovfl(), .A(PC_in), .B(16'h0002), .sub(1'b0));	// PC+2 adder
addsub_16bit adder2(.Sum(PC_branchi), .Ovfl(), .A(ID_PC_plus_two), .B({7'h0, I_shift}), .sub(1'b0));	// PC+2+immediate adder

assign PC_next = (EX_BRANCH & pc_branch) ? EX_PC_branchi : PC_plus_two;
	
/////////////////////////
// Combinational Logic //
/////////////////////////
assign rst = ~rst_n;					// Invert since reset isn't consistent across modules...
assign cc = ID_instruction[11:9];		// Bits containing the Condition Code for branches
assign immediate = ID_instruction[8:0];	// Immediate value for Branch instruction
assign extended_immediate = {8'h00, ID_instruction[7:0]};	// immediate value for alu ops
assign data_out_final = (WB_MemToReg) ? WB_data_out : WB_ALU_result;	// Data to Reg File is from Data Mem or ALU

// Inputs to Register File
assign srcReg1 = (MemWrite) ? ID_instruction[11:8] : ID_instruction[7:4];
assign srcReg2 = (SHIFT) ? ID_instruction[7:4] : (IMM) ? ID_instruction[11:8] : ID_instruction[3:0];	// Mux for read reg 2 input
assign dstReg = WB_Rd;
assign data_write_reg = (WB_PCS) ? WB_PC_plus_two : data_out_final;	// Mux for write data input

// Inputs to Data Memory
assign data_write = (EX_MemWrite) ? EX_src_data1 : EX_src_data2;

wire [15:0] alu_int_temp;

// Inputs to ALU
assign ALU_in1 = (EX_IMM) ? EX_extended_immediate : alu_int_temp;	// Mux for non-forwarded alu in1
mux_3_1 ALU_in1_mux(.out(alu_int_temp), .sel(ALU_in1_sel), .in1(EX_src_data1),
		.in2(data_out_final), .in3(MEM_ALU_result)); 					// Mux for ALU in1
		
mux_3_1 ALU_in2_mux(.out(ALU_in2), .sel(ALU_in2_sel), .in1(EX_src_data2),
		.in2(data_out_final), .in3(MEM_ALU_result));					// Mux for ALU in2

// PC Stuff
assign PC_final = (rst) ? 16'h0000 :		// RESET
				  (EX_BR & pc_branch) ? EX_src_data1 :		// BR mux
				  PC_next;					// default
				  
assign pc = PC_in;	// current value of PC during a given cycle

assign hlt = WB_halt;

endmodule








