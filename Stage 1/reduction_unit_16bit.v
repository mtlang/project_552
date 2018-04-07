module reduction_unit_16bit (rs, rt, rd);
input [15:0] rs, rt;
output [6:0] rd;

wire [7:1] c;
wire [3:0] x1,x2,x3,x4,y1,y2,z;
wire [2:0] d;
wire w1,w2,w3,w4,w5;

//first level of R[3:0] tree
CLA_4bit cla0 (.A(rs[3:0]), .B(rt[3:0]), .Sum(x1), .Cout(c[1]), .Cin(1'b0));
CLA_4bit cla1 (.A(rs[7:4]), .B(rt[7:4]), .Sum(x2), .Cout(c[2]), .Cin(1'b0));
CLA_4bit cla2 (.A(rs[11:8]), .B(rt[11:8]), .Sum(x3), .Cout(c[3]), .Cin(1'b0));
CLA_4bit cla3 (.A(rs[15:12]), .B(rt[15:12]), .Sum(x4), .Cout(c[4]), .Cin(1'b0));

//second level of R[3:0] tree
CLA_4bit cla4 (.A(x1), .B(x2), .Sum(y1), .Cout(c[5]), .Cin(1'b0));
CLA_4bit cla5 (.A(x3), .B(x4), .Sum(y2), .Cout(c[6]), .Cin(1'b0));

//third level of R[3:0] tree
CLA_4bit cla6 (.A(y1), .B(y2), .Sum(z), .Cout(c[7]), .Cin(1'b0));

//wallace tree for R[6:4]
full_adder_1bit csa0 (.S(w1), .Cout(w2), .A(c[1]), .B(c[2]), .Cin(c[3]));
full_adder_1bit csa1 (.S(w3), .Cout(w4), .A(c[4]), .B(c[5]), .Cin(c[6]));
full_adder_1bit csa2 (.S(d[0]), .Cout(w5), .A(w1), .B(w3), .Cin(c[7]));
full_adder_1bit csa3 (.S(d[1]), .Cout(d[2]), .A(w5), .B(w2), .Cin(w4));

assign rd = {d[2:0],z[3:0]};

endmodule
