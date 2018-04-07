module PC_Reg(clk, rst, D, WriteReg, Q);

input clk, rst, WriteReg;
input [15:0] D;

output [15:0] Q;

// 16 FFs to hold value
dff FF0(.q(Q[0]), .d(D[0]), .wen(WriteReg), .clk(clk), .rst(rst));
dff FF1(.q(Q[1]), .d(D[1]), .wen(WriteReg), .clk(clk), .rst(rst));
dff FF2(.q(Q[2]), .d(D[2]), .wen(WriteReg), .clk(clk), .rst(rst));
dff FF3(.q(Q[3]), .d(D[3]), .wen(WriteReg), .clk(clk), .rst(rst));
dff FF4(.q(Q[4]), .d(D[4]), .wen(WriteReg), .clk(clk), .rst(rst));
dff FF5(.q(Q[5]), .d(D[5]), .wen(WriteReg), .clk(clk), .rst(rst));
dff FF6(.q(Q[6]), .d(D[6]), .wen(WriteReg), .clk(clk), .rst(rst));
dff FF7(.q(Q[7]), .d(D[7]), .wen(WriteReg), .clk(clk), .rst(rst));
dff FF8(.q(Q[8]), .d(D[8]), .wen(WriteReg), .clk(clk), .rst(rst));
dff FF9(.q(Q[9]), .d(D[9]), .wen(WriteReg), .clk(clk), .rst(rst));
dff FF10(.q(Q[10]), .d(D[10]), .wen(WriteReg), .clk(clk), .rst(rst));
dff FF11(.q(Q[11]), .d(D[11]), .wen(WriteReg), .clk(clk), .rst(rst));
dff FF12(.q(Q[12]), .d(D[12]), .wen(WriteReg), .clk(clk), .rst(rst));
dff FF13(.q(Q[13]), .d(D[13]), .wen(WriteReg), .clk(clk), .rst(rst));
dff FF14(.q(Q[14]), .d(D[14]), .wen(WriteReg), .clk(clk), .rst(rst));
dff FF15(.q(Q[15]), .d(D[15]), .wen(WriteReg), .clk(clk), .rst(rst));

endmodule