module control(clk, inst, instC, immC, typeC, busOut1, busOut2, busIn, alu_out);
	parameter CTL_CAL = 3;
	parameter REG1_CTL = 0;
	parameter REG2_CTL = 1;
	parameter IMM_CTL = 2;
	
	parameter CTL_WRI = 3;
	parameter ALU_CTL = 0;
	parameter RAM_CTL = 1;
	parameter PC_CTL = 2;

	input clk;

	//connect instruction from ram to this one
	output wire[31:0] inst;
	output wire[31:0] instC, immC;
	output wire[3:0] typeC;
	pipeline2 pipeline_real(.inst(inst), .clk(clk), .reset(), 
		.instC(instC), .instW(), .typeC(typeC), .typeW(), .immC(immC), .immW());
	
	
	//the busses. everything connects to this, for example:
	output wire[31:0] busOut1, busOut2, busIn;
	
	//the registers!
	wire[31:0] reg1_out, reg2_out;
	gen_regs gen_regs_real(.in(busIn), .clk(clk), //use posedge clk
		.selectR(), .selectR2(), .selectW(), .reset(), .out(reg1_out), .out2(reg2_out), .enable());
	tri_buf reg_tri1(.in(reg1_out), .out(busOut1),. enable(1));
	tri_buf reg_tri2(.in(reg2_out), .out(busOut2),. enable(0));
	
	//the alu
	output wire[31:0] alu_out;
	alu alu_real(.A(busOut1), .B(busOut2), .out(alu_out), .code({instC[31:25], instC[14:12]}));
	tri_buf alu_tri(.in(alu_out), .out(busIn), .enable(1));

endmodule