module addsub_16bit(Sum, Ovfl, A, B, sub);

input [15:0] A, B;
input sub;

output [15:0] Sum;
output Ovfl;

// local params
wire [15:0] cout;
wire [15:0] b;

// xor B and sub -> B if add, ~B if subtract
assign b = B ^ {16{sub}};

// Overflow detection
assign Ovfl = cout[15] ^ cout[14]; //TODO check if correct

// Use 12 FAs to compute sum
full_adder_1bit FA0(.A(A[0]), .B(b[0]), .Cin(sub), .S(Sum[0]), .Cout(cout[0]));
full_adder_1bit FA1(.A(A[1]), .B(b[1]), .Cin(cout[0]), .S(Sum[1]), .Cout(cout[1]));
full_adder_1bit FA2(.A(A[2]), .B(b[2]), .Cin(cout[1]), .S(Sum[2]), .Cout(cout[2]));
full_adder_1bit FA3(.A(A[3]), .B(b[3]), .Cin(cout[2]), .S(Sum[3]), .Cout(cout[3]));
full_adder_1bit FA4(.A(A[4]), .B(b[4]), .Cin(cout[3]), .S(Sum[4]), .Cout(cout[4]));
full_adder_1bit FA5(.A(A[5]), .B(b[5]), .Cin(cout[4]), .S(Sum[5]), .Cout(cout[5]));
full_adder_1bit FA6(.A(A[6]), .B(b[6]), .Cin(cout[5]), .S(Sum[6]), .Cout(cout[6]));
full_adder_1bit FA7(.A(A[7]), .B(b[7]), .Cin(cout[6]), .S(Sum[7]), .Cout(cout[7]));
full_adder_1bit FA8(.A(A[8]), .B(b[8]), .Cin(cout[7]), .S(Sum[8]), .Cout(cout[8]));
full_adder_1bit FA9(.A(A[9]), .B(b[9]), .Cin(cout[8]), .S(Sum[9]), .Cout(cout[9]));
full_adder_1bit FA10(.A(A[10]), .B(b[10]), .Cin(cout[9]), .S(Sum[10]), .Cout(cout[10]));
full_adder_1bit FA11(.A(A[11]), .B(b[11]), .Cin(cout[10]), .S(Sum[11]), .Cout(cout[11]));
full_adder_1bit FA12(.A(A[12]), .B(b[12]), .Cin(cout[11]), .S(Sum[12]), .Cout(cout[12]));
full_adder_1bit FA13(.A(A[13]), .B(b[13]), .Cin(cout[12]), .S(Sum[13]), .Cout(cout[13]));
full_adder_1bit FA14(.A(A[14]), .B(b[14]), .Cin(cout[13]), .S(Sum[14]), .Cout(cout[14]));
full_adder_1bit FA15(.A(A[15]), .B(b[15]), .Cin(cout[14]), .S(Sum[15]), .Cout(cout[15]));

endmodule
