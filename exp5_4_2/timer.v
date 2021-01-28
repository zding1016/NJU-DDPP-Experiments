module timer(CLK, en, pause, clr, HEX0, HEX1,HEX2,HEX3,HEX4,HEX5);
 input CLK;
 input pause;
 input clr;
 input en;
 output reg [6:0] HEX0;
 output reg [6:0] HEX1;
 output reg [6:0] HEX2;
 output reg [6:0] HEX3;
 output reg [6:0] HEX4;
 output reg [6:0] HEX5;
 reg [10:0] minsec=0;
 reg [7:0] sec=0;
 reg [7:0] min=0;
 always @ (posedge CLK)
	begin
	if(!en)
		minsec<=minsec;
	else
		begin
			if(clr==1)
				minsec<=0;
			else
			begin
			if(pause)
			begin
				minsec<=minsec;
				sec<=sec;
				min<=min;
			end
			else
				begin
				minsec<=minsec+1;
				if(minsec==99&&sec==59)
					begin
					min<=min+1;
					minsec<=0;
					sec=0;
					end
				else if(minsec==99)
					begin
					minsec<=0;
					sec=sec+1;
					end
				else
					minsec<=minsec+1;
				end
			end
		end	
	end
 always @(*)
 begin
			if(minsec%10==0)
				HEX0=7'b1000000;
			else if(minsec%10==1)
				HEX0=7'b1111001;
			else if(minsec%10==2)
				HEX0=7'b0100100;	
			else if(minsec%10==3)
				HEX0=7'b0110000;
			else if(minsec%10==4)
				HEX0=7'b0011001;
			else if(minsec%10==5)
				HEX0=7'b0010010;
			else if(minsec%10==6)
				HEX0=7'b0000010;	
			else if(minsec%10==7)
				HEX0=7'b1111000;	
			else if(minsec%10==8)
				HEX0=7'b0000000;
			else if(minsec%10==9)
				HEX0=7'b0010000;
				
			if(minsec/10==0)
				HEX1=7'b1000000;
			else if(minsec/10==1)
				HEX1=7'b1111001;
			else if(minsec/10==2)
				HEX1=7'b0100100;	
			else if(minsec/10==3)
				HEX1=7'b0110000;
			else if(minsec/10==4)
				HEX1=7'b0011001;
			else if(minsec/10==5)
				HEX1=7'b0010010;
			else if(minsec/10==6)
				HEX1=7'b0000010;	
			else if(minsec/10==7)
				HEX1=7'b1111000;	
			else if(minsec/10==8)
				HEX1=7'b0000000;
			else if(minsec/10==9)
				HEX1=7'b0010000;
			
			if(sec%10==0)
				HEX2=7'b1000000;
			else if(sec%10==1)
				HEX2=7'b1111001;
			else if(sec%10==2)
				HEX2=7'b0100100;	
			else if(sec%10==3)
				HEX2=7'b0110000;
			else if(sec%10==4)
				HEX2=7'b0011001;
			else if(sec%10==5)
				HEX2=7'b0010010;
			else if(sec%10==6)
				HEX2=7'b0000010;	
			else if(sec%10==7)
				HEX2=7'b1111000;	
			else if(sec%10==8)
				HEX2=7'b0000000;
			else if(sec%10==9)
				HEX2=7'b0010000;
				
			if(sec/10==0)
				HEX3=7'b1000000;
			else if(sec/10==1)
				HEX3=7'b1111001;
			else if(sec/10==2)
				HEX3=7'b0100100;	
			else if(sec/10==3)
				HEX3=7'b0110000;
			else if(sec/10==4)
				HEX3=7'b0011001;
			else if(sec/10==5)
				HEX3=7'b0010010;
			else if(sec/10==6)
				HEX3=7'b0000010;	
			else if(sec/10==7)
				HEX3=7'b1111000;	
			else if(sec/10==8)
				HEX3=7'b0000000;
			else if(sec/10==9)
				HEX3=7'b0010000;
				
			if(min%10==0)
				HEX4=7'b1000000;
			else if(min%10==1)
				HEX4=7'b1111001;
			else if(min%10==2)
				HEX4=7'b0100100;	
			else if(min%10==3)
				HEX4=7'b0110000;
			else if(min%10==4)
				HEX4=7'b0011001;
			else if(min%10==5)
				HEX4=7'b0010010;
			else if(min%10==6)
				HEX4=7'b0000010;	
			else if(min%10==7)
				HEX4=7'b1111000;	
			else if(min%10==8)
				HEX4=7'b0000000;
			else if(min%10==9)
				HEX4=7'b0010000;
				
			if(sec/10==0)
				HEX5=7'b1000000;
			else if(min/10==1)
				HEX5=7'b1111001;
			else if(min/10==2)
				HEX5=7'b0100100;	
			else if(min/10==3)
				HEX5=7'b0110000;
			else if(min/10==4)
				HEX5=7'b0011001;
			else if(min/10==5)
				HEX5=7'b0010010;
			else if(min/10==6)
				HEX5=7'b0000010;	
			else if(min/10==7)
				HEX5=7'b1111000;	
			else if(min/10==8)
				HEX5=7'b0000000;
			else if(min/10==9)
				HEX5=7'b0010000;		
 end
endmodule
