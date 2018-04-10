module mux_3_1(out, sel, in1, in2, in3);

input [1:0] sel;
input in1, in2, in3;
output out;
wire int;

assign int = (sel[0]) ? in2 : in1;

assign out = (sel[1]) ? in3 : int;

endmodule
