`timescale 1ns / 1ps
 
module gen_regs_TB;
 
	// ------------------ Instantiate module ------------------
	
	reg [7:0] count;
	reg reset;
	reg clock;
	reg enable;
	reg [7:0] sw, sr1, sr2;

	
	wire[7:0] out, out2;
	
	gen_regs#(.WIDTH(8), .SIZE(8)) gr(.in(count), .clk(clock),
		.selectR(sr1), .selectR2(sr2), .selectW(sw), .reset(reset), .out(out), .out2(out2), .enable(enable));
	
	initial begin 
		count = 0;
		reset = 1;
		clock = 0;
		enable = 0;
		sw = 0; sr1 = 0; sr2 = 0;
	end
	
	always begin
		#50
		count=count+ 1;
	end
	
	always begin
		#25
		clock = clock + 1;
	end
	

	
	always @(count) begin
		case (count)
			0: begin reset = 1; end
			1: begin reset = 0; enable = 1; sw = 2; sr1 = 2; sr2 = 2; end
			default begin enable = count % 3; sw = 1 << (count % 8); sr1 = 1 << ((count + 1) % 8); sr2 = 1 << ((count + 2) % 8); end
		endcase
	end

 
endmodule
