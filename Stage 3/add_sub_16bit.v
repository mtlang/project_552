module add_sub_16bit (A, B, Sub, Sum, Ovflw);
input [15:0] A, B;
input Sub;
output [15:0] Sum;
output Ovflw;

wire [15:0] n_B, b_in;
wire c;

// USES CARRY LOOKAHEAD LOGIC

// Computes ~B+1 for subtraction
CLA_16bit cla0 (.A(~B[15:0]), .B(16'h0001), .Sum(n_B), .Cout());

// Computes A + B or A + ~B
CLA_16bit cla1 (.A(A[15:0]), .B(b_in), .Sum(Sum), .Cout(c));

// Assigns appropriate B operand for add or sub
assign b_in = Sub ? n_B : B;

//If the sum of two positive numbers yields a negative result, the sum has overflowed.
//If the sum of two negative numbers yields a positive result, the sum has overflowed.
//Otherwise, the sum has not overflowed
assign Ovflw = (~A[15] & ~b_in[15] & Sum[15]) ? 1'b1 : 
		(A[15] & b_in[15] & ~Sum[15]) ? 1'b1 : 1'b0;

endmodule
