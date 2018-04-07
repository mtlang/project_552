module CLA_4bit_tb ();
reg [7:0] stim;
reg cin;
wire [3:0] sum;
wire cout;
integer i, j;

CLA_4bit DUT (.A(stim[3:0]), .B(stim[7:4]), .Sum(sum), .Cout(cout), .Cin(cin));

initial begin

for(i=0; i<128; i=i+1) begin
j=0;
stim = i;
cin = 0;
#10;
if(stim[3:0] + stim[7:4] != sum) begin
j=1;
end
end
end

initial begin
if( j>0) $monitor("error");
end
//initial $monitor("A=%d\tB=%d\nSum=%d\tCout=%b",stim[3:0],stim[7:4],sum,cout);

endmodule
