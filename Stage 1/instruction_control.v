module instruction_control(opcode, ALU_OP, HLT, BR, IMM, PCS, MemWrite, MemRead, MemToReg, 
							RegWrite, FlagWrite, BRANCH, SHIFT);

input [3:0] opcode;			// instruction opcode

output reg IMM;				// Assert if SW instructinon
output reg BR;				// Assert if BR instruction
output reg HLT;				// Assert if HLT instruction
output reg PCS;				// Assert if PCS instruction
output reg MemWrite;		// Assert if writing to Mem
output reg MemRead;			// Assert if reading from Mem
output reg MemToReg;		// Assert if writing to Reg from Mem
output reg RegWrite;		// Assert if writing to a register
output reg FlagWrite;		// Assert if operation can write flags
output reg BRANCH;			// Assert if operation is a branch instruction
output reg SHIFT;			// Assert if a shift instruction
output reg [3:0] ALU_OP;	// Specify ALU Operation

/////////////////////////
// Combinational Logic //
/////////////////////////
always @* begin
	// Default assignments
	assign HLT = 0;
	assign BR = 0;
	assign IMM = 0;
	assign PCS = 0;
	assign MemWrite = 0;
	assign MemRead = 0;
	assign MemToReg = 0;
	assign RegWrite = 0;
	assign BRANCH = 0;
	assign FlagWrite = 0;
	assign ALU_OP = 4'hf;
	assign SHIFT = 0;
	
	case (opcode)
	4'h0: begin	// ADD
		assign ALU_OP = 4'b1001;
		assign FlagWrite = 1;
		assign RegWrite = 1;
	end
	4'h1: begin	// SUB
		assign ALU_OP = 4'b1010;
		assign FlagWrite = 1;
		assign RegWrite = 1;
	end
	4'h2: begin	// RED
		assign ALU_OP = 4'b0000;
		assign RegWrite = 1;
	end
	4'h3: begin	// XOR
		assign ALU_OP = 4'b1011;
		assign FlagWrite = 1;
		assign RegWrite = 1;
	end
	4'h4: begin	// SLL
		assign ALU_OP = 4'b0100;
		assign SHIFT = 1;
		assign FlagWrite = 1;
		assign IMM = 1;
		assign RegWrite = 1;
	end
	4'h5: begin	// SRA
		assign ALU_OP = 4'b0001;
		assign SHIFT = 1;
		assign IMM = 1;
		assign FlagWrite = 1;
		assign RegWrite = 1;
	end
	4'h6: begin	// ROR
		assign ALU_OP = 4'b0010;
		assign SHIFT = 1;
		assign IMM = 1;
		assign FlagWrite = 1;
		assign RegWrite = 1;
	end
	4'h7: begin	// PADDSB
		assign ALU_OP = 4'b0011;
		assign RegWrite = 1;
	end
	4'h8: begin	// LW
		assign ALU_OP = 4'b0101;
		assign SHIFT = 1;
		assign IMM = 1;
		assign RegWrite = 1;
		assign MemRead = 1;
		assign MemToReg = 1;
	end
	4'h9: begin	// SW
		assign ALU_OP = 4'b0110;
		assign IMM = 1;
		assign SHIFT = 1;
		assign MemWrite = 1;
	end
	4'hA: begin	// LHB
		assign ALU_OP = 4'b0111;
		assign RegWrite = 1;
		assign IMM = 1;
	end
	4'hB: begin	// LLB
		assign ALU_OP = 4'b1000;
		assign RegWrite = 1;
		assign IMM = 1;
	end
	4'hC: begin	// B
		assign BRANCH = 1;
	end
	4'hD: begin	// BR
		assign BR = 1;
	end
	4'hE: begin	// PCS
		assign PCS = 1;
		assign RegWrite = 1;
	end
	4'hF: begin	// HLT
		assign HLT = 1;
	end
	default: begin
		// Shouldn't be here
	end
	endcase
 end


endmodule
