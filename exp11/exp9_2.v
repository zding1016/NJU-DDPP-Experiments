module exp9_2( 
 input clk,
 output hsync, // 行 同 步 和 列 同 步 信 号
 output vsync,
 output valid, //消隐信号
 output vgn_sync_n,
 output vga_clk,
 output [7:0] vga_r, // 红 绿 蓝 颜 色 信 号
 output [7:0] vga_g,
 output [7:0] vga_b,
 input [7:0] ascii,
 input if_press,
 input if_back,
 input if_enter);
 
 wire clk_div;
 wire [11:0] vga_data;
 wire [9:0] h_addr;
 wire [9:0] v_addr;
 wire [3:0] VGA_R;
 wire [3:0] VGA_G;
 wire [3:0] VGA_B;
 
 assign vgn_sync_n=0;
 assign vga_r = {VGA_R, 4'b0000};
 assign vga_g = {VGA_G, 4'b0000};
 assign vga_b = {VGA_B, 4'b0000}; 
 
 clkgen #(25000000) my_vgaclk(clk,1'b0,1'b1,clk_div);
 
 div_clk M (clk, display_clk);
 
 vga_ctrl A (clk_div,1'b0,vga_data, h_addr, v_addr,vga_clk, hsync, vsync, valid, VGA_R, 
 VGA_G, VGA_B);
 
 display_pic B (clk,display_clk,h_addr,v_addr,vga_data,ascii,if_press,if_back,if_enter);

endmodule
