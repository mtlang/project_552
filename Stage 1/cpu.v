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
wire [3:0] ALU_OP;				// Control signal for ALU Operation to be performed

// Instruction Memory Signals
wire [2:0] cc;					// Condition codees for branch instructions
wire [3:0] srcReg1;				// First source register
wire [3:0] srcReg2;				// Second source register
wire [3:0] dstReg;				// Destination register
wire [8:0] immediate;			// Immediate value for Branch instruction
wire [15:0] extended_immediate;	// Immediate used for ALU ops
wire [15:0] instruction;		// Instruction obtained from PC val

// Register File Signals
wire [15:0] data_write_reg;		// Data to be written to a register
wire [15:0] src_data1;			// Data from reg1
wire [15:0] src_data2;			// Data from reg2

// Data Memory Signals
wire [15:0] data_write;			// Result of data to be written to Data Memory
wire [15:0] data_write_address; // Address for data to be written to in Data Memory
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
wire [2:0] ALU_flags;			// Flag values of ALU operation
wire [15:0] ALU_in1;			// First input to ALU
wire [15:0] ALU_in2;			// Second input to ALU
wire [15:0] ALU_result;			// Result of ALU operation


//////////////////////////////////
// Instantiate required modules //
//////////////////////////////////

// Writes to Data Memory
memory1cData DataMem(.data_out(data_out), .data_in(data_write), .addr(ALU_result), 
			.enable(MemWrite | MemRead), .wr(MemWrite), .clk(clk), .rst(rst));

// Reads from Instruction Memory
memory1c InstMem(.data_out(instruction), .data_in(16'hxxxx), .addr(PC_in), .enable(rst_n), 
			.wr(1'b0), .clk(clk), .rst(rst));

// Register File
RegisterFile Regs(.clk(clk), .rst(rst), .SrcReg1(srcReg1), .SrcReg2(srcReg2), .DstReg(dstReg), 
			.WriteReg(RegWrite), .DstData(data_write_reg), .SrcData1(src_data1), .SrcData2(src_data2));

// Flag Register
Flag_Reg F(.clk(clk), .rst(rst), .D(ALU_flags), .WriteReg(FlagWrite), .Q(flags));

// Instruction Control block
instruction_control Control(.opcode(instruction[15:12]), .ALU_OP(ALU_OP), .HLT(hlt), .BR(BR), 
							.IMM(IMM), .PCS(PCS), .MemWrite(MemWrite), .MemRead(MemRead), 
							.MemToReg(MemToReg), .RegWrite(RegWrite), .FlagWrite(FlagWrite), 
							.BRANCH(BRANCH), .SHIFT(SHIFT));

// ALU
ALU_16bit ALU(.ALU_OP(ALU_OP), .SrcData1(ALU_in1), .SrcData2(ALU_in2), .Flags(ALU_flags),
				.Result(ALU_result), .rst(rst));

// PC
PC_Reg PC(.clk(clk), .rst(rst), .D(PC_final), .WriteReg(1'b1), .Q(PC_in));

// PC Control Logic
assign pc_branch = (cc == 3'b000) ? ~flags[2] :					// Not Equal (Z=0)
		(cc == 3'b001) ? flags[2] :								// Equal (Z=1)
		(cc == 3'b010) ? ~flags[2] & ~flags[0] :				// Greater than (Z=N=0)
		(cc == 3'b011) ? flags[0] : 							// Less than (N=1)
		(cc == 3'b100) ? flags[2] | (~flags[2] & ~flags[0]) : 	// Greater than or Equal (Z=1 or Z=N=0)
		(cc == 3'b101) ? flags[2] | flags[0] :					// Less than or Equal (N=1 or Z=1)
		(cc == 3'b110) ? flags[1] :								// Overflow (V=1)
		1'b1;													// Unconditional
		
assign I_shift = {immediate[7:0], 1'b0};

addsub_16bit adder1(.Sum(PC_plus_two), .Ovfl(), .A(PC_in), .B(16'h0002), .sub(1'b0));	// PC+2
addsub_16bit adder2(.Sum(PC_branchi), .Ovfl(), .A(PC_plus_two), .B({7'h00, I_shift}), .sub(1'b0));	// PC+2+(Imm<<1)

assign PC_next = (BRANCH & pc_branch) ? PC_branchi : PC_plus_two;


	
/////////////////////////
// Combinational Logic //
/////////////////////////
assign rst = ~rst_n;					// Invert since reset isn't consistent across modules...
assign cc = instruction[11:9];
assign immediate = instruction[8:0];	// Immediate value for Branch instruction
assign extended_immediate = {8'h00, instruction[7:0]};	// Immediate value for ALU ops
assign data_out_final = (MemToReg) ? data_out : ALU_result;	// Data to Reg File is from Data Mem or ALU

// Inputs to Register File
assign srcReg1 = (MemWrite) ? instruction[11:8] : instruction[7:4];
assign srcReg2 = (SHIFT) ? instruction[7:4] : (IMM) ? instruction[11:8] : instruction[3:0];	// Mux for read reg 2 input
assign dstReg = instruction[11:8];
assign data_write_reg = (PCS) ? PC_plus_two : data_out_final;	// Mux for write data input

// Inputs to Data Memory
assign data_write = (MemWrite) ? src_data1 : src_data2;

// Inputs to ALU
assign ALU_in1 = (IMM) ? extended_immediate : src_data1;	// Mux for ALU input, zero extend imm
assign ALU_in2 = src_data2;

// PC Stuff
assign PC_final = (BR & pc_branch) ? src_data1 :		// BR mux Add ccc logic
				  (hlt) ? PC_in : 			// HLT mux
				  (rst) ? 16'h0000 :		// RESET
				  PC_next;					// default
assign pc = PC_in;

endmodule








