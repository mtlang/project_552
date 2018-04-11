module mux_3_1(out, sel, in1, in2, in3);

input [1:0] sel;
input [15:0] in1, in2, in3;
output [15:0] out;
wire [15:0] inter;

assign inter = (sel[0]) ? in2 : in1;

assign out = (sel[1]) ? in3 : inter;

endmodule
