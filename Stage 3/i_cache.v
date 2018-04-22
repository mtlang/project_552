//Direct-mapped cache; 128 cache blocks
//Block # = (block address) % 128
//Above can be calculated by taking the low order 8 bits of address as block #
//The tag bits are the rest of the address not used for the index
//Word select bits are 3 least significant bits of the index
// i.e. index = address[7:0]
//      tag   = address[15:8]
//      word  = address[2:0]
module i_cache (clk, rst, Address, Data_In, Data_Out, Write_Enable, Miss);
input clk, rst, Write_Enable;
input [15:0] Address, Data_In;

output Miss;
output [15:0] Data_Out;

wire [2:0] word;
wire [7:0] tag_mda, tag, blk_index, word_en;
wire [127:0] block_en;

//7:128 decoder gives block_en a one hot vector
//input is block index
Decoder_7_128 dec_7_128(.tag(blk_index), .block(block_en));

decoder_3_8 dec_3_8(.A(word), .B(word_en));

MetaDataArray MDA (.clk(clk), .rst(rst), .DataIn(tag), .Write(Write_Enable), .BlockEnable(block_en), .DataOut(tag_mda));

DataArray DA (.clk(clk), .rst(rst), .DataIn(Data_In), .Write(Write_Enable), .BlockEnable(block_en), .WordEnable(word_en), .DataOut(Data_Out));	

//computed tag value based on address
//first bit is valid bit
assign tag = {1'b1,Address[14:8]};

//computed block index based on address
assign blk_index = Address[7:0];

assign Miss = (~Write_Enable) ? (tag == tag_mda) : 1'b0;

endmodule
