module exp9_3(
	input clk,
	input rst,
	output VGA_BLANK_N,
	output [7:0] VGA_B,
	output [7:0] VGA_R,
	output [7:0] VGA_G,
	output VGA_CLK,
	output VGA_HS,
	output VGA_VS,
	output VGA_SYNC_N	
);
   
   
   wire            pclk;
   wire            valid;
   wire            hsync;
   wire            vsync;
   wire [3:0]      vga_r;
   wire [3:0]      vga_g;
   wire [3:0]      vga_b;
   wire [9:0]      h_cnt;
   wire [9:0]      v_cnt;
   reg [11:0]      vga_data;
   reg [15:0]      rom_addr = 0;
   wire [11:0]     douta;
   wire            logo_area;
   reg [9:0]       logo_x = 0;
   reg [9:0]       logo_y = 0;
   parameter [9:0] logo_length = 10'b0010000000;
   parameter [9:0] logo_hight  = 10'b0010000000;
   reg [7:0]       speed_cnt;
   wire            speed_ctrl;
   reg [3:0]       flag_edge;
	
	assign VGA_BLANK_N = valid;
	assign VGA_B = {vga_b, 4'b0000};  
	assign VGA_R = {vga_r, 4'b0000};
   assign VGA_G = {vga_g, 4'b0000};
	assign VGA_CLK = pclk;
	assign VGA_HS = hsync;
   assign VGA_VS = vsync;
   assign VGA_SYNC_N = 0;
  
   
	clkgen #(25000000) A (clk,0,1'b1,pclk);  
	rom B (rom_addr, clk, douta);
	
 
	vga_640x480 u2 (
		.pclk(pclk), 
		.reset(rst), 
		.hsync(hsync), 
		.vsync(vsync), 
		.valid(valid), 
		.h_cnt(h_cnt), 
		.v_cnt(v_cnt)
		);
 
   assign logo_area = ((v_cnt >= logo_y) & (v_cnt <= logo_y + logo_hight - 1) & (h_cnt >= logo_x) & (h_cnt <= logo_x + logo_length - 1)) ? 1'b1 : 
                      1'b0;
   
   
   always @(posedge pclk)
   begin: logo_display
      if (rst == 1'b1)
         vga_data <= 12'b000000000000;
      else 
      begin
         if (valid == 1'b1)
         begin
            if (logo_area == 1'b1)
            begin
               rom_addr <= rom_addr + 14'b00000000000001;
               vga_data <= douta;
            end
            else
            begin
               rom_addr <= rom_addr;
               vga_data <= 12'b000000000000;
            end
         end
         else
         begin
            vga_data <= 12'b111111111111;
            if (v_cnt == 0)
               rom_addr <= 14'b00000000000000;
         end
      end
   end
   
   assign vga_r = vga_data[11:8];
   assign vga_g = vga_data[7:4];
   assign vga_b = vga_data[3:0];
   
   
   always @(posedge pclk)
   begin: speed_control
      if (rst == 1'b1)
         speed_cnt <= 8'h00;
      else 
      begin
         if ((v_cnt[5] == 1'b1) & (h_cnt == 1))
            speed_cnt <= speed_cnt + 8'h01;
      end
   end
   
   
   debounce u3(.sig_in(speed_cnt[5]), .clk(pclk), .sig_out(speed_ctrl));
   
   
   always @(posedge pclk)
   begin: logo_move
      
      reg [1:0]       flag_add_sub;
      
      if (rst == 1'b1)
      begin
         flag_add_sub = 2'b01;
         
         logo_x <= 10'b0110101110;
         logo_y <= 10'b0000110010;
      end
      else 
      begin
         
         if (speed_ctrl == 1'b1)
         begin
            if (logo_x == 1)
            begin
               if (logo_y == 1)
               begin
                  flag_edge <= 4'h1;
                  flag_add_sub = 2'b00;
               end
               else if (logo_y == 480 - logo_hight)
               begin
                  flag_edge <= 4'h2;
                  flag_add_sub = 2'b01;
               end
               else
               begin
                  flag_edge <= 4'h3;
                  flag_add_sub[1] = (~flag_add_sub[1]);
               end
            end
            
            else if (logo_x == 640 - logo_length)
            begin
               if (logo_y == 1)
               begin
                  flag_edge <= 4'h4;
                  flag_add_sub = 2'b10;
               end
               else if (logo_y == 480 - logo_hight)
               begin
                  flag_edge <= 4'h5;
                  flag_add_sub = 2'b11;
               end
               else
               begin
                  flag_edge <= 4'h6;
                  flag_add_sub[1] = (~flag_add_sub[1]);
               end
            end
            
            else if (logo_y == 1)
            begin
               flag_edge <= 4'h7;
               flag_add_sub[0] = (~flag_add_sub[0]);
            end
            else if (logo_y == 480 - logo_hight)
            begin
               flag_edge <= 4'h8;
               flag_add_sub[0] = (~flag_add_sub[0]);
            end
            else
            begin
               flag_edge <= 4'h9;
               flag_add_sub = flag_add_sub;
            end
            
            case (flag_add_sub)
               2'b00 :
                  begin
                     logo_x <= logo_x + 10'b0000000001;
                     logo_y <= logo_y + 10'b0000000001;
                  end
               2'b01 :
                  begin
                     logo_x <= logo_x + 10'b0000000001;
                     logo_y <= logo_y - 10'b0000000001;
                  end
               2'b10 :
                  begin
                     logo_x <= logo_x - 10'b0000000001;
                     logo_y <= logo_y + 10'b0000000001;
                  end
               2'b11 :
                  begin
                     logo_x <= logo_x - 10'b0000000001;
                     logo_y <= logo_y - 10'b0000000001;
                  end
               default :
                  begin
                     logo_x <= logo_x + 10'b0000000001;
                     logo_y <= logo_y + 10'b0000000001;
                  end
            endcase
         end
         
      end
   end
	
endmodule
