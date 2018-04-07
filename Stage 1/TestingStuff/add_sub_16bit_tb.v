module add_sub_16bit_tb ();
reg [15:0] a, b;
reg sub;
wire [15:0] sum;
wire cout;
integer i,j,k;

add_sub_16bit DUT (.A(a), .B(b), .Sub(sub), .Sum(sum), .Cout(cout));

initial begin
sub=0;
for(i=0; i<128; i=i+1) begin
for(j=0; j<128; j=j+1) begin
k=0;
a=$random();
b=$random();
#10;
if(a + b != sum) begin
k=1;
end
end
end

sub=1;
for(i=0; i<128; i=i+1) begin
for(j=0; j<128; j=j+1) begin
k=0;
a=$random();
b=$random();
#10;
if(a - b != sum) begin
k=1;
end
end
end
end

initial begin
if( k>0) $display("error");
end

endmodule
