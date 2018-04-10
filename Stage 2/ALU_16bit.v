module ALU_16bit(ALU_OP, SrcData1, SrcData2, Flags, Result, rst);

input rst;
input [3:0] ALU_OP;
input [15:0] SrcData1;		// Source data 1, comes from Read Data 1 or a 16-bit immediate value
input [15:0] SrcData2;		// Source data 2, comes from Read Data 2

output [2:0] Flags;		// New values for Flag Register
output [15:0] Result;		// Result of ALU operation

//////////////////////
// Internal Signals //
//////////////////////
wire [15:0] sum_16b, paddsb, shift_out, mem_addr, offset, reg_mask;
wire [15:0] xor_result, llb_shift, llb_shift_in, llb_result, lhb_result;
wire [6:0] red;
reg [15:0] alu_out;
reg [2:0] flags_out;


//////////////////////
// ADD/SUB & PADDSB //
//////////////////////
add_sub_16bit ADD_SUB (.A(SrcData1), .B(SrcData2), .Sub(ALU_OP[1]), .Sum(sum_16b), .Ovflw(Flags[1]));
PADDSB_16bit PADDSB (.A(SrcData1), .B(SrcData2), .Result(paddsb));

/////////
// RED //
/////////
// Result of RED is 7 bits
reduction_unit_16bit RED (.rs(SrcData1), .rt(SrcData2), .rd(red));

/////////////////////
// SLL & SRA & ROR //
/////////////////////
// Shifter, assumes SrcData1 contains 4 bit immediate for shift value
// assumes SrcData2 contains data to shift
// Mode is ALU_OP[1:0] = 00 -> SLL, 01 -> SRA, 10 -> ROR
Shifter SHIFT (.Shift_Out(shift_out), .Shift_In(SrcData2), .Shift_Val(SrcData1[3:0]), .Mode(ALU_OP[1:0]));

/////////////
// LW & SW //
/////////////
// Assumes SrcData1 contains immediate offset oooo
// Assumes SrcData2 contains register data rs
Shifter SHIFT2 (.Shift_Out(offset), .Shift_In({12'h000, SrcData1[3:0]}), .Shift_Val(4'h1), .Mode(2'b00)); // oooo<<1
assign reg_mask = (SrcData2 & 16'hfffe);
add_sub_16bit MEM_ADDR (.A(reg_mask), .B(offset), .Sub(1'b0), .Sum(mem_addr), .Ovflw());

///////////////
// LLB & LHB //
///////////////
// Assumes SrcData1[7:0] contains 8 bit immediate value uuuuuuuu
// Assumes SrcData2 contains destination register
assign llb_shift_in = {8'h00,SrcData1[7:0]};
Shifter SHIFT3 (.Shift_Out(llb_shift), .Shift_In(llb_shift_in), .Shift_Val(4'h8), .Mode(2'b00)); // uuuuuuuu<<8
assign lhb_result = (SrcData2 & 16'h00ff) | llb_shift; //(Reg[dddd]&0x00FF) | (uuuuuuuu<<8)
assign llb_result = (SrcData2 & 16'hff00) | ({8'h00,SrcData1[7:0]}); //(Reg[dddd]&0xFF00) | uuuuuuuu

/////////
// XOR //
/////////
assign xor_result = SrcData1 ^ SrcData2;

/////////////////////////
// Combinational Logic //
/////////////////////////
// Flags = [Z, V, N] Z is zero, V is overflow, N is signed
always @(*) begin

case (ALU_OP)

	// RED
	4'b0000 : begin
		assign alu_out = {{9{red[6]}},red};
		assign flags_out = Flags;
	end

	// SLL
	4'b0001: begin
		assign alu_out = shift_out;
		assign flags_out = |shift_out ? {1'b0,Flags[1],Flags[0]} : {1'b1,Flags[1],Flags[0]};
	end
	
	// SRA
	4'b0010: begin
		assign alu_out = shift_out;
		assign flags_out = |shift_out ? {1'b0,Flags[1],Flags[0]} : {1'b1,Flags[1],Flags[0]};
	end
	
	// ROR
	4'b0100: begin
		assign alu_out = shift_out;
		assign flags_out = |shift_out ? {1'b0,Flags[1],Flags[0]} : {1'b1,Flags[1],Flags[0]};
	end

	// PADDSB
	4'b0011 : begin
		assign alu_out = paddsb;
		assign flags_out = Flags;
	end

	// LW
	4'b0101: begin
		assign alu_out = mem_addr;
		assign flags_out = Flags;
	end
	
	// SW
	4'b0110 : begin
		assign alu_out = mem_addr;
		assign flags_out = Flags;
	end

	// LHB
	4'b0111 : begin
		assign alu_out = lhb_result;
		assign flags_out = Flags;
	end

	// LLB
	4'b1000 : begin
		assign alu_out = llb_result;
		assign flags_out = Flags;
	end
	
	// ADD
	4'b1001: begin
		assign alu_out = sum_16b;
		assign flags_out = |sum_16b ? {1'b0,Flags[1],Flags[0]} : {1'b1,Flags[1],Flags[0]};
		// Flags[1] set by Ovflw signal in module
	end
	
	// SUB
	4'b1010 : begin
		assign alu_out = sum_16b;
		assign flags_out = |sum_16b ? {1'b0,Flags[1],Flags[0]} : {1'b1,Flags[1],Flags[0]};
		// Flags[1] set by Ovflw signal in module
	end

	// XOR
	4'b1011 : begin
		assign alu_out = xor_result;
		assign flags_out = |xor_result ? {1'b0,Flags[1],Flags[0]} : {1'b1,Flags[1],Flags[0]};
	end

	default : begin
		assign alu_out = 16'h0000;
		assign flags_out = Flags;
	end

endcase

end

assign Result = alu_out;
assign Flags = (rst) ? 3'h0 : flags_out;

endmodule
