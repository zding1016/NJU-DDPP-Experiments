module exp2(x,y,z0,z1,z2,z3,f);
	input [7:0] x;
	output reg [2:0] y;
	output reg [6:0] z0;
	output reg [6:0] z1;
	output reg [6:0] z2;
	output reg [6:0] z3;
	output reg[6:0] f;
	integer i;
	always @(*)
	begin
		y=0;
		for(i=0;i<=7;i=i+1)
			if(x[i]==1)
			y=i;
	if(x==0)
		z3=7'b1000000;
	else 
		z3=7'b1111001;
	if(y[0]==0)
		z0=7'b1000000;
	else 
		z0=7'b1111001;
	if(y[1]==0)
		z1=7'b1000000;
	else 
		z1=7'b1111001;
	if(y[2]==0)
		z2=7'b1000000;
	else 
		z2=7'b1111001;	
		
	if(z3==7'b1000000)
		f=7'b1000000;
	else
		begin
			if(z0==7'b1000000&&z1==7'b1000000&&z2==7'b1000000)
				f=7'b1000000;
			else if(z0==7'b1111001&&z1==7'b1000000&&z2==7'b1000000)
				f=7'b1111001;
			else if(z0==7'b1000000&&z1==7'b1111001&&z2==7'b1000000)
				f=7'b0100100;	
			else if(z0==7'b1111001&&z1==7'b1111001&&z2==7'b1000000)
				f=7'b0110000;
			else if(z0==7'b1000000&&z1==7'b1000000&&z2==7'b1111001)
				f=7'b0011001;
			else if(z0==7'b1111001&&z1==7'b1000000&&z2==7'b1111001)
				f=7'b0010010;
			else if(z0==7'b1000000&&z1==7'b1111001&&z2==7'b1111001)
				f=7'b0000010;	
			else if(z0==7'b1111001&&z1==7'b1111001&&z2==7'b1111001)
				f=7'b1111000;		
		end
	end
endmodule

