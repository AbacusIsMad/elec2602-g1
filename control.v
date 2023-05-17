module control(clkin, clk, inst, instC, immC, typeC,
	busOut1, busOut2, busIn, do_brch, break_pipe, pc_fetch,
	hex_out, led_out, num_in, num_clk,
	block,
	ovrd, instd, insta,
	regs
	);
	parameter CTL_CAL = 7;
	parameter ZRO_OUT1 = 0;
	parameter ZRO_OUT2 = 1;
	parameter REG1_CTL = 2;
	parameter REG2_CTL = 3;
	parameter IMM_CTL = 4;
	parameter RAMIN_CTL = 5;
	parameter BRCH_CTL = 6;
	
	parameter CTL_WRI = 5;
	parameter ZRO_IN = 0;
	parameter ALU_CTL = 1;
	parameter RAMOUT_CTL = 2;
	parameter PC_CTL = 3;
	parameter REG_CTL = 4;

	input clkin;
	output clk;

	//connect instruction from ram to this one
	output wire[31:0] inst;
	output wire[31:0] instC, immC;
	output wire[3:0] typeC;
	output wire break_pipe;
	pipeline2 pipeline_real(.inst(inst), .clk(clk), .reset(break_pipe), //the reset comes from the pc!
		.instC(instC), .instW(), .typeC(typeC), .typeW(), .immC(immC), .immW());
	
	output wire[31:0] pc_fetch;
	
	//clock conversion
	output wire block;
	wire stop;
	clock_manager clk_real(.actual_clk(clkin), .actual_clk_neg(~clkin), .block(block), .stop(stop), .out_clock(clk));
	
	
	//control circuits
	wire [CTL_CAL-1:0] cal_ctl;
	control_calculate#(.CTL_CAL(CTL_CAL), .ZRO_OUT1(ZRO_OUT1), .ZRO_OUT2(ZRO_OUT2), .REG1_CTL(REG1_CTL), 
		.REG2_CTL(REG2_CTL), .IMM_CTL(IMM_CTL), .RAMIN_CTL(RAMIN_CTL), .BRCH_CTL(BRCH_CTL))
		cal_real(.inst(instC), ._type(typeC), .ctl(cal_ctl));
	wire [CTL_WRI-1:0] wri_ctl;
	control_write#(.CTL_WRI(CTL_WRI), .ZRO_IN(ZRO_IN), .ALU_CTL(ALU_CTL), .RAMOUT_CTL(RAMOUT_CTL),
		.PC_CTL(PC_CTL), .REG_CTL(REG_CTL))
		write_real(.inst(instC), ._type(typeC), .ctl(wri_ctl));
	
	
	
	//the busses. everything connects to this, for example:
	output wire[31:0] busOut1, busOut2, busIn;
	
	//zeros so the logic doesn't complain
	tri_buf reg_zo1(.in(0), .out(busOut1), .enable(cal_ctl[ZRO_OUT1]));
	tri_buf reg_zo2(.in(0), .out(busOut2), .enable(cal_ctl[ZRO_OUT2]));
	tri_buf reg_zi(.in(0), .out(busIn), .enable(wri_ctl[ZRO_IN]));
	
	//the registers!	
	output wire[1023:0] regs;
	wire[31:0] reg1_out, reg2_out;
	gen_regs gen_regs_real(.in(busIn), .clk(clk), //use posedge clk
		.selectR(32'h00000001 << instC[19:15]), .selectR2(32'h00000001 << instC[24:20]), 
		.selectW(32'h00000001 << instC[11:7]),
		.reset(), .out(reg1_out), .out2(reg2_out), .enable(wri_ctl[REG_CTL])
		,.visible(regs)
		);
	tri_buf reg_tri1(.in(reg1_out), .out(busOut1), .enable(cal_ctl[REG1_CTL]));
	tri_buf reg_tri2(.in(reg2_out), .out(busOut2), .enable(cal_ctl[REG2_CTL]));
	
	//the immediate
	tri_buf imm_tri(.in(immC), .out(busOut2), .enable(cal_ctl[IMM_CTL]));
	
	//the ram memory read/write is falling edge, while pc access is rising edge
	wire[31:0] ram_out;
	output[31:0] hex_out;
	output [9:0] led_out;
	input [7:0] num_in;
	input num_clk;
	
	output wire ovrd;
	output wire[31:0] instd, insta;
	ram_dual ram_real(.data(busOut2), .we(instC[5]), .enable(cal_ctl[RAMIN_CTL]), 
		.mem_clk(~clk), .size(instC[13:12]), .sext(instC[14]), .pc_clk(clk), 
		//add the address to immediate
		.mem_addr(busOut1 + immC), .pc_addr(pc_fetch), .mem_q(ram_out), .pc_q(inst),
		.hex_out(hex_out), .led_out(led_out), .num_in(num_in), .num_clk(num_clk), .block(block), .stop(stop), .real_clk(clkin),
		.pc_override(ovrd), .inst_data(instd), .inst_addr(insta));
	
	tri_buf ram_tri(.in(ram_out), .out(busIn), .enable(wri_ctl[RAMOUT_CTL]));
	
	
	//the alu
	wire[31:0] alu_out;
	alu#(.LEN(32)) alu_real(.A(busOut1), .B(busOut2), .out(alu_out), .code({instC[30], instC[14:12]}), ._type(typeC));
	tri_buf alu_tri(.in(alu_out), .out(busIn), .enable(wri_ctl[ALU_CTL]));
	
	//the branch unit
	output wire do_brch;
	branch_manager brch_real(.val1(busOut1), .val2(busOut2), .op(instC[14:12]), ._type(typeC), .out(do_brch));
	
	//the pc. uses the negative edge to update!
	wire[31:0] pc_out;
	pc_manager pc_real(.val1(busOut1), .imm(immC), ._type(typeC),
		.clk(~clk), .enable(cal_ctl[BRCH_CTL]), .branch(do_brch), .stop(), .pc(pc_fetch), .pc2(), .pcOut(pc_out), .breakPipe(break_pipe),
		.pc_override(ovrd), .inst_data(instd), .inst_addr(insta));
	tri_buf pc_tri(.in(pc_out), .out(busIn), .enable(wri_ctl[PC_CTL]));
	
	
	//the memory mapped io. This includes the hex (0x0800), the led (0x0808), and switch inputs (0x0816)

endmodule