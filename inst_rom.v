module inst_rom(clk, addr, out);
	input clk;
	input [8:0] addr;
	output reg[31:0] out = 0;
	
	reg[31:0] rom[512-1:0];
	initial begin
		$readmemh("C:/Users/gengr/Desktop/code/ELEC2602/project/out/play.txt", rom);
	end
	
	always @(posedge clk) begin
		out <= rom[addr];
	end

endmodule