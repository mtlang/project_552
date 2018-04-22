module i_cache_tb ();
reg clk, rst, Write_Enable;
reg [15:0] Address, Data_In;
wire [15:0] Data_Out;
wire Miss;

i_cache DUT (.clk(clk), .rst(rst), .Address(Address), .Data_In(Data_In), .Data_Out(Data_Out), .Write_Enable(Write_Enable), .Miss(Miss));

initial begin

clk = 0;
rst = 0;
Write_Enable = 0;
Address = 16'h0000;
Data_In = 16'h0000;

#10;
rst = 1;

#10;
Write_Enable = 1;
Address = 16'h0812;
Data_In = 16'hffff;

#10;
Write_Enable = 0;
Address = 16'h0812;
Data_In = 16'hxxxx;

#10;
$stop();

end


always
	#5 clk = ~clk;


endmodule
