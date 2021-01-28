module exp8(clk,clrn,ps2_clk,ps2_data,ready,overflow,capslock_flag,shift_flag,
HEX0,HEX1,HEX2,HEX3,HEX4,HEX5, ascii_out,cnt,if_press,if_back,if_enter);
	
	input clk,clrn,ps2_clk,ps2_data;
	output overflow; // fifo overflow
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;
	output ready;
	output [7:0] ascii_out;
	output [7:0] cnt;
	
	output reg capslock_flag;
	output reg shift_flag;
	output reg if_press;
	output reg if_back;
	output reg if_enter;
	
	reg [7:0] data_out;//store the data
	reg nextdata_n;
	reg [7:0] count;
	reg pre;//if the previous input is 8'hf0
	reg capslock;
	reg shift;
	reg tmp;
	
	wire [7:0] ascii;
	wire [7:0] data;//get the data from keyboard
	wire [7:0] asciiii;
	wire clk_N;
	
	assign ascii_out=asciiii;
	assign cnt=count;
	
initial
	begin
	pre=1;
	count=0;
	capslock_flag=0;
	shift_flag=0;
	capslock=0;
	shift=0;
	nextdata_n=1;
	tmp=0;
	if_press=0;
	end
	
 always @ (posedge clk_N)
	begin
	if(ready==1)
		begin
		
			if(data[7:0]==8'h12||data[7:0]==8'h59)//shift
			begin
				if(pre==1&&shift_flag==0)
				begin
					shift=1;
					shift_flag=1;
					if_press=1;
				end
				else if(pre==0)
				begin
					shift_flag=0;
					shift=0;
					if_press=0;
				end
			end
			
			else if(data[7:0]==8'h58)//capslock
			begin
				if(pre==1&&capslock_flag==0)
				begin
					capslock=1;
					capslock_flag=1;
					if_press=1;
				end
				else if(pre==0&&capslock_flag==1&&tmp==0)
					tmp=1;
				else if(pre==0&&capslock_flag==1&&tmp==1)	
				begin
					capslock=0;
					capslock_flag=0;
					tmp=0;
					if_press=0;
				end
			end
			else if(data[7:0]==8'h66)//back
			begin
				if(pre==1)
					if_back=1;
				else if(pre==0)
					if_back=0;
			end
			else if(data[7:0]==8'h5a)//enter
			begin
				if(pre==1)
					if_enter=1;
				else if(pre==0)
					if_enter=0;
			end
			
			if(pre==1&&data[7:0]!=8'hf0)//ordinary input
				begin
				data_out=data;
				if_press=1;
				end
			else if(data[7:0]==8'hf0)//end of input
			begin
				data_out=data;
				pre=0;
				if_press=0;
			end
			else if(pre==0)
			begin
				pre=1;
			end
			nextdata_n=0;
			count=(count+1)%99;
		end
		
		else 
		begin
			nextdata_n<=1;
		end		
	end
	
 div_N A (clk,clk_N);
 ps2_keyboard B (clk,clrn,ps2_clk,ps2_data,data,ready,nextdata_n,overflow);
 process C (data_out,ascii);
 display_panel D (data_out,pre,ascii,count,capslock,shift,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,asciiii);

 endmodule
