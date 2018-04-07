module reduction_tb ();
reg[15:0] rs, rt;
wire[6:0] rd;
integer i;

reduction_unit_16bit DUT (.rs(rs), .rt(rt), .rd(rd));

initial begin
for(i=0; i<5; i=i+1) begin
rs = $random();
rt = $random();
#100;
end
end

initial $monitor("aaaa = {%b}\tbbbb = {%b}\tcccc = {%b}\tdddd = {%b}\neeee = {%b}\tffff = {%b}\tgggg = {%b}\thhhhh = {%b}\nresult: %d",rs[3:0],rs[7:4],rs[11:8],rs[15:12],rt[3:0],rt[7:4],rt[11:8],rt[15:12],rd);

endmodule
