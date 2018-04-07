module PADDSB_16bit (A, B, Result);
input [15:0] A, B;
output [15:0] Result;

wire [3:0] c;
wire [15:0] s;

// Parallel Add Scheme //

CLA_4bit cla0 (.A(A[3:0]), .B(B[3:0]), .Sum(s[3:0]), .Cout(c[0]), .Cin(1'b0));
CLA_4bit cla1 (.A(A[7:4]), .B(B[7:4]), .Sum(s[7:4]), .Cout(c[1]), .Cin(1'b0));
CLA_4bit cla2 (.A(A[11:8]), .B(B[11:8]), .Sum(s[11:8]), .Cout(c[2]), .Cin(1'b0));
CLA_4bit cla3 (.A(A[15:12]), .B(B[15:12]), .Sum(s[15:12]), .Cout(c[3]), .Cin(1'b0));


// Saturation Logic //

assign Result[3:0] = (~A[3] & ~B[3] & s[3]) ? 4'b0111 : 
		(A[3] & B[3] & ~s[3]) ? 4'b1000 : s[3:0];

assign Result[7:4] = (~A[7] & ~B[7] & s[7]) ? 4'b0111 : 
		(A[7] & B[7] & ~s[7]) ? 4'b1000 : s[7:4];

assign Result[11:8] = (~A[11] & ~B[11] & s[11]) ? 4'b0111 : 
		(A[11] & B[11] & ~s[11]) ? 4'b1000 : s[11:8];

assign Result[15:12] = (~A[15] & ~B[15] & s[15]) ? 4'b0111 : 
		(A[15] & B[15] & ~s[15]) ? 4'b1000 : s[15:12];

endmodule
