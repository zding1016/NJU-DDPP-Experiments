module exp5_4_1(input CLK,input pause, input en,
input clr, output [6:0] HEX0, output [6:0] HEX1, output ending);
	wire CLK_div;
	div_N A (CLK,CLK_div);
	counter B (CLK_div,en,pause,clr, HEX0, HEX1,ending);
endmodule
