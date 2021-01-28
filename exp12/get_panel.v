module get_panel(
	ps_data,
	fail,
	succ,
	mode,
	difficulty,
	is_start,
	clk,
	reset_n,
	cur_x_ascii,
	cur_y_ascii,
	username,
	color,
	ready,
	ascii_out
);

input[7:0] ps_data;//键盘传入的ascii码
input[9:0] cur_x_ascii;
input[9:0] cur_y_ascii;
input ready;//来自ps2_keyboard的信号
input fail;
input succ;
input clk;
input reset_n;

output reg[7:0] ascii_out;
output reg[1:0] mode;
output reg[3:0] difficulty;
output reg[23:0]username;
output reg[23:0] color;
output reg is_start;//是否开始游戏

wire[15:0] name_addr;
wire[7:0] panel_ascii;
wire[15:0] panel_addr;
wire[15:0] write_addr;

reg is_in1 = 0;
reg is_in2 = 0;
reg[7:0] ascii_data;
reg[15:0] offset;//切换不同界面的偏移量
reg[1:0] temp_mode;//暂存所选择的界面
reg[2:0] count;//当前输入用户名第几个字符
reg is_game_end;//游戏是否结束
reg username_flag;
reg out_ofg;//不在游戏中
reg temp_ready;

assign panel_addr = cur_x_ascii + cur_y_ascii * 70 + offset;//在all_panels中的位置
assign name_addr = cur_x_ascii + cur_y_ascii * 70;//用户名的地址

initial
begin
mode = 0;
difficulty = 0;
is_start = 0;
temp_mode = 0;
count = 0;
is_game_end = 0;
out_ofg = 1;
end

all_panels A(panel_addr, clk, panel_ascii);

always@(ps_data)
begin
scancode2ascii(ps_data, ascii_data);
end

