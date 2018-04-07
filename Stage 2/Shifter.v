module Shifter (Shift_Out, Shift_In, Shift_Val, Mode);
input [15:0] Shift_In; //This is the number to perform shift operation on
input [3:0] Shift_Val; //Shift amount (used to shift the 'Shift_In')
input  [1:0] Mode; // 00 -> SLL, 01 -> SRA, 10 -> ROR
output [15:0] Shift_Out; //Shifter value

wire [15:0] L_Result, R_Result, RR_Result, Int_Result; // Result for each shifter, result of first mux

LShifter L(.Shift_Out(L_Result), .Shift_In(Shift_In), .Shift_Val(Shift_Val));
RShifter R(.Shift_Out(R_Result), .Shift_In(Shift_In), .Shift_Val(Shift_Val));
RRotator RR(.Shift_Out(RR_Result), .Shift_In(Shift_In), .Shift_Val(Shift_Val));

assign Int_Result = (Mode[0]) ? R_Result : L_Result;
assign Shift_Out = (Mode[1]) ? RR_Result : Int_Result;

endmodule

module LShifter(Shift_Out, Shift_In, Shift_Val);
input [15:0] Shift_In; //This is the number to perform shift operation on
input [3:0] Shift_Val; //Shift amount (used to shift the 'Shift_In')
output [15:0] Shift_Out; //Shifter value

wire[15:0] L_shifted1;
wire[15:0] L_shifted2;
wire[15:0] L_shifted3;

assign L_shifted1[15:1] = (Shift_Val[0]) ? Shift_In[14:0] : Shift_In[15:1];
assign L_shifted1[0] = (Shift_Val[0]) ? 1'b0 : Shift_In[0];

assign L_shifted2[15:2] = (Shift_Val[1]) ? L_shifted1[13:0] : L_shifted1[15:2];
assign L_shifted2[1:0] = (Shift_Val[1]) ? 2'b0 : L_shifted1[1:0];

assign L_shifted3[15:4] = (Shift_Val[2]) ? L_shifted2[11:0] : L_shifted2[15:4];
assign L_shifted3[3:0] = (Shift_Val[2]) ? 4'b0 : L_shifted2[3:0];

assign Shift_Out[15:8] = (Shift_Val[3]) ? L_shifted3[7:0] : L_shifted3[15:8];
assign Shift_Out[7:0] = (Shift_Val[3]) ? 8'b0 : L_shifted3[7:0];

endmodule

module RShifter(Shift_Out, Shift_In, Shift_Val);
input [15:0] Shift_In; //This is the number to perform shift operation on
input [3:0] Shift_Val; //Shift amount (used to shift the 'Shift_In')
output [15:0] Shift_Out; //Shifter value

wire[15:0] R_shifted1;
wire[15:0] R_shifted2;
wire[15:0] R_shifted3;

assign R_shifted1[14:0] = (Shift_Val[0]) ? Shift_In[15:1] : Shift_In[14:0];
assign R_shifted1[15] = Shift_In[15];

assign R_shifted2[13:0] = (Shift_Val[1]) ? R_shifted1[15:2] : R_shifted1[13:0];
assign R_shifted2[15:14] = (Shift_Val[1]) ? {2{R_shifted1[15]}} : R_shifted1[15:14];

assign R_shifted3[11:0] = (Shift_Val[2]) ? R_shifted2[15:4] : R_shifted2[11:0];
assign R_shifted3[15:12] = (Shift_Val[2]) ? {4{R_shifted2[15]}} : R_shifted2[15:12];

assign Shift_Out[7:0] = (Shift_Val[3]) ? R_shifted3[15:8] : R_shifted3[7:0];
assign Shift_Out[15:8] = (Shift_Val[3]) ? {8{R_shifted3[15]}} : R_shifted3[15:8];

endmodule

module RRotator(Shift_Out, Shift_In, Shift_Val);
input [15:0] Shift_In; //This is the number to perform shift operation on
input [3:0] Shift_Val; //Shift amount (used to shift the 'Shift_In')
output [15:0] Shift_Out; //Shifter value

wire[15:0] R_shifted1;
wire[15:0] R_shifted2;
wire[15:0] R_shifted3;

assign R_shifted1[14:0] = (Shift_Val[0]) ? Shift_In[15:1] : Shift_In[14:0];
assign R_shifted1[15] = (Shift_Val[0]) ? Shift_In[0] : Shift_In[15];

assign R_shifted2[13:0] = (Shift_Val[1]) ? R_shifted1[15:2] : R_shifted1[13:0];
assign R_shifted2[15:14] = (Shift_Val[1]) ? R_shifted1[1:0] : R_shifted1[15:14];

assign R_shifted3[11:0] = (Shift_Val[2]) ? R_shifted2[15:4] : R_shifted2[11:0];
assign R_shifted3[15:12] = (Shift_Val[2]) ? R_shifted2[3:0] : R_shifted2[15:12];

assign Shift_Out[7:0] = (Shift_Val[3]) ? R_shifted3[15:8] : R_shifted3[7:0];
assign Shift_Out[15:8] = (Shift_Val[3]) ? R_shifted3[7:0] : R_shifted3[15:8];

endmodule
