`timescale 1ns / 1ps
 
module tri_buf_TB;
 
	// ------------------ Instantiate module ------------------
	
	reg [7:0] count;
	reg reset;
	reg clock;

	reg[31:0] instIn;
	wire[31:0] inst1, inst2;
	wire[31:0] imm1, imm2;
	wire[3:0] type1, type2;
	
	pipeline2#(.WIDTH(32)) p1(.inst(instIn), .clk(clock), .reset(reset), .instC(inst1), .instW(inst2), .typeC(type1), .typeW(type2), .immC(imm1), .immW(imm2));
	
	initial begin 
		count = 0;
		reset = 1;
		clock = 0;
		instIn = 0;
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
			1: begin reset = 0; instIn = 32'h80078623;end
			2: begin instIn = 32'h00c000ef;end
		endcase
	end

 
endmodule
