// Alex Moy
module addsub_4bit(Sum, Ovfl, A, B, sub);

input [3:0] A, B;	// inputs
input sub;		// 1 if subtraction

output [3:0] Sum;	// result of operation
output Ovfl;		// indicates overflow

// Local params
wire c0, c1, c2, c3;	// carry outs for each adder
wire b0, b1, b2, b3;	// for xor'd result of B and sub

// Start Implementation

// xor of B and sub -> B if add, ~B if subtract
assign b0 = B[0] ^ sub;
assign b1 = B[1] ^ sub;
assign b2 = B[2] ^ sub;
assign b3 = B[3] ^ sub;

// Detection of overflow
assign Ovfl = c3 ^ c2;

// use sub as cin for first adder, will be 1 for two's compliment of b if subbing
full_adder_1bit FA1 (A[0], b0, sub, Sum[0], c0);
full_adder_1bit FA2 (A[1], b1, c0, Sum[1], c1);
full_adder_1bit FA3 (A[2], b2, c1, Sum[2], c2);
full_adder_1bit FA4 (A[3], b3, c2, Sum[3], c3);

endmodule
