module CLA_16bit_tb ();
reg [15:0] a, b;
wire [15:0] out;
wire cout;
integer i, j, k;

CLA_16bit DUT (.A(a), .B(b), .Sum(out), .Cout(cout));

initial begin

for(i=0; i<512; i=i+1) begin
for(j=0; j<512; j=j+1) begin
k=0;
a=i;
b=j;
#10;
if(a + b != out) begin
k=1;
end
end
end
end

initial begin
if( k>0) $monitor("error");
end
//initial $monitor("A=%d\tB=%d\nSum=%d\tCout=%b",a,b,out,cout);

endmodule
