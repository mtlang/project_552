module decoder_3_8_tb ();
reg [2:0] a;
wire [7:0] result;
integer i;

decoder_3_8 DUT (.A(a), .B(result));

initial begin
for (i=0; i<8; i=i+1) begin
a = i;
#10;
end
$stop;
end


endmodule
