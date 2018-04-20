module forwarding (ALU_in1_sel, ALU_in2_sel, EX_Rs, EX_Rt, MEM_Rd, WB_Rd);

input [3:0] MEM_Rd, WB_Rd, EX_Rs, EX_Rt;
output [1:0] ALU_in1_sel, ALU_in2_sel;

assign ALU_in1_sel[1] = MEM_Rd == EX_Rs;
assign ALU_in1_sel[0] = WB_Rd == EX_Rs;

assign ALU_in2_sel[1] = MEM_Rd == EX_Rt;
assign ALU_in2_sel[0] = WB_Rd == EX_Rt;

endmodule
