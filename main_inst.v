module main_inst(HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, SW, KEY, LEDR, CLOCK_50);
	input [9:0] SW;
	input [3:0] KEY;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output [9:0] LEDR;
	
	input CLOCK_50;
	
	wire[31:0] hex_tmp, pc_tmp;
	wire block, key_tmp, key2_tmp;
	debounce(.pb_1(~KEY[3]),.clk(CLOCK_50),.pb_out(key_tmp));
	debounce(.pb_1(~KEY[2]),.clk(CLOCK_50),.pb_out(key2_tmp));
	wire[9:0] led;
	control main(.clkin(CLOCK_50), .hex_out(hex_tmp),
		.led_out(led), .num_in(SW[9:2]), .num_clk(key_tmp), .block(block), .pc_fetch(pc_tmp), .reset(key2_tmp));
	
	//hex display for hexout.
	hex_display h0(.data(hex_tmp[3:0]), .disp(HEX0), .block(hex_tmp[31]));
	hex_display h1(.data(hex_tmp[7:4]), .disp(HEX1), .block(hex_tmp[31]));
	hex_display h2(.data(hex_tmp[11:8]), .disp(HEX2), .block(hex_tmp[31]));
	hex_display h3(.data(hex_tmp[15:12]), .disp(HEX3), .block(hex_tmp[31]));
	
	//for the num_in to confirm
	hex_display num_in0(.data(SW[5:2]), .disp(HEX4), .block(~block)); //inverted cause we want it to show when blocking
	hex_display num_in1(.data(SW[9:6]), .disp(HEX5), .block(~block));


	assign LEDR [9:0] = SW[1] ? pc_tmp [9:0] : led;
endmodule
