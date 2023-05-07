module control(clk, inst, instC, immC, typeC, busOut1, busOut2, busIn, alu_out);
	parameter CTL_CAL = 5;
	parameter REG1_CTL = 0;
	parameter REG2_CTL = 1;
	parameter IMM_CTL = 2;
	parameter RAMIN_CTL = 3;
	parameter BRCH_CTL = 4;
	
	parameter CTL_WRI = 4;
	parameter ALU_CTL = 0;
	parameter RAMOUT_CTL = 1;
	parameter PC_CTL = 2;
	parameter REG_CTL = 3;

	input clk;

	//connect instruction from ram to this one
	input wire[31:0] inst;
	output wire[31:0] instC, immC;
	output wire[3:0] typeC;
	output wire break_pipe;
	pipeline2 pipeline_real(.inst(inst), .clk(clk), .reset(break_pipe), //the reset comes from the pc!
		.instC(instC), .instW(), .typeC(typeC), .typeW(), .immC(immC), .immW());
	
	//control circuits
	wire [CTL_CAL-1:0] cal_ctl;
	control_calculate#(.CTL_CAL(CTL_CAL), .REG1_CTL(REG1_CTL), 
		.REG2_CTL(REG2_CTL), .IMM_CTL(IMM_CTL), .RAMIN_CTL(RAMIN_CTL), .BRCH_CTL(BRCH_CTL))
		cal_real(.inst(instC), ._type(typeC), .ctl(cal_ctl));
	wire [CTL_WRI-1:0] wri_ctl;
	control_write#(.CTL_WRI(CTL_WRI), .ALU_CTL(ALU_CTL), .RAMOUT_CTL(RAMOUT_CTL),
		.PC_CTL(PC_CTL), .REG_CTL(REG_CTL))
		write_real(.inst(instC), ._type(typeC), .ctl(wri_ctl));
	
	
	
	//the busses. everything connects to this, for example:
	output wire[31:0] busOut1, busOut2, busIn;
	
	//the registers!
	wire[31:0] reg1_out, reg2_out;
	gen_regs gen_regs_real(.in(busIn), .clk(clk), //use posedge clk
		.selectR(1 << instC[19:15]), .selectR2(1 << inst[24:20]), .selectW(1 << inst[11:7]),
		.reset(), .out(reg1_out), .out2(reg2_out), .enable(wri_ctl[REG_CTL]));
	tri_buf reg_tri1(.in(reg1_out), .out(busOut1), .enable(cal_ctl[REG1_CTL]));
	tri_buf reg_tri2(.in(reg2_out), .out(busOut2), .enable(cal_ctl[REG2_CTL]));
	
	//the immediate
	tri_buf imm_tri(.in(immC), .out(busOut2), .enable(cal_ctl[IMM_CTL]));
	
	//the alu
	output wire[31:0] alu_out;
	alu#(.LEN(32)) alu_real(.A(busOut1), .B(busOut2), .out(alu_out), .code({instC[30], instC[14:12]}), ._type(typeC));
	tri_buf alu_tri(.in(alu_out), .out(busIn), .enable(wri_ctl[ALU_CTL]));
	
	//the branch unit
	
	
	//the pc. uses the negative edge to update!
	wire[31:0] pc_out;
	pc_manager pc_real(.val1(busOut1), .imm(immC), ._type(typeC),
		.clk(~clk), .enable(cal_ctl[BRCH_CTL]), .branch(), .stop(), .pc(), .pc2(), .pcOut(pc_out), .breakPipe(break_pipe));
	tri_buf pc_tri(.in(pc_out), .out(busIn), .enable(wri_ctl[PC_CTL]));

endmodule