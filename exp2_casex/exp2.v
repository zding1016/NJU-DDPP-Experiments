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
	casex(x)
	8'b1???????:begin y=7;z3=7'b1111001;end
	8'b01??????:begin y=6;z3=7'b1111001;end
	8'b001?????:begin y=5;z3=7'b1111001;end
	8'b0001????:begin y=4;z3=7'b1111001;end
	8'b00001???:begin y=3;z3=7'b1111001;end
	8'b000001??:begin y=2;z3=7'b1111001;end
	8'b0000001?:begin y=1;z3=7'b1111001;end
	8'b00000001:begin y=0;z3=7'b1111001;end
	8'b00000000:begin y=0;z3=7'b1000000;end
	default:begin y=0; z3=7'b1000000;end
	endcase
	
	case(y)
	0:begin z0=7'b1000000;z1=7'b1000000;z2=7'b1000000;end
	1:begin z0=7'b1111001;z1=7'b1000000;z2=7'b1000000;end
	2:begin z0=7'b1000000;z1=7'b1111001;z2=7'b1000000;end
	3:begin z0=7'b1111001;z1=7'b1111001;z2=7'b1000000;end
	4:begin z0=7'b1000000;z1=7'b1000000;z2=7'b1111001;end
	5:begin z0=7'b1111001;z1=7'b1000000;z2=7'b1111001;end
	6:begin z0=7'b1000000;z1=7'b1111001;z2=7'b1111001;end
	7:begin z0=7'b1111001;z1=7'b1111001;z2=7'b1111001;end
	default:begin z0=7'b1000000;z1=7'b1000000;z2=7'b1000000;end
	endcase
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

