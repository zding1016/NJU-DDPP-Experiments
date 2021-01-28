module GamePlaying(
	input clk,                    //50MHz
	input reset,                  //高电平停止滚屏
	input[6:0] h_ascii, 	      //30*70的横坐标
	input[9:0] v_addr,           //480*630像素点的纵坐标
	input[7:0] scancode,	      //键盘输入字符的扫描码
	input mode,               //游戏模式（无尽/生存）
	input[3:0] difficulty,        //游戏难度值
	input start,              //游戏开始
	input restart,            //状态重置
	input ready,              //有按键松开

	output[3:0] v_font,          //16*9字模内的行数
	output[7:0] cur_ascii,	      //当前需要显示的ascii

	output fail,                  //游戏失败
	output succ,                  //游戏成功

	output reg[9:0] target,      //目标分数
	output reg[9:0] speed,  //字符下滑速度
	output[3:0] left_life,        //生命值
	output reg[9:0] score        //游戏分数
);

initial
begin
stage = 0;
score = 0;
life = 9;
offset = 0;
newascii = 0;
wren = 0;
random_addr = 0;
num_max = 1;
clean = 0;
clean_count = 0;
speed = 50;
restart2 = 0;
ready2 = 0;
end

//游戏界面相关屏幕参数
parameter max_col = 50; //横向50个字符
parameter max_row = 31; //纵向31个字符行（多一个是用于产生新的随机字符）
parameter pixel_line = max_row * 16; //纵向31*16个像素行

wire clk_5s;
wire[9:0] random_speed;
wire clk_offset;//Clock for offset changing
wire[4:0] v_ascii;
wire[9:0] Now_v_addr;//计算带上偏移量后的v_addr
wire[4:0] NowLine;//即将进入屏幕的那个字符行
wire[10:0] read_addr;        //31*50RAM的读地址
wire[10:0] write_addr;       //31*50RAM的写地址
wire[10:0] read_addr2;      //31*50RAM的读地址
wire[7:0] cur_ascii2;        //从31*50RAM读取的数据值
wire[3:0] newLine;//用于产生新的随机行
wire[3:0] random_num;//生成随机数
wire[6:0] random_col;
wire[7:0] random_ascii;
wire[6:0] random_col64;

//键盘按下，KEYCLEAN状态
reg[7:0] keyascii; //将要清除的字符的ascii码
reg clean; //字符清除状态
reg[10:0] clean_addr; //31*50清除字符所在地址
reg[31:0] clean_count; //处于GO_CLEAN的时钟周期数
reg life_deduct; //为真时表示错过了字符，应当life减少
reg[3:0] newLine2;
reg restart2;
reg ready2;
reg[9:0] random_addr; //读随机表的地址
reg[6:0] random_count; //记录对新行随机写入的次数
reg[6:0] num_max; //写入新行时的最大字符数
reg[3:0] life; //生命值
reg key_matched = 0;//是否匹配到输入字符
reg[8:0] offset; //偏移量
reg[7:0] newascii;           //准备写入31*50RAM的数据值
reg wren;	 
reg[6:0] col_index; 
reg[3:0] stage; 
  
assign fail = ((!mode) ? (0) : (life == 0)) || keyascii == 8'h08; //无尽模式下生命值无限
assign succ = (score >= target) || restart; //可通过按钮 手动“胜利”
assign left_life = (life <= 9) ? (life) : (0); //控制只显示 0~9 的生命值
assign Now_v_addr = pixel_line + v_addr - offset; //偏移后的像素点纵坐标，利用Now_v_addr计算访问RAM的位置以及字符地址:
assign v_ascii = (Now_v_addr % pixel_line) >> 4; //30*70的纵坐标
assign read_addr = v_ascii * max_col + h_ascii; //31*50RAM的读地址
assign v_font = Now_v_addr & 4'b1111; //16*9字模内的行数
assign NowLine = (pixel_line - offset) >> 4; //再%pixel_line？
assign newLine = offset[3:0];
assign random_col = (random_col64) % max_col;
assign write_addr = (stage == KEYCLEAN || stage == GAMERESET) ? (clean_addr) : (NowLine * max_col + col_index);//KEYCLEAN状态下，利用上一次读出的数据，决定要不要写0，所以应该和读的上一次的地址保持一致
assign read_addr2 = (stage == KEYCLEAN || stage == GAMERESET) ? (clean_addr) : (write_addr);


clk_second my_clk_second(clk,reset,~reset,clk_5s);

clk_speed my_clk_speed(clk,reset,~reset,speed,clk_offset);//Change offset

random8Bits my_random8Bits2(random_addr, clk_5s, random_speed);//模式、难度值的翻译：
           
Gameascii my_game_ascii1(clk,newascii,read_addr,write_addr,wren,cur_ascii); //写使能

