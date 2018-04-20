module BitCell(clk, rst, D, WriteEnable, ReadEnable1, ReadEnable2, Bitline1, Bitline2);

input clk, rst, D, WriteEnable, ReadEnable1, ReadEnable2;

inout Bitline1, Bitline2;

// Internal Signals
wire q;
wire forwarding;		// for data forwarding

// Instantiate a DFF to hold values
dff DFF(.q(q), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));

// Data forwarding
assign forwarding = (WriteEnable) ? D : q;

// Tri state buffers w/ Data forwarding
assign Bitline1 = (ReadEnable1) ? forwarding : 1'bz;
assign Bitline2 = (ReadEnable2) ? forwarding : 1'bz;

endmodule
