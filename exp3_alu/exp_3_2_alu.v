module exp_3_2_alu(KEY,SW,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
	input 		     	  [2:0]		KEY;//OPTION
	input 		    	  [7:0]		SW;//NUM
	output		reg     [6:0]		HEX0;//s0
	output		reg     [6:0]		HEX1;//s1
	output		reg     [6:0]		HEX2;//s2
	output		reg     [6:0]		HEX3;//s3
	output		reg     [6:0]		HEX4;//CARRY
	output		reg     [6:0]		HEX5;//OVERFLOW
	reg [3:0] RESULT;
	reg CARRY,OVERFLOW;
	integer i;
	reg [3:0] A,B,BC;
	always @(*)
	begin
	CARRY=0;
	OVERFLOW=0;
	for(i=0;i<=3;i=i+1)
		B[i]=SW[i];
	for(i=0;i<=3;i=i+1)
		A[i]=SW[i+4];	
	if(KEY==3'b000)//add
		begin
			{CARRY,RESULT}=A+B;
			OVERFLOW=(A[3]==B[3])&&(RESULT[3]!=A[3]);
		end
	else if(KEY==3'b001)//minus
		begin
			BC=(4'b1111^B);
			{CARRY,RESULT}=A+BC+1;
			OVERFLOW=(A[3]==BC[3])&&(RESULT[3]!=A[3]);
			CARRY=~CARRY;
		end
		else if(KEY==3'b010)//NOT A
		begin
				RESULT=~A;
		end
		else if(KEY==3'b011)//A AND B
		begin
				RESULT=A&B;
		end
		else if(KEY==3'b100)//A OR B
		begin
				RESULT=A|B;
		end
		else if(KEY==3'b101)//A XOR B
		begin
				RESULT=A^B;
		end
		else if(KEY==3'b110)//COMPARE
		begin
				if(A[3]==B[3] && A>B|A[3]==0 && B[3]==1 )
					RESULT=1;
				else 
					RESULT=0;
		end
		else//EQUAL?
		begin
				if(A==B)
					RESULT=1;
				else RESULT=0;
		end
	if(RESULT[0]==0)
	HEX0=7'b1000000;
	else 
		HEX0=7'b1111001;
	if(RESULT[1]==0)
	HEX1=7'b1000000;
	else 
		HEX1=7'b1111001;	
	if(RESULT[2]==0)
	HEX2=7'b1000000;
	else 
		HEX2=7'b1111001;	
	if(RESULT[3]==0)
	HEX3=7'b1000000;
	else 
		HEX3=7'b1111001;	
	if(CARRY==0)
	HEX4=7'b1000000;
	else 
		HEX4=7'b1111001;
	if(OVERFLOW==0)
	HEX5=7'b1000000;
	else 
		HEX5=7'b1111001;	
	end	
endmodule
