module display_panel(data_out,pre,ascii_in,count,capslock,shift,
HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
input [7:0] data_out;
input [7:0] ascii_in;
input [7:0] count;
input pre,capslock,shift;

output reg [6:0] HEX0;
output reg [6:0] HEX1;
output reg [6:0] HEX2;
output reg [6:0] HEX3;
output reg [6:0] HEX4;
output reg [6:0] HEX5;

reg [7:0] ascii;
always@(*)
begin
	ascii=ascii_in;
	if(capslock==1&&shift==0&&ascii>=97&&ascii<=122)//up
	begin
		ascii=ascii-32;
	end
	else if(capslock==0&&shift==1)
	begin
		if(ascii>=97&&ascii<=122)
		begin
			ascii=ascii-32;
		end
		else
		begin
			case(ascii[7:0])
				48:ascii=41;
				49:ascii=33;
				50:ascii=64;
				51:ascii=35;
				52:ascii=36;
				53:ascii=37;
				54:ascii=94;
				55:ascii=38;
				56:ascii=42;
				57:ascii=40;//0~9
				45:ascii=95;
				61:ascii=43;
				96:ascii=126;
				91:ascii=123;
				93:ascii=125;
				92:ascii=124;
				59:ascii=58;
				39:ascii=34;
				44:ascii=60;
				46:ascii=62;
				47:ascii=63;
				default:ascii=ascii;
			endcase
		end
	end
	
	if(data_out==8'hf0||pre==0)
		begin
		HEX0=7'b1111111;
		HEX1=7'b1111111;
		HEX2=7'b1111111;
		HEX3=7'b1111111;
		end
	else
		begin
			if(data_out[7:4]==4'b0000)
				HEX1=7'b1000000;
			else if(data_out[7:4]==4'h1)
				HEX1=7'b1111001;
			else if(data_out[7:4]==4'h2)
				HEX1=7'b0100100;	
			else if(data_out[7:4]==4'h3)
				HEX1=7'b0110000;
			else if(data_out[7:4]==4'h4)
				HEX1=7'b0011001;
			else if(data_out[7:4]==4'h5)
				HEX1=7'b0010010;
			else if(data_out[7:4]==4'h6)
				HEX1=7'b0000010;	
			else if(data_out[7:4]==4'h7)
				HEX1=7'b1111000;	
			else if(data_out[7:4]==4'h8)
				HEX1=7'b0000000;
			else if(data_out[7:4]==4'h9)
				HEX1=7'b0010000;
			else if(data_out[7:4]==4'ha)
				HEX1=7'b0001000;
			else if(data_out[7:4]==4'hb)
				HEX1=7'b0000011;	
			else if(data_out[7:4]==4'hc)
				HEX1=7'b1000110;
			else if(data_out[7:4]==4'hd)
				HEX1=7'b0100001;
			else if(data_out[7:4]==4'he)
				HEX1=7'b0000110;
			else if(data_out[7:4]==4'hf)
				HEX1=7'b0000110;
				
			if(data_out[3:0]==4'b0000)
				HEX0=7'b1000000;
			else if(data_out[3:0]==4'h1)
				HEX0=7'b1111001;
			else if(data_out[3:0]==4'h2)
				HEX0=7'b0100100;	
			else if(data_out[3:0]==4'h3)
				HEX0=7'b0110000;
			else if(data_out[3:0]==4'h4)
				HEX0=7'b0011001;
			else if(data_out[3:0]==4'h5)
				HEX0=7'b0010010;
			else if(data_out[3:0]==4'h6)
				HEX0=7'b0000010;	
			else if(data_out[3:0]==4'h7)
				HEX0=7'b1111000;	
			else if(data_out[3:0]==4'h8)
				HEX0=7'b0000000;
			else if(data_out[3:0]==4'h9)
				HEX0=7'b0010000;
			else if(data_out[3:0]==4'ha)
				HEX0=7'b0001000;
			else if(data_out[3:0]==4'hb)
				HEX0=7'b0000011;	
			else if(data_out[3:0]==4'hc)
				HEX0=7'b1000110;
			else if(data_out[3:0]==4'hd)
				HEX0=7'b0100001;
			else if(data_out[3:0]==4'he)
				HEX0=7'b0000110;
			else if(data_out[3:0]==4'hf)
				HEX0=7'b0000110;		
				
			if(ascii[3:0]==4'b0000)
				HEX2=7'b1000000;
			else if(ascii[3:0]==4'b0001)
				HEX2=7'b1111001;
			else if(ascii[3:0]==4'b0010)
				HEX2=7'b0100100;	
			else if(ascii[3:0]==4'b0011)
				HEX2=7'b0110000;
			else if(ascii[3:0]==4'b0100)
				HEX2=7'b0011001;
			else if(ascii[3:0]==4'b0101)
				HEX2=7'b0010010;
			else if(ascii[3:0]==4'b0110)
				HEX2=7'b0000010;	
			else if(ascii[3:0]==4'b0111)
				HEX2=7'b1111000;	
			else if(ascii[3:0]==4'b1000)
				HEX2=7'b0000000;
			else if(ascii[3:0]==4'b1001)
				HEX2=7'b0010000;
			else if(ascii[3:0]==4'b1010)
				HEX2=7'b0001000;
			else if(ascii[3:0]==4'b1011)
				HEX2=7'b1000110;	
			else if(ascii[3:0]==4'b1100)
				HEX2=7'b0110000;
			else if(ascii[3:0]==4'b1101)
				HEX2=7'b0100001;
			else if(ascii[3:0]==4'b1110)
				HEX2=7'b0000110;
			else if(ascii[3:0]==4'b1111)
				HEX2=7'b0001110;
			
			if(ascii[7:4]==4'b0000)
				HEX3=7'b1000000;
			else if(ascii[7:4]==4'b0001)
				HEX3=7'b1111001;
			else if(ascii[7:4]==4'b0010)
				HEX3=7'b0100100;	
			else if(ascii[7:4]==4'b0011)
				HEX3=7'b0110000;
			else if(ascii[7:4]==4'b0100)
				HEX3=7'b0011001;
			else if(ascii[7:4]==4'b0101)
				HEX3=7'b0010010;
			else if(ascii[7:4]==4'b0110)
				HEX3=7'b0000010;	
			else if(ascii[7:4]==4'b0111)
				HEX3=7'b1111000;	
			else if(ascii[7:4]==4'b1000)
				HEX3=7'b0000000;
			else if(ascii[7:4]==4'b1001)
				HEX3=7'b0010000;
			else if(ascii[7:4]==4'b1010)
				HEX3=7'b0001000;
			else if(ascii[7:4]==4'b1011)
				HEX3=7'b1000110;	
			else if(ascii[7:4]==4'b1100)
				HEX3=7'b0110000;
			else if(ascii[7:4]==4'b1101)
				HEX3=7'b0100001;
			else if(ascii[7:4]==4'b1110)
				HEX3=7'b0000110;
			else if(ascii[7:4]==4'b1111)
				HEX3=7'b0001110;		
		end		
			
end

always@(*)
begin
		if(count%10==0)
				HEX4=7'b1000000;
			else if(count%10==1)
				HEX4=7'b1111001;
			else if(count%10==2)
				HEX4=7'b0100100;	
			else if(count%10==3)
				HEX4=7'b0110000;
			else if(count%10==4)
				HEX4=7'b0011001;
			else if(count%10==5)
				HEX4=7'b0010010;
			else if(count%10==6)
				HEX4=7'b0000010;	
			else if(count%10==7)
				HEX4=7'b1111000;	
			else if(count%10==8)
				HEX4=7'b0000000;
			else if(count%10==9)
				HEX4=7'b0010000;
			
			if(count/10==0)
				HEX5=7'b1000000;
			else if(count/10==1)
				HEX5=7'b1111001;
			else if(count/10==2)
				HEX5=7'b0100100;	
			else if(count/10==3)
				HEX5=7'b0110000;
			else if(count/10==4)
				HEX5=7'b0011001;
			else if(count/10==5)
				HEX5=7'b0010010;
			else if(count/10==6)
				HEX5=7'b0000010;	
			else if(count/10==7)
				HEX5=7'b1111000;	
			else if(count/10==8)
				HEX5=7'b0000000;
			else if(count/10==9)
				HEX5=7'b0010000;
end
endmodule