always @ (name_addr)//显示用户名
begin
if (mode == 2'b01)//输入用户名界面
	begin
	case(name_addr)
	16'h480:
	ascii_out = username[7:0];
	16'h482:
	ascii_out = username[15:8];
	16'h484:
	ascii_out = username[23:16];
	default:
		ascii_out = panel_ascii;
			endcase
			end
else
ascii_out = panel_ascii;
end

always @ (clk)//给每一列分配不同颜色
	begin
	if (cur_y_ascii % 7 == 0)
		color = 24'hFF7F00;
	else if (cur_y_ascii % 7 == 1)
		color = 24'h0000FF;
	else if (cur_y_ascii % 7 == 2)
		color = 24'h8B00FF;
	else if (cur_y_ascii % 7 == 3)
		color = 24'hFFFF00;
	else if (cur_y_ascii % 7 == 4)
		color = 24'h00FF00;
	else if (cur_y_ascii % 7 == 5)
		color = 24'hFF0000;
	else if (cur_y_ascii % 7 == 6)
		color = 24'h00FFFF;
		end

always @(posedge clk)//清零
		begin
			begin
			if (is_game_end && fail)//游戏失败
			begin
			if (ascii_data == 8'h08||ascii_data==8'h0D)//backspace or enter
			is_game_end = 1'b0;
			offset = 16'h20d0;//失败界面
			end
			else if (is_game_end && succ)//游戏成功
			begin
			if (ascii_data == 8'h08||ascii_data==8'h0D)//backspace or enter
			is_game_end = 1'b0;
			offset = 16'h2904;//成功界面
			end
			else
			begin
			if (mode == 2'b11)
				offset = 16'h1068;//无尽模式
			else if (mode == 2'b0)
				offset = 16'h0;//开始界面
			else if (mode == 2'b10)
				offset = 16'h834;//闯关模式
			else
			offset = 16'h189c;//输入用户名
			end
		end
		if (!reset_n)
		begin
		mode = 0;
		difficulty = 0;
		is_start = 0;
		temp_mode = 0;//用于用户名输入界面的暂存
		count = 0;//上限为3，记录当前输入用户名第几个字符
		is_game_end = 0;
		out_ofg = 1;
		end
else if (reset_n && ascii_data != 0)//键盘输入不为0
begin
if (succ == 1'b1)//游戏成功，闯关模式
	begin
	out_ofg = 1;
	is_start = 1'b0;
	is_game_end = 1;
	if (ascii_data == 8'h08)//backspace
		begin
		mode = 2'b0;//返回开始界面
		difficulty = 0;
		end
	else if (ascii_data == 8'h0D)//enter
		mode = 2'b11;//返回模式选择
		end
		
	else if (fail == 1'b1)//游戏失败
		begin
		out_ofg = 1;
		is_start = 1'b0;
		is_game_end = 1;

		if (mode == 2'b10&&ascii_data==8'h08)//无尽模式，backspace
			begin
			mode = 2'b0;//返回开始界面
			difficulty = 0;
		end

		else if (mode == 2'b11)//闯关模式
			begin
			if (ascii_data == 8'h08)//backspace
				begin
				mode = 2'b0;//返回开始界面
				difficulty = 0;
				end
			else if (ascii_data == 8'h0D)//enter
				begin
				mode = 2'b11;//返回模式选择
				difficulty = 0;
				end
				end


			else//其他状态，默认返回主页面
				begin
				mode = 2'b0;
				difficulty = 4'b0;
				end
				end

		else if (reset_n && ascii_data != 0 && is_game_end == 0)//键盘输入不为0,且游戏没结束
				begin
				if (mode == 2'b11&&(out_ofg==1))//闯关模式难度选择界面
					begin
					case(ascii_data)
					8'h08://backspace
					begin
					difficulty = 4'h0;
					is_start = 1'b0;
					mode = 2'b0;
					end
					8'h31:
					begin
					difficulty = 4'h1;
					is_start = 1'b1;
					out_ofg = 0;
					end
					8'h32:
					begin
					difficulty = 4'h2;
					is_start = 1'b1;
					out_ofg = 0;
					end
					8'h33:
					begin
					difficulty = 4'h3;
					is_start = 1'b1;
					out_ofg = 0;
					end
					8'h34:
					begin
					difficulty = 4'h4;
					is_start = 1'b1;
					out_ofg = 0;
					end
					8'h35:
					begin
					difficulty = 4'h5;
					is_start = 1'b1;
					out_ofg = 0;
					end
					8'h36:
					begin
					difficulty = 4'h6;
					is_start = 1'b1;
					out_ofg = 0;
					end
					8'h37:
					begin
					difficulty = 4'h7;
					is_start = 1'b1;
					out_ofg = 0;
					end
					8'h38:
					begin
					difficulty = 4'h8;
					is_start = 1'b1;
					out_ofg = 0;
					end
					default:
						begin
							difficulty = 4'h0;
							out_ofg = 1'b0;
							end
							endcase
							end


				else if (mode == 2'b10&&(out_ofg==1))//无尽模式难度选择界面
					begin
					case(ascii_data)
					8'h08://backspace
					begin
					difficulty = 4'b0;
					is_start = 1'b0;
					mode = 2'b0;
					end
					8'h31://1
					begin
					difficulty = 4'h1;
					is_start = 1'b1;//开始游戏
					out_ofg = 0;
end
8'h32://2
begin
difficulty = 4'h2;
is_start = 1'b1;
out_ofg = 0;
end
8'h33://3
begin
difficulty = 4'h3;
is_start = 1'b1;
out_ofg = 0;
end
					default:
						begin
							difficulty = 4'h0;
							out_ofg = 1'b0;
							end
							endcase
							end
							end

				else if (mode == 2'b0&&(out_ofg==1))//开始界面
					begin
					if (ascii_data == 8'h31)//1
						begin
						temp_mode = 2'b10;
						mode = 2'b1;
						end
					else if (ascii_data == 8'h32)//2
						begin
						temp_mode = 2'b11;
						mode = 2'b1;
						end//暂存所选的模式，并且先进入输入用户名的界面
						username_flag = 0;
						end
					else if (out_ofg == 1)//输入用户名界面
						begin
						if (ascii_data == 8'h0D)//enter
							//实现用户名输入
							mode = temp_mode;//切换到所选的界面
							end

							begin//输入名字
							if (mode == 2'b1)
								begin
								if (ascii_data != 8'h0D&&username_flag==1&&temp_ready==0&&ready==1&&is_in1==0)
									is_in1 = 1;
								else if (ascii_data != 8'h0D&&username_flag==1&&temp_ready==0&&ready==1&&is_in1==1
									&& ((ascii_data >= 8'h41&&ascii_data<=8'h5A) || ascii_data == 8'h00))
										begin
										if (count < 3'b11)//计数，输入三个字符
											begin
											if (count == 3'b0)
												username[7:0] = ascii_out;
											else if (count == 3'b1)
												username[15:8] = ascii_out;
											else if (count == 3'b10)
												begin username[23:16] = ascii_out; is_in1 = 0; end
												end
											else
												begin
												username_flag = 0;
												count = 0;
												username[7:0] = ascii_out;
												end
												count = count + 1;
												end
										else
												username_flag = 1;
end
end

temp_ready = ready;
end
end

task scancode2ascii;
input[7:0] scan_code;
output reg[7:0] ascii;
begin
case(scan_code)
	8'h2e : ascii = 8'h25;
	8'h36 : ascii = 8'h5e;
	8'h3d : ascii = 8'h26;
	8'h3e : ascii = 8'h2a;
	8'h46 : ascii = 8'h28;
	8'h45 : ascii = 8'h29;
	8'h4e : ascii = 8'h5f;
	8'h55 : ascii = 8'h2b;
	8'h5d : ascii = 8'h7c;
	8'h03 : ascii = 8'h74;
	8'h0b : ascii = 8'h75;
	8'h83 : ascii = 8'h76;
	8'h0a : ascii = 8'h77;
	8'h09 : ascii = 8'h79;
	8'h78 : ascii = 8'h7a;
	8'h01 : ascii = 8'h5F;
	8'h76 : ascii = 8'h1b;
	8'h05 : ascii = 8'h70;
	8'h06 : ascii = 8'h71;
	8'h04 : ascii = 8'h72;
	8'h0c : ascii = 8'h73;
	8'h07 : ascii = 8'h7b;
	8'h0e : ascii = 8'h7e;
	8'h16 : ascii = 8'h21;
	8'h1e : ascii = 8'h40;
	8'h26 : ascii = 8'h23;
	8'h25 : ascii = 8'h24;
	8'h66 : ascii = 8'h08;
	8'h0d : ascii = 8'h09;
	8'h15 : ascii = 8'h51;
	8'h1d : ascii = 8'h57;
	8'h24 : ascii = 8'h45;
	8'h2d : ascii = 8'h52;
	8'h2c : ascii = 8'h54;
	8'h35 : ascii = 8'h59;
	8'h3c : ascii = 8'h55;
	8'h43 : ascii = 8'h49;
	8'h44 : ascii = 8'h4f;
	8'h4d : ascii = 8'h50;
	8'h54 : ascii = 8'h7b;
	8'h2a : ascii = 8'h56;
	8'h32 : ascii = 8'h42;
	8'h31 : ascii = 8'h4e;
	8'h3a : ascii = 8'h4d;
	8'h41 : ascii = 8'h3c;
	8'h49 : ascii = 8'h3e;
	8'h4a : ascii = 8'h3f;
	8'h59 : ascii = 8'h10;
	8'h14 : ascii = 8'h11;
	8'h11 : ascii = 8'h12;
	8'h42 : ascii = 8'h4b;
	8'h4b : ascii = 8'h4c;
	8'h5b : ascii = 8'h7d;
	8'h5a : ascii = 8'h0d;
	8'h58 : ascii = 8'h14;
	8'h1c : ascii = 8'h41;
	8'h1b : ascii = 8'h53;
	8'h23 : ascii = 8'h44;
	8'h2b : ascii = 8'h46;
	8'h34 : ascii = 8'h47;
	8'h33 : ascii = 8'h48;
	8'h3b : ascii = 8'h4a;
	8'h4c : ascii = 8'h3a;
	8'h52 : ascii = 8'h22;
	8'h12 : ascii = 8'h10;
	8'h1a : ascii = 8'h5a;
	8'h22 : ascii = 8'h58;
	8'h21 : ascii = 8'h43;
	8'h29 : ascii = 8'h20;
	default: ascii = 8'h00;
	endcase
end
endtask
endmodule
