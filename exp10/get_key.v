module get_key(clk, ps2_clk, data_in, freq);
	input clk, ps2_clk, data_in;
	output reg [15:0] freq;
	
	wire clk_div, ready, overflow;
	wire [7:0] data_out;
	
	reg nextdata_n, pre;
	reg harmo_flag;
	reg [15:0] harmo;
	initial
	begin
		nextdata_n = 1;
		pre = 1;
		harmo_flag=0;
		harmo=0;
	end

	div_N A (clk, clk_div);
	ps2_keyboard B (clk, 1, ps2_clk, data_in, data_out, ready, nextdata_n, overflow);
	
always @(posedge clk_div)
	begin
		if (ready==1)
		begin
			if(pre==1&&harmo_flag==0)
			begin
				case(data_out)
					8'h15: harmo = 523.25;
					8'h1d: harmo = 587.33;
					8'h24: harmo = 659.26;
					8'h2d: harmo = 698.46;
					8'h2c: harmo = 783.99;
					8'h35: harmo = 880;
					8'h3c: harmo = 987.77;
					8'h43: harmo = 1046.5;
					default: harmo = 0;
				endcase
				if(harmo!=0)
					harmo_flag=1;
			end
			else if(pre==0&&harmo_flag==1)
			begin
				harmo_flag=0;
				harmo=0;
			end
			
			if (pre==1 && data_out[7:0]!=8'hf0)
			begin
				case(data_out)
					8'h15: freq = 523.25;
					8'h1d: freq = 587.33;
					8'h24: freq = 659.26;
					8'h2d: freq = 698.46;
					8'h2c: freq = 783.99;
					8'h35: freq = 880;
					8'h3c: freq = 987.77;
					8'h43: freq = 1046.5;
					default: freq = 0;
				endcase
				if(harmo_flag==1&&(freq!=harmo))
					begin
					freq=(freq+harmo)/2;
					end
				freq=freq*65536/48000;
			end
			else if(data_out[7:0]==8'hf0)
					pre=0;
			else if(pre==0)    
			begin
				pre=1;
				freq=0;
			end
			
			nextdata_n=0;
		end
		else
			nextdata_n=1;
	end
endmodule
