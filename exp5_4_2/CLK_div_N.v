module div_N(input CLK,output reg CLK_div_N);
	parameter N=25000000;
	reg [31:0] count=0;
	always @ (posedge CLK)
	begin
	if(count==2*N) 
	count<=0;       
	else count<=count+1;    
	CLK_div_N=(count<N)?0:1;
	end
endmodule
