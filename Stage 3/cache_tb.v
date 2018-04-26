module cache_tb ();
reg clk, rst, Read_Enable, Write_Data_Array, Write_Tag_Array;
reg [2:0] Word_Num;
reg [15:0] Address, Data_In;
wire [15:0] Data_Out;
wire Miss;
integer i;

cache DUT (.clk(clk), .rst(rst), .Address(Address), .Data_In(Data_In), .Data_Out(Data_Out), .Write_Data_Array(Write_Data_Array), 
				.Write_Tag_Array(Write_Tag_Array), .Read_Enable(Read_Enable), .Miss(Miss), .Word_Num(Word_Num));

initial begin
i=0;
clk = 0;
rst = 1;
Read_Enable = 0;
Write_Data_Array = 0;
Write_Tag_Array = 0;
Word_Num = 3'h0;
Address = 16'h0000;
Data_In = 16'h0000;
#10;

rst = 0;
#10;

//Write stuff to cache
Address = 16'h1810;
for(i=0; i<8; i=i+1) begin
	Data_In = Data_In + 1;
	Write_Tag_Array = (i > 0) ? 0 : 1;
	Write_Data_Array = 1;
	Word_Num = (i > 0) ? Word_Num + 1 : 3'h0;
	#10;
	
end

Data_In = 16'h00ff;
Address = 16'h1900; 
for(i=0; i<10; i=i+1) begin
	Data_In = Data_In +1;
	Write_Tag_Array = (i > 0) ? 0 : 1;
	Write_Data_Array = 1;
	Word_Num = (i > 0) ? Word_Num + 1 : 3'h0;
	#10;
end

//Read stuff from cache
Write_Data_Array = 0;
Address = 16'h1810;
for(i=0; i<8; i=i+1) begin
	Address = (i > 0) ? Address + 1 : Address;
	Read_Enable = 1;
	#10;
end

Address = 16'h1900; 
for(i=0; i<10; i=i+1) begin
	Address = (i > 0) ? Address + 1 : Address;
	Read_Enable = 1;
	#10;
end
/*
Address = 16'h1001; //Only one of these reads should result in a non-Miss
for(i=0; i<20; i=i+1) begin
	Address = Address + 129;
	Write_Enable = 0;
	#10;
end */
#10;

$stop();

end

always
	#5 clk = ~clk;


endmodule
