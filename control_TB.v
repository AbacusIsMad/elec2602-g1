`timescale 1ns / 1ps

module control_TB();

	reg [9:0] count;
	reg clk;
	wire clkout;
	wire[31:0] pc, inst, instC, immC;
	wire[3:0] typeC;
	wire[31:0] busOut1, busOut2, busIn;
	wire do_brch, break_pipe;

	wire num_clk, block;
	
	wire override;
	wire reset;
	wire[31:0] inst_data, inst_addr;
	
	wire[1023:0] regs;

	wire[7:0] num_in;
	
	assign num_in = ((count > 24) && (count <= 30)) ? 0 : count;
	
	control ctl_test(.clkin(clk), .clk(clkout), .inst(inst), .instC(instC), .immC(immC), .typeC(typeC),
		.busOut1(busOut1), .busOut2(busOut2), .busIn(busIn), .do_brch(do_brch), .break_pipe(break_pipe), .pc_fetch(pc),
		.hex_out(), .led_out(), .num_in(num_in), .num_clk(num_clk),
		.block(block), .reset(reset),
		.ovrd(override), .instd(inst_data), .insta(inst_addr)
		,.regs(regs)
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
	
	assign reset = (count == 10'h315) ? 1 : 0;

	assign num_clk = ((count == 9) || (count == 16) || (count == 22) || (count == 28) || (count == 35)) ? 1 : 0;

endmodule