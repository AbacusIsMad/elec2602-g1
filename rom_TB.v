`timescale 1ns / 1ps

module rom_TB();

	reg clk = 0;
	reg [8:0] pc = 0;
	wire[31:0] inst_data;

	made_rom rom(.clock(clk), .address(pc), .q(inst_data));
	
	always begin
		#25
		clk = clk + 1;
	end
	
	always begin
		#50
		pc = pc + 1;
	end


endmodule