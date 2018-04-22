module i_cache_tb ();
reg clk, rst, Write_Enable;
reg [15:0] Address, Data_In;
wire [15:0] Data_Out;
wire Miss;

i_cache DUT (.clk(clk), .rst(rst), .Address(Address), .Data_In(Data_In), .Data_Out(Data_Out), .Write_Enable(Write_Enable), .Miss(Miss));

//initial begin
//
//clk = 0;
//rst = 1;
//Write_Enable = 0;
//Address = 16'h0000;
//Data_In = 16'h0000;
//
//#10;
//rst = 0;
//
////Write to memory location 0x0812
//#10;
//Data_In = 16'hffff;
//Write_Enable = 1;
//Address = 16'h0812;
//
////Read from 0x0812
//#10;
//Write_Enable = 0;
//Address = 16'h0812;
//Data_In = 16'hxxxx;
//#40;
//
////Write to location 0x0912
//Data_In = 16'h0fff;
//Write_Enable = 1;
//Address = 16'h0912;
//
////Read from 0x0912
//#10;
//Write_Enable = 0;
//Address = 16'h0912;
//Data_In = 16'hxxxx;
//#40
//
//$stop();
//
//end

initial begin
clk = 0;
rst = 1;
Write_Enable = 0;
Address = 16'h0000;
Data_In = 16'h0000;
#10;

rst = 0;
#10;

//Write stuff to cache
Data_In = Data_In + 1;
Address = 16'h1812;
Write_Enable = 1;
#10;
Data_In = Data_In +1;
Address = 16'h1913;
#10;

//Read stuff from cache
Address = 16'h1812;
Write_Enable = 0;
#40;
Address = 16'h0413; //This should result in tag mismatch aka miss
#40;
Address = 16'h1913;
#40;

$stop();

end

always
	#5 clk = ~clk;


endmodule
