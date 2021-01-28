module display_pic(
	input clk,
	input clk_div,
	input [9:0] h_addr,
	input [9:0] v_addr,
	output reg [11:0] data,
	input [7:0] ascii,
	input if_press,
	input if_back,
	input if_enter
 );
 
 wire [9:0] charx, chary;
 wire [3:0] ct_x;
 wire [11:0] ct_y;
 
 wire [11:0] line;
 reg [7:0] ascii_vector[0:29][0:69];
 wire [7:0] curr_ascii;
 reg [11:0] vga[4095:0];
 reg [7:0] cmd_line[11:0];
 reg [6:0] now_x, now_y;
 reg [6:0] max_x, max_y;
 wire [9:0] light_h;
 wire [9:0] light_v;
 reg [11:0] light;

 
   assign chary=v_addr/16;
	assign charx=h_addr/9;
   assign curr_ascii=h_addr<10'd630 ? ascii_vector[chary][charx] : 8'b0;
   assign ct_x=h_addr%9;
   assign ct_y={curr_ascii[7:0], v_addr[3:0]};
   assign line=vga[ct_y];
	assign light_h = {now_x[6:0], 3'b0}+now_x;
   assign light_v = {now_y[5:0], 4'b0};
   
 
 integer i,j;
 
initial
 begin
 $readmemh("C:/Users/44254/Desktop/digit_design_exp/exp11/vga_font.txt", vga, 0, 4095);
 for(i=0;i<30;i=i+1)
	for (j=0;j<70;j=j+1)
		ascii_vector[i][j] = 8'b0;

 now_x=0;
 max_x=0;
 now_y=0;
 max_y=0;
 light=0;
 
cmd_line[0] = 8'h44;cmd_line[1] = 8'h69;cmd_line[2] = 8'h6E;cmd_line[3] = 8'h67;cmd_line[4] = 8'h40;
cmd_line[5] = 8'h44;cmd_line[6] = 8'h69;cmd_line[7] = 8'h6E;cmd_line[8] = 8'h67;cmd_line[9] = 8'h3A;
cmd_line[10] = 8'h7E;cmd_line[11] = 8'h24;
 
ascii_vector[0][0] = 8'h57;ascii_vector[0][1] = 8'h65;ascii_vector[0][2] = 8'h6C;ascii_vector[0][3] = 8'h63; 
ascii_vector[0][4] = 8'h6F;ascii_vector[0][5] = 8'h6D;ascii_vector[0][6] = 8'h65;ascii_vector[0][7] = 8'h21;
ascii_vector[2][0] = 8'h44;ascii_vector[2][1] = 8'h69;ascii_vector[2][2] = 8'h6E;ascii_vector[2][3] = 8'h67;
ascii_vector[2][4] = 8'h40;ascii_vector[2][5] = 8'h44;ascii_vector[2][6] = 8'h69;ascii_vector[2][7] = 8'h6E;
ascii_vector[2][8] = 8'h67;ascii_vector[2][9] = 8'h3A;ascii_vector[2][10] = 8'h7E;ascii_vector[2][11] = 8'h24;


 end
 
always@(posedge clk_div)
begin
if(if_press==1 && ascii!=8'b0)
	begin
	if(if_enter)//回车
	begin
	 for (i=0;i<12;i=i+1)
       ascii_vector[max_y+1][i] <= cmd_line[i];
    now_x<=12;
	 max_x <=12;
    max_y<=max_y + 1;
	 now_y<=max_y+1;
	end
	else if(if_back&&now_x==max_x&&now_y==max_y&&(now_x!= 0||now_y!=2))//backspace 
	begin
      if (now_x==0) 
		begin
			ascii_vector[now_y-1][69]<=8'b0;
			now_x<=69;
			now_y<=now_y-1;
			max_x<=69;
			max_y<=now_y-1;
      end 
		else 
		begin
			 ascii_vector[now_y][now_x-1]<=8'b0;
			 now_x<=now_x-1;
			 max_x<=now_x-1;
		end
	end
	else if (now_x==69) 
		begin
           ascii_vector[now_y][now_x]<=ascii;
           now_x<=0;
           now_y<=now_y+1;
           /*if (max_y==now_y&&max_x==now_x) 
			  begin
               max_x <= 0;
               max_y <= now_y + 1;
            end*/
       end
		 
	else 
		begin
        ascii_vector[now_y][now_x]<=ascii;
        now_x <= now_x + 1;
        if (max_y == now_y && max_x == now_x) 
			max_x <= now_x + 1;
		end
	end
	
 end
 
 always@(posedge clk)
 begin
 if (h_addr>=light_h && h_addr<light_h+9 && v_addr>=light_v&&v_addr<light_v+16)
	begin
		data<=light;
		light=~light;
	end
 else
	data <= line[ct_x[3:0]] ? 12'hfff:12'h0;
 end
 
 endmodule
 