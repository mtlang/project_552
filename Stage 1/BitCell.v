module BitCell(clk, rst, D, WriteEnable, ReadEnable1, ReadEnable2, Bitline1, Bitline2);

input clk, rst, D, WriteEnable, ReadEnable1, ReadEnable2;

inout Bitline1, Bitline2;

// Internal Signals
wire q;

// Instantiate a DFF to hold values
dff DFF(.q(q), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));

// Tri state buffers
assign Bitline1 = (ReadEnable1) ? q : 1'bz;
assign Bitline2 = (ReadEnable2) ? q : 1'bz;

// Change to if read and write register are the same, bypass. Also move to register level?

endmodule
