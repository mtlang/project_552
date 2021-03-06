//Direct-mapped cache; 128 cache blocks
//Block # = (block address) % 128
//Above can be calculated by taking the low order 8 bits of address as block #
//The tag bits are the rest of the address not used for the index
//Word select bits are 3 least significant bits of the index
// i.e. index = address[7:0]
//      tag   = address[15:8]
//      word  = address[2:0]
module cache (clk, rst, Address, Data_In, Data_Out, Write_Data_Array, Write_Tag_Array, Read_Enable, Miss, Word_Num);
input clk, rst;
input Write_Data_Array, Write_Tag_Array;
input Read_Enable;
input [2:0] Word_Num;
input [15:0] Address, Data_In;

output Miss;
output [15:0] Data_Out;

////Internal signals////
wire [2:0] word;
wire [7:0] tag_mda, tag; 
wire [7:0] word_line_rd, word_line_wrt, word_en;
wire [7:0] junk;
wire [6:0] blk_index;
wire [15:0] cache_data;
wire [127:0] block_en;
////////////////////////

//Decoder modules for one hot block enable and word enable
Decoder_7_128 dec_7_128(.tag(blk_index), .block(block_en));
decoder_3_8 dec_3_8(.A(word), .B(word_line_rd));

//Shifter for shifting word enable on multi-byte writes
Shifter shifter(.Shift_Out({junk, word_line_wrt}), .Shift_In(16'h0001), .Shift_Val({1'b0,Word_Num}), .Mode(2'b00));

//Meta data array (Valid + tag bits)
MetaDataArray MDA (.clk(clk), .rst(rst), .DataIn(tag), .Write(Write_Tag_Array), .BlockEnable(block_en), .DataOut(tag_mda));

//Data array (cache lines)
DataArray DA (.clk(clk), .rst(rst), .DataIn(Data_In), .Write(Write_Data_Array), .BlockEnable(block_en), .WordEnable(word_en), .DataOut(cache_data));	

//first bit is valid bit in tag
assign tag = {1'b1,Address[14:8]};
//assign blk_index = Address[6:0];
assign blk_index = {Address[8:4],1'b0};
assign word = Address[3:1];

//word enable assigned the specific word if a read
//on writes word enable is assigned the one-hot shifted word
assign word_en = (Write_Data_Array) ? word_line_wrt : word_line_rd;

assign Miss = (Read_Enable) ? !(tag === tag_mda) : 1'b0;
assign Data_Out = (Read_Enable) ? cache_data : 16'hxxxx;

endmodule
