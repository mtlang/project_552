module RegisterFile_tb();

//input clk, rst, WriteReg;
//input [3:0] SrcReg1, SrcReg2, DstReg;
//input [15:0] DstData;

//inout [15:0] SrcData1, SrcData2;

logic clk, rst, write;
logic [3:0] src_reg1, src_reg2, dst_reg;
logic [15:0] dst_data;
wire [15:0] src_data1, src_data2;

// Internal signals
int i;

// Instantiate DUT
RegisterFile iDUT(.clk(clk), .rst(rst), .WriteReg(write), .SrcReg1(src_reg1), .SrcReg2(src_reg2), 
					.DstReg(dst_reg), .DstData(dst_data), .SrcData1(src_data1), .SrcData2(src_data2));

// Start tb
initial begin
clk = 0;
rst = 1;
write = 0;
src_reg1 = 0;
src_reg2 = 0;
dst_reg = 0;
dst_data = 0;

#5;
rst = 0;
#5;

// Store values in all registers
write = 1;

for (i = 0; i < 16; i = i + 1) begin
	dst_reg = i;
	dst_data = i;
	#10;
end

dst_reg = 0;
dst_data = 0;
write = 0;
#10;

// Check read values for each register
for (i = 0; i < 16; i = i + 2) begin
	src_reg1 = 0 + i;
	src_reg2 = 1 + i;
	#10;
	if (src_data1 != (0+i))
		$display("Reg %d did not read the correct value.\nRead: %d, expected: %d", i, src_data2, i);
	if (src_data2 != (1+i))
		$display("Reg %d did not read the correct value.\nRead: %d, expected: %d", (1+i), src_data2, (1+i));
end

// Check if internal bypassing works (make more rigorous)
#10;
dst_reg = 3;
src_reg1 = 3;
src_reg2 = 2;
dst_data = 16'hab;
#10;
write = 1;
#5;
if (src_data1 != 16'hab)
	$display("Internal bypassing does not work");
#5;
write = 0;
#10;
if (src_data1 != 16'hab)
	$display("Internal bypassing does not work");

$display("End of Test Bench");
$stop();


end

always
	#5 clk = ~clk;

endmodule
