module process(datain,ascii);

input [7:0] datain;
output reg [7:0] ascii;
(*ram_init_file="scancode.mif"*) reg [7:0]lut[255:0];

always @(*)
	begin
		ascii=lut[datain];
	end
endmodule
