module IF_ID_reg(clk, rst, write, PC_plus_two, instruction, ID_PC_plus_two, ID_instruction);

// TODO determine all inputs/outputs for this pipeline register

// flush here?
input clk, rst, write;
input [15:0] PC_plus_two;
input [15:0] instruction;

output [15:0] ID_PC_plus_two;
output [15:0] ID_instruction;

// Internal signals


// Instantiate registers for pipelining signals
register_16bit Inst_Reg(.clk(clk), .rst(rst), .D(instruction), .WriteReg(write), .Q(ID_instruction));
register_16bit PC_Reg(.clk(clk), .rst(rst), .D(PC_plus_two), .WriteReg(write), .Q(ID_PC_plus_two));

endmodule

//////////////////////////////////////////////////////////////////////////////////////////////

module ID_EX_reg(clk, rst, write, extended_immediate, cc, src_data1, src_data2, dstReg, 
				EX_extended_immediate, EX_src_data1, EX_src_data2, EX_dstReg, EX_cc);

// TODO Add control signals to inputs/outputs
// TODO determine all inputs/outputs for this pipeline register

input clk, rst, write;
input [2:0] cc;
input [3:0] dstReg;
input [15:0] extended_immediate;
input [15:0] src_data1;
input [15:0] src_data2;

output [2:0] EX_cc;
output [3:0] EX_dstReg;
output [15:0] EX_extended_immediate;
output [15:0] EX_src_data1;
output [15:0] EX_src_data2;

// Internal signals


// Instantiate registers for pipelining signals

endmodule

//////////////////////////////////////////////////////////////////////////////////////////////

module EX_MEM_reg(clk, rst, write);

input clk, rst, write;

// Internal signals


// Instantiate registers for pipelining signals

endmodule

//////////////////////////////////////////////////////////////////////////////////////////////

module MEM_WB_reg(clk, rst, write);

input clk, rst, write;

// Internal signals


// Instantiate registers for pipelining signals

endmodule





