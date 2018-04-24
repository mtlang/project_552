module cache_tb ();
reg clk, rst, Write_Enable;
reg [15:0] Address, Data_In;
wire [15:0] Data_Out;
wire Miss;
integer i;

cache DUT (.clk(clk), .rst(rst), .Address(Address), .Data_In(Data_In), .Data_Out(Data_Out), .Write_Enable(Write_Enable), .Miss(Miss));

initial begin
i=0;
clk = 0;
rst = 1;
Write_Enable = 0;
Address = 16'h0000;
Data_In = 16'h0000;
#10;

rst = 0;
#10;

//Write stuff to cache
Address = 16'h1811;
for(i=0; i<10; i=i+1) begin
	Data_In = Data_In + 1;
	Address = Address + 1;
	Write_Enable = 1;
	#10;
end

Address = 16'h1901; 
for(i=0; i<10; i=i+1) begin
	Data_In = Data_In +1;
	Address = Address + 1;
	Write_Enable = 1;
	#10;
end

//Read stuff from cache
Address = 16'h1811;
for(i=0; i<10; i=i+1) begin
	Address = Address + 1;
	Write_Enable = 0;
	#10;
end

Address = 16'h1901; 
for(i=0; i<10; i=i+1) begin
	Address = Address + 1;
	Write_Enable = 0;
	#10;
end
Address = 16'h1001; //Only one of these reads should result in a non-Miss
for(i=0; i<20; i=i+1) begin
	Address = Address + 129;
	Write_Enable = 0;
	#10;
end
#10;

$stop();

end

always
	#5 clk = ~clk;


endmodule
