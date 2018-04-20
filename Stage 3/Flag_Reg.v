module Flag_Reg(clk, rst, D, WriteReg, Q);

input clk, rst, WriteReg;
input [2:0] D;

output [2:0] Q;

// Assumption: F = [Z, V, N] = [Zero, Overflow, Negative]

// Instantiate 3 FFs to hold values in reg
dff FF0(.q(Q[0]), .d(D[0]), .wen(WriteReg), .clk(clk), .rst(rst));
dff FF1(.q(Q[1]), .d(D[1]), .wen(WriteReg), .clk(clk), .rst(rst));
dff FF2(.q(Q[2]), .d(D[2]), .wen(WriteReg), .clk(clk), .rst(rst));

endmodule