`timescale 1ns / 1ps
 
module tri_buf_TB;
 
	// ------------------ Instantiate module ------------------
	
	reg [7:0] count;
	wire[7:0] out, out2;
	reg reset, isIn;
	reg clock;
	
	reg[7:0] select, select2;
	
	// instantiate and connect master_slave here
	//tri_buf#(.LEN(4)) t0(.in(count), .out(out), .enable(count[0]));
	//tri_buf#(.LEN(4)) t1(.in(count), .out(out), .enable(~count[0]));
	
	gen_regs#(.WIDTH(8), .SIZE(8)) r0(
		.in(count), .clk(clock), .out(out), .out2(out2), .select(select), .select2(select << 4), .reset(reset), .isIn(isIn));
	
	initial begin 
		count = 0;
		reset = 1;
		select = 0;
		isIn = 0;
		clock = 0;
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
			0: begin reset = 1; select = 1; end
			1: begin reset = 0; select = 2; isIn = 1; end
			2: begin select = 1; isIn = 0; end
			3: begin select = 2; end
			default: begin select = 1 << (count % 8); isIn = (count % 3); end
		endcase
	end

 
endmodule
