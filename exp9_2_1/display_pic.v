module display_pic(
	input clk_div,
	input [9:0] h_addr,
	input [9:0] v_addr,
	output reg [23:0] data
 );
 
 wire [11:0] color;
 wire [18:0] addr;
 
 assign addr={h_addr,v_addr[8:0]};
 
 ram1 process(addr,clk_div,color);
 
 always@(posedge clk_div)
 begin
		data[23:20]=color[11:8];
		data[19:16]=4'b0000;
		data[15:12]=color[7:4];
		data[11:8]=4'b0000;
		data[7:4]=color[3:0];
		data[3:0]=4'b0000;
 end
 
 endmodule
 