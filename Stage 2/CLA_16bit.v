module CLA_16bit (A, B, Sum, Cout);
input [15:0] A, B;
output [15:0] Sum;
output Cout;

wire [3:0] c;
wire [15:0] x;

CLA_4bit cla0 (.A(A[3:0]), .B(B[3:0]), .Sum(x[3:0]), .Cout(c[0]), .Cin(1'b0));
CLA_4bit cla1 (.A(A[7:4]), .B(B[7:4]), .Sum(x[7:4]), .Cout(c[1]), .Cin(c[0]));
CLA_4bit cla2 (.A(A[11:8]), .B(B[11:8]), .Sum(x[11:8]), .Cout(c[2]), .Cin(c[1]));
CLA_4bit cla3 (.A(A[15:12]), .B(B[15:12]), .Sum(x[15:12]), .Cout(c[3]), .Cin(c[2]));

//saturating logic
//If the sum of two positive numbers yields a negative result, the sum has overflowed.
//If the sum of two negative numbers yields a positive result, the sum has overflowed.
//Otherwise, the sum has not overflowed.

assign Sum = (~A[15] & ~B[15] & x[15]) ? 16'h7fff : 
		(A[15] & B[15] & ~x[15]) ? 16'h8000 : x;

endmodule
