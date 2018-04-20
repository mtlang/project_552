module CLA_4bit (A, B, Sum, Cout, Cin);
input  [3:0] A, B;
input  Cin;
output [3:0] Sum;
output Cout;

wire [3:0] gen, prop, out;
wire [4:0] c;

//carry logic
assign c[0] = Cin;
assign c[1] = gen[0] | (prop[0] & c[0]);
assign c[2] = gen[1] | (prop[1] & c[1]);
assign c[3] = gen[2] | (prop[2] & c[2]);
assign c[4] = gen[3] | (prop[3] & c[3]);

//generate logic
assign gen[0] = A[0] & B[0];
assign gen[1] = A[1] & B[1];
assign gen[2] = A[2] & B[2];
assign gen[3] = A[3] & B[3];

//propagate logic
assign prop[0] = A[0] | B[0];
assign prop[1] = A[1] | B[1];
assign prop[2] = A[2] | B[2];
assign prop[3] = A[3] | B[3];

assign Sum = out;
assign Cout = c[4];

//full adder chain
full_adder_1bit fa0 (.S(out[0]), .Cout(), .A(A[0]), .B(B[0]), .Cin(c[0]));
full_adder_1bit fa1 (.S(out[1]), .Cout(), .A(A[1]), .B(B[1]), .Cin(c[1]));
full_adder_1bit fa2 (.S(out[2]), .Cout(), .A(A[2]), .B(B[2]), .Cin(c[2]));
full_adder_1bit fa3 (.S(out[3]), .Cout(), .A(A[3]), .B(B[3]), .Cin(c[3]));

endmodule //carry look ahead 4 bit adder