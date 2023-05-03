module gen_regs_init(SW, LEDR, KEY);
	input[9:0] SW;
	output[9:0] LEDR;
	input [3:0] KEY;
	

	gen_regs#(.WIDTH(4), .SIZE(4)) gr(.in(SW[9:6]), .clk(KEY[0]), .select(SW[5:2]), .reset(SW[0]), .out(LEDR[3:0]), .isIn(SW[1]));

endmodule