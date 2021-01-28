 module exp6_1(clk,KEY,data,data_out);
	input clk;
	input [2:0]	KEY;
	input [7:0]	data;
	reg temp_data [7:0];
	output reg [7:0] data_out;
	integer i;
	always @(posedge clk)
	begin
	if(KEY!=3'b101)
		i=0;
	if(KEY==3'b000)//clear
		data_out<=8'b00000000;	
	else if(KEY==3'b001)//set
		begin
		for(i=0;i<8;i=i+1)
			data_out[i]<=data[i];
		end
	else if(KEY==3'b010)//shr
		data_out<={1'b0,data_out[7:1]};
	else if(KEY==3'b011)//shl
		data_out<=(data_out<<1'b1);	
	else if(KEY==3'b100)//sar
		data_out<={data_out[7],data_out[7:1]};
	else if(KEY==3'b101)//in&out
		begin
		temp_data[i]=data[0];
		i=i+1;
		if(i==8)
			begin
			for(i=0;i<8;i=i+1)
				data_out[i]<=temp_data[i];
			end
		end
	else if(KEY==3'b110)//loop right
		begin
		data_out<={data_out[0],data_out[7:1]};
		end
	else//loop left
		begin
		data_out<={data_out[6:0],data_out[7]};		
		end
	end
endmodule
