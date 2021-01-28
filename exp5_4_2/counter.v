module counter(CLK,CLK1,set,start,clr,adj_sec,adj_min,adj_hou,pause,timing,
		HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
 input CLK,CLK1,set,start,clr,adj_sec,adj_min,adj_hou,pause;
 output reg [6:0] HEX0;
 output reg [6:0] HEX1;
 output reg [6:0] HEX2;
 output reg [6:0] HEX3;
 output reg [6:0] HEX4;
 output reg [6:0] HEX5;
 output reg timing;
 reg [7:0] second=0;
 reg [7:0] minute=0;
 reg [7:0] hour=0;
 reg [7:0] set_second=0;
 reg [7:0] set_minute=0;
 reg [7:0] set_hour=0;
 reg [7:0] c_second=0;
 reg [7:0] c_minute=0;
 reg [7:0] c_hour=0;
 reg [7:0] s_second=0;
 reg [7:0] s_minute=0;
 reg [7:0] s_hour=0;
 reg find_set=0;
 reg sign=0;
always @ (posedge CLK1)
begin
	if(start==1)
	begin
			if(clr==1)
			begin
				c_second<=0;
				c_minute<=0;
				c_hour<=0;
			end
			else
			begin
				if(pause==1)
				begin
				c_second<=c_second;
				c_hour<=c_hour;
				c_minute<=c_minute;
				end
				else
				begin
					c_second<=c_second+1;
					if(c_second==99&&c_minute==59)
					begin
						c_hour<=c_hour+1;
						c_second<=0;
						c_minute<=0;
					end
					else if(c_second==99)
					begin
						c_second<=0;
						c_minute<=c_minute+1;
					end
				end
			end
	end	
end

always @ (posedge CLK)
begin
	if(set==0&&find_set==1&&(set_second-1)==second&&set_minute==minute&&set_hour==hour)
		begin
			find_set<=0;
			timing<=1;
			sign=0;
		end
	if(set==1)
		begin
			if(sign==0)
			begin
				s_second<=second;
				s_minute<=minute;
				s_hour<=hour;
				sign=1;
			end
			if(adj_sec==1)
				s_second<=(s_second+1)%60;
			if(adj_min==1)
				s_minute<=(s_minute+1)%60;
			if(adj_hou==1)
					s_hour<=(s_hour+1)%24;
				set_second<=s_second;
				set_minute<=s_minute;
				set_hour<=s_hour;
				find_set<=1;		
		end		
	if(clr==1)
		begin
			second<=0;
			minute<=0;
			hour<=0;
		end
	else if(pause==1&&set==0)
		begin
			if(find_set==0)
				timing<=0;
			if(adj_sec==1)
				second<=(second+1)%60;
			if(adj_min==1)
				minute<=(minute+1)%60;
			if(adj_hou==1)
					hour<=(hour+1)%24;
		end
	else 
		begin
				if(find_set==0)
					timing<=0;
				second<=second+1;
				if(hour==23&&minute==59&&second==59)
				begin
					hour<=0;
					minute<=0;
					second<=0;
				end
				else if(minute==59&&second==59)
				begin
					hour<=hour+1;
					minute<=0;
					second<=0;
				end
				else if(second==59)
				begin
					minute<=minute+1;
					second<=0;
				end
		end
end

always @(*)
begin
	if(set==1)
	begin
		if(s_second%10==0)
				HEX0=7'b1000000;
			else if(s_second%10==1)
				HEX0=7'b1111001;
			else if(s_second%10==2)
				HEX0=7'b0100100;	
			else if(s_second%10==3)
				HEX0=7'b0110000;
			else if(s_second%10==4)
				HEX0=7'b0011001;
			else if(s_second%10==5)
				HEX0=7'b0010010;
			else if(s_second%10==6)
				HEX0=7'b0000010;	
			else if(s_second%10==7)
				HEX0=7'b1111000;	
			else if(s_second%10==8)
				HEX0=7'b0000000;
			else if(s_second%10==9)
				HEX0=7'b0010000;
				
			if(s_second/10==0)
				HEX1=7'b1000000;
			else if(s_second/10==1)
				HEX1=7'b1111001;
			else if(s_second/10==2)
				HEX1=7'b0100100;	
			else if(s_second/10==3)
				HEX1=7'b0110000;
			else if(s_second/10==4)
				HEX1=7'b0011001;
			else if(s_second/10==5)
				HEX1=7'b0010010;
			else if(s_second/10==6)
				HEX1=7'b0000010;	
			else if(s_second/10==7)
				HEX1=7'b1111000;	
			else if(s_second/10==8)
				HEX1=7'b0000000;
			else if(s_second/10==9)
				HEX1=7'b0010000;		
			
			if(s_minute%10==0)
				HEX2=7'b1000000;
			else if(s_minute%10==1)
				HEX2=7'b1111001;
			else if(s_minute%10==2)
				HEX2=7'b0100100;	
			else if(s_minute%10==3)
				HEX2=7'b0110000;
			else if(s_minute%10==4)
				HEX2=7'b0011001;
			else if(s_minute%10==5)
				HEX2=7'b0010010;
			else if(s_minute%10==6)
				HEX2=7'b0000010;	
			else if(s_minute%10==7)
				HEX2=7'b1111000;	
			else if(s_minute%10==8)
				HEX2=7'b0000000;
			else if(s_minute%10==9)
				HEX2=7'b0010000;
			
			if(s_minute/10==0)
				HEX3=7'b1000000;
			else if(s_minute/10==1)
				HEX3=7'b1111001;
			else if(s_minute/10==2)
				HEX3=7'b0100100;	
			else if(s_minute/10==3)
				HEX3=7'b0110000;
			else if(s_minute/10==4)
				HEX3=7'b0011001;
			else if(s_minute/10==5)
				HEX3=7'b0010010;
			else if(s_minute/10==6)
				HEX3=7'b0000010;	
			else if(s_minute/10==7)
				HEX3=7'b1111000;	
			else if(s_minute/10==8)
				HEX3=7'b0000000;
			else if(s_minute/10==9)
				HEX3=7'b0010000;		
			
			if(s_hour%10==0)
				HEX4=7'b1000000;
			else if(s_hour%10==1)
				HEX4=7'b1111001;
			else if(s_hour%10==2)
				HEX4=7'b0100100;	
			else if(s_hour%10==3)
				HEX4=7'b0110000;
			else if(s_hour%10==4)
				HEX4=7'b0011001;
			else if(s_hour%10==5)
				HEX4=7'b0010010;
			else if(s_hour%10==6)
				HEX4=7'b0000010;	
			else if(s_hour%10==7)
				HEX4=7'b1111000;	
			else if(s_hour%10==8)
				HEX4=7'b0000000;
			else if(s_hour%10==9)
				HEX4=7'b0010000;
			
			if(s_hour/10==0)
				HEX5=7'b1000000;
			else if(s_hour/10==1)
				HEX5=7'b1111001;
			else if(s_hour/10==2)
				HEX5=7'b0100100;	
			else if(s_hour/10==3)
				HEX5=7'b0110000;
			else if(s_hour/10==4)
				HEX5=7'b0011001;
			else if(s_hour/10==5)
				HEX5=7'b0010010;
			else if(s_hour/10==6)
				HEX5=7'b0000010;	
			else if(s_hour/10==7)
				HEX5=7'b1111000;	
			else if(s_hour/10==8)
				HEX5=7'b0000000;
			else if(s_hour/10==9)
				HEX5=7'b0010000;	
	end
	else if(start==1)
	begin
		if(c_second%10==0)
				HEX0=7'b1000000;
			else if(c_second%10==1)
				HEX0=7'b1111001;
			else if(c_second%10==2)
				HEX0=7'b0100100;	
			else if(c_second%10==3)
				HEX0=7'b0110000;
			else if(c_second%10==4)
				HEX0=7'b0011001;
			else if(c_second%10==5)
				HEX0=7'b0010010;
			else if(c_second%10==6)
				HEX0=7'b0000010;	
			else if(c_second%10==7)
				HEX0=7'b1111000;	
			else if(c_second%10==8)
				HEX0=7'b0000000;
			else if(c_second%10==9)
				HEX0=7'b0010000;
				
			if(c_second/10==0)
				HEX1=7'b1000000;
			else if(c_second/10==1)
				HEX1=7'b1111001;
			else if(c_second/10==2)
				HEX1=7'b0100100;	
			else if(c_second/10==3)
				HEX1=7'b0110000;
			else if(c_second/10==4)
				HEX1=7'b0011001;
			else if(c_second/10==5)
				HEX1=7'b0010010;
			else if(c_second/10==6)
				HEX1=7'b0000010;	
			else if(c_second/10==7)
				HEX1=7'b1111000;	
			else if(c_second/10==8)
				HEX1=7'b0000000;
			else if(c_second/10==9)
				HEX1=7'b0010000;		
				
			if(c_minute%10==0)
				HEX2=7'b1000000;
			else if(c_minute%10==1)
				HEX2=7'b1111001;
			else if(c_minute%10==2)
				HEX2=7'b0100100;	
			else if(c_minute%10==3)
				HEX2=7'b0110000;
			else if(c_minute%10==4)
				HEX2=7'b0011001;
			else if(c_minute%10==5)
				HEX2=7'b0010010;
			else if(c_minute%10==6)
				HEX2=7'b0000010;	
			else if(c_minute%10==7)
				HEX2=7'b1111000;	
			else if(c_minute%10==8)
				HEX2=7'b0000000;
			else if(c_minute%10==9)
				HEX2=7'b0010000;
				
			if(c_minute/10==0)
				HEX3=7'b1000000;
			else if(c_minute/10==1)
				HEX3=7'b1111001;
			else if(c_minute/10==2)
				HEX3=7'b0100100;	
			else if(c_minute/10==3)
				HEX3=7'b0110000;
			else if(c_minute/10==4)
				HEX3=7'b0011001;
			else if(c_minute/10==5)
				HEX3=7'b0010010;
			else if(c_minute/10==6)
				HEX3=7'b0000010;	
			else if(c_minute/10==7)
				HEX3=7'b1111000;	
			else if(c_minute/10==8)
				HEX3=7'b0000000;
			else if(c_minute/10==9)
				HEX3=7'b0010000;		
			
			if(c_hour%10==0)
				HEX4=7'b1000000;
			else if(c_hour%10==1)
				HEX4=7'b1111001;
			else if(c_hour%10==2)
				HEX4=7'b0100100;	
			else if(c_hour%10==3)
				HEX4=7'b0110000;
			else if(c_hour%10==4)
				HEX4=7'b0011001;
			else if(c_hour%10==5)
				HEX4=7'b0010010;
			else if(c_hour%10==6)
				HEX4=7'b0000010;	
			else if(c_hour%10==7)
				HEX4=7'b1111000;	
			else if(c_hour%10==8)
				HEX4=7'b0000000;
			else if(c_hour%10==9)
				HEX4=7'b0010000;
				
			if(c_hour/10==0)
				HEX5=7'b1000000;
			else if(c_hour/10==1)
				HEX5=7'b1111001;
			else if(c_hour/10==2)
				HEX5=7'b0100100;	
			else if(c_hour/10==3)
				HEX5=7'b0110000;
			else if(c_hour/10==4)
				HEX5=7'b0011001;
			else if(c_hour/10==5)
				HEX5=7'b0010010;
			else if(c_hour/10==6)
				HEX5=7'b0000010;	
			else if(c_hour/10==7)
				HEX5=7'b1111000;	
			else if(c_hour/10==8)
				HEX5=7'b0000000;
			else if(c_hour/10==9)
				HEX5=7'b0010000;	
	end
	else 
	begin
		if(second%10==0)
				HEX0=7'b1000000;
			else if(second%10==1)
				HEX0=7'b1111001;
			else if(second%10==2)
				HEX0=7'b0100100;	
			else if(second%10==3)
				HEX0=7'b0110000;
			else if(second%10==4)
				HEX0=7'b0011001;
			else if(second%10==5)
				HEX0=7'b0010010;
			else if(second%10==6)
				HEX0=7'b0000010;	
			else if(second%10==7)
				HEX0=7'b1111000;	
			else if(second%10==8)
				HEX0=7'b0000000;
			else if(second%10==9)
				HEX0=7'b0010000;
				
			if(second/10==0)
				HEX1=7'b1000000;
			else if(second/10==1)
				HEX1=7'b1111001;
			else if(second/10==2)
				HEX1=7'b0100100;	
			else if(second/10==3)
				HEX1=7'b0110000;
			else if(second/10==4)
				HEX1=7'b0011001;
			else if(second/10==5)
				HEX1=7'b0010010;
			else if(second/10==6)
				HEX1=7'b0000010;	
			else if(second/10==7)
				HEX1=7'b1111000;	
			else if(second/10==8)
				HEX1=7'b0000000;
			else if(second/10==9)
				HEX1=7'b0010000;		
				
			if(minute%10==0)
				HEX2=7'b1000000;
			else if(minute%10==1)
				HEX2=7'b1111001;
			else if(minute%10==2)
				HEX2=7'b0100100;	
			else if(minute%10==3)
				HEX2=7'b0110000;
			else if(minute%10==4)
				HEX2=7'b0011001;
			else if(minute%10==5)
				HEX2=7'b0010010;
			else if(minute%10==6)
				HEX2=7'b0000010;	
			else if(minute%10==7)
				HEX2=7'b1111000;	
			else if(minute%10==8)
				HEX2=7'b0000000;
			else if(minute%10==9)
				HEX2=7'b0010000;
				
			if(minute/10==0)
				HEX3=7'b1000000;
			else if(minute/10==1)
				HEX3=7'b1111001;
			else if(minute/10==2)
				HEX3=7'b0100100;	
			else if(minute/10==3)
				HEX3=7'b0110000;
			else if(minute/10==4)
				HEX3=7'b0011001;
			else if(minute/10==5)
				HEX3=7'b0010010;
			else if(minute/10==6)
				HEX3=7'b0000010;	
			else if(minute/10==7)
				HEX3=7'b1111000;	
			else if(minute/10==8)
				HEX3=7'b0000000;
			else if(minute/10==9)
				HEX3=7'b0010000;		
			
			if(hour%10==0)
				HEX4=7'b1000000;
			else if(hour%10==1)
				HEX4=7'b1111001;
			else if(hour%10==2)
				HEX4=7'b0100100;	
			else if(hour%10==3)
				HEX4=7'b0110000;
			else if(hour%10==4)
				HEX4=7'b0011001;
			else if(hour%10==5)
				HEX4=7'b0010010;
			else if(hour%10==6)
				HEX4=7'b0000010;	
			else if(hour%10==7)
				HEX4=7'b1111000;	
			else if(hour%10==8)
				HEX4=7'b0000000;
			else if(hour%10==9)
				HEX4=7'b0010000;
				
			if(hour/10==0)
				HEX5=7'b1000000;
			else if(hour/10==1)
				HEX5=7'b1111001;
			else if(hour/10==2)
				HEX5=7'b0100100;	
			else if(hour/10==3)
				HEX5=7'b0110000;
			else if(hour/10==4)
				HEX5=7'b0011001;
			else if(hour/10==5)
				HEX5=7'b0010010;
			else if(hour/10==6)
				HEX5=7'b0000010;	
			else if(hour/10==7)
				HEX5=7'b1111000;	
			else if(hour/10==8)
				HEX5=7'b0000000;
			else if(hour/10==9)
				HEX5=7'b0010000;		
	end
end		
endmodule
