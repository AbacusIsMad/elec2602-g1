module control_TB();

	reg [7:0] count;
	reg clk;
	wire clkout;
	wire[31:0] pc, inst, instC, immC;
	wire[3:0] typeC;
	wire[31:0] busOut1, busOut2, busIn;
	wire do_brch, break_pipe;

	wire num_clk, block;
	
	wire[1023:0] regs;

	control ctl_test(.clkin(clk), .clk(clkout), .inst(inst), .instC(instC), .immC(immC), .typeC(typeC),
		.busOut1(busOut1), .busOut2(busOut2), .busIn(busIn), .do_brch(do_brch), .break_pipe(break_pipe), .pc_fetch(pc),
		.hex_out(), .led_out(), .num_in(count), .num_clk(num_clk),
		.block(block),
		.regs(regs)
	);
	
	initial begin
		clk = 0;
		count = 0;
	end
	
	always begin
		#50
		count = count + 1;
	end
	
	always begin
		#25
		clk = clk + 1;
	end

	assign num_clk = ((count == 9) || (count == 14)) ? 1 : 0;

endmodule