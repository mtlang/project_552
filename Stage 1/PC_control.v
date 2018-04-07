module PC_control(C, I, F, PC_in, PC_out, PC_Plus_Two, BRANCH);

input BRANCH;
input [2:0] C, F;	// F = [Z, V, N] Z is zero, V is overflow, N is signed
input [8:0] I;
input [15:0] PC_in;

output [15:0] PC_out;
output [15:0] PC_Plus_Two;

// Internal Signals
wire branch;
wire [1:0] ovfl;
wire [8:0] I_shift;
wire [15:0] PC_val;			// Value of PC+2
wire [15:0] PC_branch_val;	// Value of PC+2+(I<<1)

//////////////////////////////////////////////////////////////////
// Branch determined if one of the following conditions are met //
//////////////////////////////////////////////////////////////////
assign branch = (C == 3'b000) ? ~F[2] :					// Not Equal (Z=0)
		(C == 3'b001) ? F[2] :							// Equal (Z=1)
		(C == 3'b010) ? ~F[2] & ~F[0] :					// Greater than (Z=N=0)
		(C == 3'b011) ? F[0] : 							// Less than (N=1)
		(C == 3'b100) ? F[2] | (~F[2] & ~F[0]) : 		// Greater than or Equal (Z=1 or Z=N=0)
		(C == 3'b101) ? F[2] | F[0] :					// Less than or Equal (N=1 or Z=1)
		(C == 3'b110) ? F[1] :							// Overflow (V=1)
		1'b1;											// Unconditional

///////////////////////////
// PC value calculations //
///////////////////////////
assign I_shift = {I[7:0], 1'b0};

// Instantiate adders for PC calculations
addsub_16bit adder1(.Sum(PC_val), .Ovfl(ovfl[0]), .A(PC_in), .B(16'h0002), .sub(1'b0));
addsub_16bit adder2(.Sum(PC_branch_val), .Ovfl(ovfl[1]), .A(PC_val), .B({7'h00, I_shift}), .sub(1'b0));
addsub_16bit adder3(.Sum(PC_Plus_Two), .Ovfl(ovfl[0]), .A(PC_val), .B(16'h0002), .sub(1'b0));

assign PC_out = (branch & BRANCH) ? PC_branch_val : PC_val;

endmodule