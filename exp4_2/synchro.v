module synchro(clk,in_d,en,out_d,clr);
	input clk;
	input in_d;
	input en;
	input clr;
	output reg out_d;
	always@(posedge clk)
	begin
		if(clr)
		begin
			if(en)
				out_d<=0;
			else 
				out_d<=out_d;
		end
		else
		begin
		if(en==0)
			out_d<=out_d;
		else
			out_d<=in_d;
		end
	end	
endmodule
