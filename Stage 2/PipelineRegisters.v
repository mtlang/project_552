module IF_ID_reg(clk, rst, write, PC_plus_two, instruction, flush, ID_PC_plus_two, ID_instruction);

input clk, rst, write;
input [15:0] PC_plus_two;
input [15:0] instruction;
input flush;

output [15:0] ID_PC_plus_two;
output [15:0] ID_instruction;

// Internal signals
wire [15:0] instruction_final;

// If flush is asserted, instruction will be converted to SRA $0, $0, 0 (equivalent to NOP)
assign instruction_final = (flush) ? 16'h1000 : instruction;

// Instantiate registers for pipelining signals
register_16bit Inst_Reg(.clk(clk), .rst(rst), .D(instruction_final), .WriteReg(write), .Q(ID_instruction));
register_16bit PC_Reg(.clk(clk), .rst(rst), .D(PC_plus_two), .WriteReg(write), .Q(ID_PC_plus_two));

endmodule

//////////////////////////////////////////////////////////////////////////////////////////////

module ID_EX_reg(clk, rst, write, ID_PC_plus_two, ID_instruction, src_data1, src_data2, extended_immediate
				PC_branchi, ALU_OP, IMM, cc, FlagWrite, BRANCH, BR, RegWrite, MemWrite, MemRead, 
				EX_PC_plus_two, EX_src_data1, EX_src_data2, EX_extended_immediate, EX_PC_branchi,
				EX_ALU_OP, EX_Rs, EX_Rt, EX_dstReg, EX_IMM, EX_cc, EX_FlagWrite, EX_BRANCH, EX_BR,
				EX_RegWrite, EX_MemWrite, EX_MemRead);

input clk, rst, write;
input [15:0] ID_PC_plus_two;
input [15:0] ID_instruction;
input [15:0] src_data1, src_data2;
input [15:0] extended_immediate;
input [15:0] PC_branchi;
input [3:0] ALU_OP;
input IMM, cc, FlagWrite, BRANCH, BR, RegWrite, MemWrite, MemRead;

output [15:0] EX_PC_plus_two;
output [15:0] EX_src_data1, EX_src_data2;
output [15:0] EX_extended_immediate;
output [15:0] EX_PC_branchi;
output [3:0] EX_ALU_OP;
output [3:0] EX_Rs, EX_Rt;
output [3:0] EX_dstReg;
output EX_IMM, EX_cc, EX_FlagWrite, EX_BRANCH, EX_BR, EX_RegWrite, EX_MemWrite, EX_MemRead;

// Internal signals
wire [15:0] inst_out;
wire [15:0] misc_in, misc_out;

