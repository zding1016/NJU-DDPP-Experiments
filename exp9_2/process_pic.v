module process_pic(h_addr,v_addr,clk,color);

input [9:0] h_addr;
input [9:0] v_addr;
input clk;
output reg [11:0] color;
reg [18:0] addr;
(*ram_init_file="my_picture.mif"*) reg [11:0]vga[327679:0];

always @(posedge clk)
	begin
		addr={h_addr,v_addr[8:0]};
		color=vga[addr];
	end
	
endmodule
