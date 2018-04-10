module hazard_detection_unit (HLT, Branch, ID_instruction, EX_BR, EX_dstreg, EX_MemRead, Stall, Flush);

input [7:0] ID_instruction;
input HLT, Branch, EX_BR, EX_dstreg, EX_MemRead;
output Stall, Flush;

assign Flush = Branch | EX_BR;

assign Stall = HLT | (EX_MemRead & ((EX_dstreg == ID_instruction[7:4]) | (EX_dstreg == ID_instruction[3:0])));


endmodule
