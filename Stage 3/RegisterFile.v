module RegisterFile(clk, rst, SrcReg1, SrcReg2, DstReg, WriteReg, DstData, SrcData1, SrcData2);

input clk, rst, WriteReg;
input [3:0] SrcReg1, SrcReg2, DstReg;
input [15:0] DstData;

inout [15:0] SrcData1, SrcData2;

// Internal signals
wire [15:0] write_en, read_en1, read_en2;

////////////////////////////////////////////////////////////////////////////////////////
// Instantiate two ReadDecoders and one WriteDecoder
////////////////////////////////////////////////////////////////////////////////////////
ReadDecoder_4_16 RDec1(.RegId(SrcReg1), .Wordline(read_en1));
ReadDecoder_4_16 RDec2(.RegId(SrcReg2), .Wordline(read_en2));

WriteDecoder_4_16 WDec(.RegId(DstReg), .WriteReg(WriteReg), .Wordline(write_en));
////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////
// Instantiate 16 Registers
////////////////////////////////////////////////////////////////////////////////////////
Register R0(.clk(clk), .rst(rst), .D(16'h0000), .WriteReg(write_en[0]), .ReadEnable1(read_en1[0]), 
		.ReadEnable2(read_en2[0]), .Bitline1(SrcData1), .Bitline2(SrcData2));
// Hardwire to 0

Register R1(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_en[1]), .ReadEnable1(read_en1[1]), 
		.ReadEnable2(read_en2[1]), .Bitline1(SrcData1), .Bitline2(SrcData2));

Register R2(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_en[2]), .ReadEnable1(read_en1[2]), 
		.ReadEnable2(read_en2[2]), .Bitline1(SrcData1), .Bitline2(SrcData2));

Register R3(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_en[3]), .ReadEnable1(read_en1[3]), 
		.ReadEnable2(read_en2[3]), .Bitline1(SrcData1), .Bitline2(SrcData2));

Register R4(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_en[4]), .ReadEnable1(read_en1[4]), 
		.ReadEnable2(read_en2[4]), .Bitline1(SrcData1), .Bitline2(SrcData2));

Register R5(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_en[5]), .ReadEnable1(read_en1[5]),
		.ReadEnable2(read_en2[5]), .Bitline1(SrcData1), .Bitline2(SrcData2));

Register R6(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_en[6]), .ReadEnable1(read_en1[6]), 
		.ReadEnable2(read_en2[6]), .Bitline1(SrcData1), .Bitline2(SrcData2));

Register R7(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_en[7]), .ReadEnable1(read_en1[7]),
		.ReadEnable2(read_en2[7]), .Bitline1(SrcData1), .Bitline2(SrcData2));

Register R8(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_en[8]), .ReadEnable1(read_en1[8]), 
		.ReadEnable2(read_en2[8]), .Bitline1(SrcData1), .Bitline2(SrcData2));

Register R9(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_en[9]), .ReadEnable1(read_en1[9]), 
		.ReadEnable2(read_en2[9]), .Bitline1(SrcData1), .Bitline2(SrcData2));

Register R10(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_en[10]), .ReadEnable1(read_en1[10]), 
		.ReadEnable2(read_en2[10]), .Bitline1(SrcData1), .Bitline2(SrcData2));

Register R11(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_en[11]), .ReadEnable1(read_en1[11]), 
		.ReadEnable2(read_en2[11]), .Bitline1(SrcData1), .Bitline2(SrcData2));

Register R12(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_en[12]), .ReadEnable1(read_en1[12]), 
		.ReadEnable2(read_en2[12]), .Bitline1(SrcData1), .Bitline2(SrcData2));

Register R13(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_en[13]), .ReadEnable1(read_en1[13]), 
		.ReadEnable2(read_en2[13]), .Bitline1(SrcData1), .Bitline2(SrcData2));

Register R14(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_en[14]), .ReadEnable1(read_en1[14]), 
		.ReadEnable2(read_en2[14]), .Bitline1(SrcData1), .Bitline2(SrcData2));

Register R15(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_en[15]), .ReadEnable1(read_en1[15]), 
		.ReadEnable2(read_en2[15]), .Bitline1(SrcData1), .Bitline2(SrcData2));
////////////////////////////////////////////////////////////////////////////////////////


endmodule
