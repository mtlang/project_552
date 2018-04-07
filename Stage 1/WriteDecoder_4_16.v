module WriteDecoder_4_16(RegId, WriteReg, Wordline);

input [3:0] RegId;
input WriteReg;

output [15:0] Wordline;

// Internal Signals
wire [3:0] not_reg;

// Same as read decoder, but set bit is determined by value of WriteReg

assign not_reg = ~RegId;

assign Wordline[0] = not_reg[0] & not_reg[1] & not_reg[2] & not_reg[3] & WriteReg;
assign Wordline[1] = RegId[0] & not_reg[1] & not_reg[2] & not_reg[3] & WriteReg;
assign Wordline[2] = not_reg[0] & RegId[1] & not_reg[2] & not_reg[3] & WriteReg;
assign Wordline[3] = RegId[0] & RegId[1] & not_reg[2] & not_reg[3] & WriteReg;
assign Wordline[4] = not_reg[0] & not_reg[1] & RegId[2] & not_reg[3] & WriteReg;
assign Wordline[5] = RegId[0] & not_reg[1] & RegId[2] & not_reg[3] & WriteReg;
assign Wordline[6] = not_reg[0] & RegId[1] & RegId[2] & not_reg[3] & WriteReg;
assign Wordline[7] = RegId[0] & RegId[1] & RegId[2] & not_reg[3] & WriteReg;
assign Wordline[8] = not_reg[0] & not_reg[1] & not_reg[2] & RegId[3] & WriteReg;
assign Wordline[9] = RegId[0] & not_reg[1] & not_reg[2] & RegId[3] & WriteReg;
assign Wordline[10] = not_reg[0] & RegId[1] & not_reg[2] & RegId[3] & WriteReg;
assign Wordline[11] = RegId[0] & RegId[1] & not_reg[2] & RegId[3] & WriteReg;
assign Wordline[12] = not_reg[0] & not_reg[1] & RegId[2] & RegId[3] & WriteReg;
assign Wordline[13] = RegId[0] & not_reg[1] & RegId[2] & RegId[3] & WriteReg;
assign Wordline[14] = not_reg[0] & RegId[1] & RegId[2] & RegId[3] & WriteReg;
assign Wordline[15] = RegId[0] & RegId[1] & RegId[2] & RegId[3] & WriteReg;		  
		  
endmodule
