module main_inst(HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, SW, KEY, LEDR, clk);
	input [9:0] SW;
	input [3:0] KEY;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output [9:0] LEDR;
	
	input clk;
	
	wire[31:0] hex_tmp;
	wire block;
	control main(.clkin(KEY[1]), .hex_out(),
		.led_out(LEDR[9:0]), .num_in(SW[9:2]), .num_clk(KEY[3]),	.block(block), .pc_fetch(hex_tmp));
	
	//hex display for hexout.
	hex_display h0(.data(hex_tmp[3:0]), .disp(HEX0), .block(hex_tmp[31]));
	hex_display h1(.data(hex_tmp[7:4]), .disp(HEX1), .block(hex_tmp[31]));
	hex_display h2(.data(hex_tmp[11:8]), .disp(HEX2), .block(hex_tmp[31]));
	hex_display h3(.data(hex_tmp[15:12]), .disp(HEX3), .block(hex_tmp[31]));
	
	//for the num_in to confirm
	hex_display num_in0(.data(SW[5:2]), .disp(HEX4), .block(~block)); //inverted cause we want it to show when blocking
	hex_display num_in1(.data(SW[9:6]), .disp(HEX5), .block(~block));

endmodule