Gameascii my_game_ascii2(clk,newascii,read_addr,write_addr,wren,cur_ascii);//RAM显存,写操作与1号完全一致，而读操作是独立的，目的是增加一个自由读出的端口

random8Bits my_random8Bits(random_addr, clk, random_num);

random64 my_random64(random_addr, clk, random_col64);

randomascii my_randomascii(random_addr, clk, random_ascii);

always @(*) begin
target = 599;
	if (!mode) begin //无尽模式
	case(difficulty) //分别为：每行最大字符数、移动频率（以每个像素点为单位）
	4'h1:    begin num_max = random_num & 4'b0011; speed = 10 + random_speed % 20;  target = 40;  end
	4'h2:    begin num_max = random_num & 4'b0011; speed = 10 + random_speed % 40;  target = 70;  end
	4'h3:    begin num_max = random_num & 4'b0011; speed = 10 + random_speed % 60;  target = 100; end

	default: begin num_max = random_num & 4'b0011; speed = 100;                                 end
		endcase
	end
else begin //闯关模式
	case(difficulty) //分别为：每行最大字符数、移动频率（以每个像素点为单位）、目标分数
	4'h1:    begin num_max = random_num & 4'b0011; speed = 10 + random_speed % 5;   target = 30;  end
	4'h2:    begin num_max = random_num & 4'b0011; speed = 10 + random_speed % 10;  target = 40;  end
	4'h3:    begin num_max = random_num & 4'b0011; speed = 10 + random_speed % 15;  target = 50;  end
	4'h4:    begin num_max = random_num & 4'b0011; speed = 10 + random_speed % 20;  target = 70;  end
	4'h5:    begin num_max = random_num & 4'b0011; speed = 10 + random_speed % 30;  target = 90;  end
	4'h6:    begin num_max = random_num & 4'b0011; speed = 10 + random_speed % 40;  target = 110; end
	4'h7:    begin num_max = random_num & 4'b0011; speed = 10 + random_speed % 50;  target = 130; end
	4'h8:    begin num_max = random_num & 4'b0011; speed = 10 + random_speed % 60;  target = 150; end

	default: begin num_max = random_num & 4'b0011; speed = 25;  target = 30;                    end
		endcase
	end
end


always @(posedge clk_offset)
begin
if (offset < pixel_line)
	offset = offset + 1;
else
offset = 0;
end



localparam WAITING = 0;  			   //待机
localparam LINECLEAN = 1;  	      //准备产生新行，先清空一行
localparam CREATENEW = 2;				//在清空的行中，随机写入值
localparam KEYCLEAN = 3;				//接受的键盘键松开的信号，消字符
localparam GAMERESET = 4;				//将IP核RAM的所有内容清为0

//不断产生新的行的状态机 （带2的变量都是备份上一时钟沿时的值）		
always @(negedge clk)
begin

//设置clean_count，对处于clean状态的时钟沿个数计数
//目的是避免长时间陷入clean的死循环，导致状态机失效
if (clean) begin
clean_count = clean_count + 1;
end

if (clean_count >= 10 * max_col * max_row) begin
clean = 0;
clean_count = 0;
end

//ready是来自键盘模块的信号，此处说明有按键松开
if ((!clean) && (!ready2) && (ready)) begin
scancode2ascii(scancode, keyascii);//将扫描码翻译成ascii码
clean = 1;
end


case(stage) //此处每个状态进入下一个状态前，都会预先准备好一次下个的状态的参量

//先清空 即将移入屏幕的那一行
LINECLEAN : begin
if (cur_ascii2 != 0) begin //清空的值不是0  说明 漏掉字符没消除，生命值-1
	life_deduct = 1;
end

if (col_index == max_col - 1) begin //清空结束，预先准备好随机写入一次需要的参数值
	if (life_deduct) begin
		life = life - 1;
		life_deduct = 0;
	end
	stage = CREATENEW;
	random_count = 0;
	col_index = random_col;
	newascii = random_ascii;
	if (random_count >= num_max) begin //控制随机写入的个数
		col_index = 0;
		wren = 0;
		stage = WAITING;
	end
	random_addr = random_addr + 1;
	end

else begin //保持本状态(继续清空本行)
	col_index = col_index + 1;
	end
end

//待机
WAITING: begin

	//保持本状态
	random_count = 0;
