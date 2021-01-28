module exp4_2(clk,in_d,en,out_d1,out_d2,clr);
	input clk;
	input in_d;
	input en;
	input clr;
	output out_d1,out_d2;
	synchro A (.clk(clk),.in_d(in_d),.en(en),.out_d(out_d1),.clr(clr));
	asynchro B (.clk(clk),.in_d(in_d),.en(en),.out_d(out_d2),.clr(clr));
endmodule
