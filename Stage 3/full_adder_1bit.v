module full_adder_1bit(A, B, Cin, S, Cout);
input A, B, Cin;
output S, Cout;
wire S1, C1, C2;

// Determine S
assign S1 = A ^ B;
assign S = S1 ^ Cin;

// Determine Cout
assign C1 = Cin & S1;
assign C2 = A & B;
assign Cout = C1 | C2;

endmodule