wren = 0;
clean_addr = 0;
if (newLine2 != newLine && newLine == 4'h1) begin //准备清空新行
	//预先清一次
	stage = LINECLEAN;
	newascii = 0;
	col_index = 0;
	life_deduct = 0;
	wren = 1;
	end

	if (clean && keyascii != 0) begin //键盘按下且松开(且对应ascii码不是0)
		stage = KEYCLEAN;
	wren = 0;
clean = 0;
clean_addr = 0;
end

//如果游戏未开始 或者 restart按下(0->1)，则需要保持重置状态
if (!start || (restart2 == 0 && restart == 1)) begin
stage = GAMERESET;
score = 0;
life = 9;
newascii = 0;
wren = 1;
clean = 0;
clean_addr = 0;
end

end

//接受到键盘键松开的信号，消字符
KEYCLEAN : begin
clean = 0;
if (wren == 0 && cur_ascii2 == keyascii) begin
//访问IP核发现了一个匹配的字符 开启写使能 保持地址不变，在下一个时钟沿写入0 即清除字符
	wren = 1;
	newascii = 0;
	score = score + 1;
	key_matched = 1;
	end
else begin//否则，地址加一，继续访问IP核
	wren = 0;
	clean_addr = clean_addr + 1;
	end

if (clean_addr >= max_col * max_row) begin
//访问地址达到上限 即可跳出本状态
if (key_matched == 1)
	key_matched = 0;
else
	life = life - 1;
	stage = WAITING;
	wren = 0;
	clean = 0;
	clean_addr = 0;
	clean_count = 0;
	end
end

//在清空的行中，随机写入字符
CREATENEW : begin
random_count = random_count + 1;
if (random_count >= num_max) begin //控制随机写入的个数
	stage = WAITING;
	col_index = 0;
	wren = 0;
	random_count = 0;
	end
else begin //保持本状态
	col_index = random_col;
	newascii = random_ascii;
	random_addr = random_addr + 1;
	end
end

//重置游戏：将IP核RAM的所有内容清为0
GAMERESET : begin
clean_addr = clean_addr + 1;
if (clean_addr >= max_col * max_row) begin
	stage = WAITING;
	wren = 0;
	clean_addr = 0;
	end
end

//默认状态：
default: begin
	stage = WAITING;
	wren = 0;
	clean = 0;
	life_deduct = 0;
end

endcase

//更新备份
newLine2 = newLine;
ready2 = ready;
restart2 = restart;

end
//状态机结束


task scancode2ascii;//将扫描码翻译成对应的ascii码，此处使用了大写字母（默认产生大写ascii）
input[7:0] scan_code;
output reg[7:0] ascii;
begin
case(scan_code)
	8'h1e : ascii = 8'h40;
	8'h26 : ascii = 8'h23;
	8'h49 : ascii = 8'h3e;
	8'h4a : ascii = 8'h3f;
	8'h59 : ascii = 8'h10;
	8'h0c : ascii = 8'h73;
	8'h03 : ascii = 8'h74;
	8'h0b : ascii = 8'h75;
	8'h83 : ascii = 8'h76;
	8'h0a : ascii = 8'h77;
	8'h09 : ascii = 8'h79;
	8'h78 : ascii = 8'h7a;
	8'h07 : ascii = 8'h7b;
	8'h0e : ascii = 8'h7e;
	8'h16 : ascii = 8'h21;
	8'h2c : ascii = 8'h54;
	8'h35 : ascii = 8'h59;
	8'h3c : ascii = 8'h55;
	8'h25 : ascii = 8'h24;
	8'h2e : ascii = 8'h25;
	8'h43 : ascii = 8'h49;
	8'h44 : ascii = 8'h4f;
	8'h4d : ascii = 8'h50;
	8'h54 : ascii = 8'h7b;
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
	8'h36 : ascii = 8'h5e;
	8'h3d : ascii = 8'h26;
	8'h3e : ascii = 8'h2a;
	8'h46 : ascii = 8'h28;
	8'h45 : ascii = 8'h29;
	8'h4e : ascii = 8'h5f;
	8'h04 : ascii = 8'h72;
	8'h52 : ascii = 8'h22;
	8'h12 : ascii = 8'h10;
	8'h1a : ascii = 8'h5a;
	8'h22 : ascii = 8'h58;
	8'h21 : ascii = 8'h43;
	8'h2a : ascii = 8'h56;
	8'h32 : ascii = 8'h42;
	8'h31 : ascii = 8'h4e;
	8'h3a : ascii = 8'h4d;
	8'h41 : ascii = 8'h3c;
	8'h42 : ascii = 8'h4b;
	8'h4b : ascii = 8'h4c;
	8'h4c : ascii = 8'h3a;
	8'h14 : ascii = 8'h11;
	8'h11 : ascii = 8'h12;
	8'h29 : ascii = 8'h20;
	8'h55 : ascii = 8'h2b;
	8'h5d : ascii = 8'h7c;
	8'h66 : ascii = 8'h08;
	8'h0d : ascii = 8'h09;
	8'h15 : ascii = 8'h51;
	8'h1d : ascii = 8'h57;
	8'h24 : ascii = 8'h45;
	8'h2d : ascii = 8'h52;
	8'h01 : ascii = 8'h5F;
	8'h76 : ascii = 8'h1b;
	8'h05 : ascii = 8'h70;
	8'h06 : ascii = 8'h71;
	default: ascii = 8'h00;
	endcase
end
endtask
endmodule

