module process_pic(ascii,clk,color, v_addr);

input [7:0] ascii;
input [9:0] v_addr;
input clk;
output reg [11:0] color;
reg [18:0] addr;


always @(posedge clk)
	begin
		addr=1+(ascii<<4)+v_addr%6;
		color=vga[addr];
	end
	
endmodule
