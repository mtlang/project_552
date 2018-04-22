module decoder_3_8 (A, B);
input [2:0] A;
output reg [7:0] B;

always @ (*)
	case (A)
	
		3'b000 : assign B = 8'h00;
		3'b001 : assign B = 8'h02;
		3'b010 : assign B = 8'h04;
		3'b011 : assign B = 8'h08;
		3'b100 : assign B = 8'h10;
		3'b101 : assign B = 8'h20;
		3'b110 : assign B = 8'h40;
		3'b111 : assign B = 8'h80;

	endcase


endmodule
