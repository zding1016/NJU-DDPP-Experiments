module exp6_2(clk,HEX0,HEX1);
	input clk;
	output reg [6:0] HEX0;
	output reg [6:0] HEX1;
	reg [7:0] data_out=8'b00000000;
	integer i;
	always @(posedge clk)
	begin
		if(data_out==8'b00000000)
			data_out=8'b10000000;
		else
			data_out={data_out[4]^data_out[3]^data_out[2]^data_out[0],data_out[7:1]};
	end
	always @(*)
	begin
			if(data_out[3:0]==4'b0000)
				HEX0=7'b1000000;
			else if(data_out[3:0]==4'b0001)
				HEX0=7'b1111001;
			else if(data_out[3:0]==4'b0010)
				HEX0=7'b0100100;	
			else if(data_out[3:0]==4'b0011)
				HEX0=7'b0110000;
			else if(data_out[3:0]==4'b0100)
				HEX0=7'b0011001;
			else if(data_out[3:0]==4'b0101)
				HEX0=7'b0010010;
			else if(data_out[3:0]==4'b0110)
				HEX0=7'b0000010;	
			else if(data_out[3:0]==4'b0111)
				HEX0=7'b1111000;	
			else if(data_out[3:0]==4'b1000)
				HEX0=7'b0000000;
			else if(data_out[3:0]==4'b1001)
				HEX0=7'b0010000;
			else if(data_out[3:0]==4'b1010)
				HEX0=7'b0001000;
			else if(data_out[3:0]==4'b1011)
				HEX0=7'b1000110;	
			else if(data_out[3:0]==4'b1100)
				HEX0=7'b0110000;
			else if(data_out[3:0]==4'b1101)
				HEX0=7'b0100001;
			else if(data_out[3:0]==4'b1110)
				HEX0=7'b0000110;
			else if(data_out[3:0]==4'b1111)
				HEX0=7'b0001110;
			
			if(data_out[7:4]==4'b0000)
				HEX1=7'b1000000;
			else if(data_out[7:4]==4'b0001)
				HEX1=7'b1111001;
			else if(data_out[7:4]==4'b0010)
				HEX1=7'b0100100;	
			else if(data_out[7:4]==4'b0011)
				HEX1=7'b0110000;
			else if(data_out[7:4]==4'b0100)
				HEX1=7'b0011001;
			else if(data_out[7:4]==4'b0101)
				HEX1=7'b0010010;
			else if(data_out[7:4]==4'b0110)
				HEX1=7'b0000010;	
			else if(data_out[7:4]==4'b0111)
				HEX1=7'b1111000;	
			else if(data_out[7:4]==4'b1000)
				HEX1=7'b0000000;
			else if(data_out[7:4]==4'b1001)
				HEX1=7'b0010000;
			else if(data_out[7:4]==4'b1010)
				HEX1=7'b0001000;
			else if(data_out[7:4]==4'b1011)
				HEX1=7'b1000110;	
			else if(data_out[7:4]==4'b1100)
				HEX1=7'b0110000;
			else if(data_out[7:4]==4'b1101)
				HEX1=7'b0100001;
			else if(data_out[7:4]==4'b1110)
				HEX1=7'b0000110;
			else if(data_out[7:4]==4'b1111)
				HEX1=7'b0001110;		
	end			
endmodule
