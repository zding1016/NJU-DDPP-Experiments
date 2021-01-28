module exp4_1_2(clk,in_data,en,out_lock1,out_lock2);
	input clk; 
	input in_data; 
	input en; 
	output reg out_lock1,out_lock2; 
	always @ (posedge clk ) 
	begin
	if(en)
		begin
		out_lock1<=in_data;
		out_lock2<=out_lock1;
		end
	else
		begin
		out_lock1<=out_lock1;
		out_lock2<=out_lock2;
		end
	end	
endmodule