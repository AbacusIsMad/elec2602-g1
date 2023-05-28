`timescale 1ps / 1ps

module control_TB();

	reg [9:0] count;
	reg clk;
	wire clkout;
	wire[31:0] pc, inst, instC, immC;
	wire[3:0] typeC;
	wire[6:0] cal_ctl;
	wire[4:0] wri_ctl;
	wire[31:0] busOut1, busOut2, busIn;
	wire do_brch, break_pipe;

	wire num_clk, block;
	
	wire override;
	wire reset;
	wire[31:0] inst_data, inst_addr;
	
	wire[1023:0] regs;

	wire[7:0] num_in;
	
	assign num_in = (count == 10'h222) ? 0 : count;
	
	wire[31:0] hex;
	wire[9:0] led;
	
	control ctl_test(.clkin(clk), .clk(clkout), .inst(inst), .instC(instC), .immC(immC), .typeC(typeC),
		.busOut1(busOut1), .busOut2(busOut2), .busIn(busIn), .do_brch(do_brch), .break_pipe(break_pipe), .pc_fetch(pc),
		.hex_out(hex), .led_out(led), .num_in(num_in), .num_clk(num_clk),
		.block(block), .reset(reset),
		.ovrd(override), .instd(inst_data), .insta(inst_addr),
		.cal_ctl(cal_ctl), .wri_ctl(wri_ctl)
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
	//assign reset = 0;

	//add_2_nums
	//assign num_clk = ((count == 10'h20d) || (count == 10'h214)) ? 1 : 0;
	//5_sum
	assign num_clk = ((count == 10'h20d) || (count == 10'h214) || (count == 10'h21b) || (count == 10'h222)) ? 1 : 0;
endmodule