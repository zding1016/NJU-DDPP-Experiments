module GameUI(
	input clk,                  //50MHz
	input[4:0] h_ascii, 	    //20*30游戏侧边栏横坐标
	input[4:0] v_ascii,        //20*30游戏侧边栏纵坐标
	input[23:0] username,      //游戏玩家名
	input[3:0] life,           //生命值
	input[9:0] score,          //游戏分数
	input[9:0] target,         //目标分数
	input[9:0] speed,          //字符下滑速度
	input mode,             //游戏模式（无尽/生存）

	output reg[7:0] cur_ascii	 //当前需要显示的ascii
);


//将二维地址转换为一维的线性地址
//相当于：v_ascii * 20 + h_ascii 使用移位减少运算时间
wire[11:0] rom_addr;     //20*30侧边栏地址
wire[7:0] rom_ascii;        //20*30rom中读出的数据
wire[7:0] ascii_score0; //个位
wire[7:0] ascii_score1; //十位
wire[7:0] ascii_score2; //百位
wire[7:0] ascii_life;//剩余生命次数
wire[7:0] ascii_target0; //个位
wire[7:0] ascii_target1; //十位
wire[7:0] ascii_target2; //百位
wire[7:0] ascii_speed0; //下落速度值各个位的ascii，个位
wire[7:0] ascii_speed1; //十位
wire[7:0] ascii_speed2; //百位

assign ascii_life = (!mode) ? (8'h02) : (life + 8'h30); //无穷/有限
assign rom_addr = (v_ascii << 4) + (v_ascii << 2) + h_ascii; //20*30侧边栏地址
assign ascii_score0 = (score % 10) + 8'h30;
assign ascii_score1 = ((score / 10) % 10) + 8'h30;
assign ascii_score2 = (score / 100) + 8'h30;
assign ascii_target0 = (target % 10) + 8'h30;//目标得分各个位的ascii
assign ascii_target1 = ((target / 10) % 10) + 8'h30;
assign ascii_target2 = (target / 100) + 8'h30;
assign ascii_speed0 = (speed % 10) + 8'h30;
assign ascii_speed1 = ((speed / 10) % 10) + 8'h30;
assign ascii_speed2 = (speed / 100) + 8'h30;

Game_UI_Info my_GameUI_Info(rom_addr, clk, rom_ascii); //读取侧边栏中当前字符的ascii

always @(*)
begin
case(rom_addr)
12'h238: cur_ascii = ascii_speed2;
12'h239: cur_ascii = ascii_speed1;
12'h23a: cur_ascii = ascii_speed0;
12'h138: cur_ascii = ascii_life;
12'h199: cur_ascii = ascii_score2;
12'h19a: cur_ascii = ascii_score1;
12'h19b: cur_ascii = ascii_score0;
12'h211: cur_ascii = ascii_target2;
12'h212: cur_ascii = ascii_target1;
12'h213: cur_ascii = ascii_target0;
12'h0e4: cur_ascii = username[7:0];
12'h0e6: cur_ascii = username[15:8];
12'h0e8: cur_ascii = username[23:16];
default: cur_ascii = rom_ascii;

endcase
end

endmodule
