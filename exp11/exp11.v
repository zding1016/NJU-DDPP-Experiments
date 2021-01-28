module exp11(clk,clrn,ps2_clk,ps2_data,ready,overflow,capslock_flag,shift_flag,
HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,
hsync, // 行 同 步 和 列 同 步 信 号
vsync,
valid, //消隐信号
vgn_sync_n,
vga_clk,
vga_r, // 红 绿 蓝 颜 色 信 号
vga_g,
vga_b);

	input clk,clrn,ps2_clk,ps2_data;
	output overflow; // fifo overflow
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;
	output ready;
	output capslock_flag;
	output shift_flag;
	
	output hsync; // 行 同 步 和 列 同 步 信 号
	output vsync;
	output valid; //消隐信号
	output vgn_sync_n;
	output vga_clk;
	output [7:0] vga_r; // 红 绿 蓝 颜 色 信 号
	output [7:0] vga_g;
	output [7:0] vga_b;
	
	wire [7:0] ascii;
	wire if_press;
	wire if_back;
	wire if_enter;
	
	exp8 Input (clk,clrn,ps2_clk,ps2_data,ready,overflow,capslock_flag,shift_flag,
HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,ascii,if_press);

	exp9_2 OUT_PUT(clk,hsync, vsync, valid, vgn_sync_n, vga_clk, vga_r, vga_g, vga_b,ascii,if_press,if_back,if_enter);

endmodule
