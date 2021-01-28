module exp5_4_2(input CLK,input start,input clr,input adj_sec, input adj_min, 
input adj_hou, input pause,input set,output timing,output [6:0] HEX0,output [6:0] HEX1,output [6:0] HEX2,
output [6:0] HEX3,output [6:0] HEX4,output [6:0] HEX5);
	wire div;
	wire div1;
		div_N A (CLK,div);
		div_N1 C (CLK,div1);
		counter B (div,div1,set,start,clr,adj_sec,adj_min,adj_hou,pause,timing,
		HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
endmodule