// Assign misc signals
assign misc_in = {4'h0, ALU_OP[3:0], IMM, cc, FlagWrite, BRANCH, BR, RegWrite, MemWrite, MemRead};

assign EX_MemRead = misc_in[0];
assign EX_MemWrite = misc_in[1];
assign EX_RegWrite = misc_in[2];
assign EX_BR = misc_in[3];
assign EX_BRANCH = misc_in[4];
assign EX_FlagWrite = misc_in[5];
assign EX_cc = misc_in[6];
assign EX_IMM = misc_in[7];
assign EX_ALU_OP[3:0] = misc_in[[11:8];

// Assign address-based outputs
assign EX_dstReg[3:0] = inst_out[11:8];
assign EX_Rs[3:0] = inst_out[7:4];
assign EX_Rt[3:0] = inst_out[3:0];

// Instantiate registers for pipelining signals
register_16bit PC_Reg(.clk(clk), .rst(rst), .D(ID_PC_plus_two), .WriteReg(write), .Q(EX_PC_plus_two));
register_16bit Inst_Reg(.clk(clk), .rst(rst), .D(ID_instruction), .WriteReg(write), .Q(inst_out));
register_16bit Src_Data1_Reg(.clk(clk), .rst(rst), .D(src_data1), .WriteReg(write), .Q(EX_src_data1));
register_16bit Src_Data2_Reg(.clk(clk), .rst(rst), .D(src_data2), .WriteReg(write), .Q(EX_src_data2));
register_16bit Extended_Immediate_Reg(.clk(clk), .rst(rst), .D(extended_immediate), .WriteReg(write), .Q(EX_extended_immediate));
register_16bit PC__Branchi_Reg(.clk(clk), .rst(rst), .D(PC_branchi), .WriteReg(write), .Q(EX_PC_branchi));
register_16bit misc_Reg(.clk(clk), .rst(rst), .D(misc_in), .WriteReg(write), .Q(misc_out));

endmodule

//////////////////////////////////////////////////////////////////////////////////////////////

module EX_MEM_reg(clk, rst, write, ALU_result, EX_PC_plus_two, data_write, EX_dstReg, EX_RegWrite,
		EX_MemWrite, EX_MemRead, MEM_ALU_result, MEM_PC_plus_two, MEM_data_write, MEM_Rd,
		MEM_RegWrite, MEM_MemWrite, MEM_MemRead);

input clk, rst, write;
input [15:0] ALU_result;
input [15:0] EX_PC_plus_two;
input [15:0] data_write;
input [3:0] EX_dstReg;
input EX_RegWrite, EX_MemWrite, EX_MemRead;

output [15:0] MEM_ALU_result;
output [15:0] MEM_PC_plus_two;
output [15:0] MEM_data_write;
output [3:0] MEM_Rd;
output MEM_RegWrite, MEM_MemWrite, MEM_MemRead;

// Internal signals
wire[15:0] misc_in, misc_out;

assign misc_in = {8'h00, EX_dstReg, 1'h0, EX_RegWrite, EX_MemWrite, EX_MemRead};

assign MEM_MemRead = misc_out[0];
assign MEM_MemWrite = misc_out[1];
assign MEM_RegWrite = misc_out[2];
assign MEM_Rd = misc_out[7:4];

// Instantiate registers for pipelining signals
register_16bit ALU_Reg(.clk(clk), .rst(rst), .D(ALU_result), .WriteReg(write), .Q(MEM_ALU_result));
register_16bit Data_Write_Reg(.clk(clk), .rst(rst), .D(data_write), .WriteReg(write), .Q(MEM_data_write));
register_16bit PC_Reg(.clk(clk), .rst(rst), .D(EX_PC_plus_two), .WriteReg(write), .Q(MEM_PC_plus_two));
register_16bit Misc_Reg(.clk(clk), .rst(rst), .D(misc_in), .WriteReg(write), .Q(misc_out));
endmodule

//////////////////////////////////////////////////////////////////////////////////////////////

module MEM_WB_reg(clk, rst, write, MEM_ALU_result, data_out, MEM_PC_plus_two, MEM_Rd, MEM_RegWrite, 
		WB_ALU_result, WB_data_out, WB_PC_plus_two, WB_Rd, WB_RegWrite);

input clk, rst, write;
input [15:0] MEM_ALU_result;
input [15:0] data_out;
input [15:0] MEM_PC_plus_two;
input [3:0] MEM_Rd;
input MEM_RegWrite;

output [15:0] WB_ALU_result;
output [15:0] WB_data_out;
output [15:0] WB_PC_plus_two;
output [3:0] WB_Rd;
output WB_RegWrite;

// Internal signals
wire [15:0] misc_in, misc_out;

assign misc_in = {11'h000,MEM_Rd,MEM_RegWrite};

assign WB_RegWrite = misc_out[0];
assign WB_Rd = misc_out[4:1];

// Instantiate registers for pipelining signals
register_16bit ALU_Reg(.clk(clk), .rst(rst), .D(MEM_ALU_result), .WriteReg(write), .Q(WB_ALU_result));
register_16bit Mem_Reg(.clk(clk), .rst(rst), .D(data_out), .WriteReg(write), .Q(WB_data_out));
register_16bit PC_Reg(.clk(clk), .rst(rst), .D(MEM_PC_plus_two), .WriteReg(write), .Q(WB_PC_plus_two));
register_16bit Misc_Reg(.clk(clk), .rst(rst), .D(misc_in), .WriteReg(write), .Q(misc_out));
endmodule





