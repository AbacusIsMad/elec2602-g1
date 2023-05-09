module clock_manager(actual_clk, actual_clk_neg, block, stop, out_clock);

	//blocking does it temporarily, while stopping cannot be reversed.
	input actual_clk, actual_clk_neg, block, stop;
	output wire out_clock;
	
	assign out_clock = actual_clk & ~block & ~stop;

endmodule