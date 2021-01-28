module exp3_adder(A,B,CIN,RESULT,CARRY,OVERFLOW,ZERO);
	input [3:0] A;
	input [3:0] B;
	input CIN;
	output reg [3:0] RESULT;
	output reg CARRY,OVERFLOW,ZERO;
	reg [3:0] BC;
	parameter n=4;
	always @(*)
	begin
			BC=({n{CIN}}^B);
			{CARRY,RESULT}=A+BC+CIN;
			OVERFLOW=(A[3]==BC[3])&&(RESULT[3]!=A[3]);
			ZERO=~(|RESULT);
			CARRY=CARRY^CIN;
	end

endmodule
