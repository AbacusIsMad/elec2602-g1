`timescale 1ns / 1ps

module pc_TB();

	reg [7:0] count;
	reg clock;

	reg[31:0] val1, imm;
	reg[3:0] _type;
	reg enable, branch, stop;
	wire[31:0] pc, pc2, pcOut;
	wire breakPipe;
	
	
	pc_manager pcm(.val1(val1), .imm(imm), ._type(_type), .clk(~clock),
		.enable(enable), .branch(branch), .stop(stop), .pc(pc), .pc2(pc2), .pcOut(pcOut), .breakPipe(breakPipe));
	
	initial begin 
		count = 0;
		clock = 0;
		val1 = 0; imm = 1; _type = 0; enable = 0; branch = 0; stop = 0;
	end
	
	always begin
		#25
		clock = clock + 1;
	end
	
	always @(posedge clock) begin
		count = count + 1;
	end
	
	
	always @(count) begin
		case (count)
			0: begin end
			1: begin val1 = 10; imm = 2345; _type = 4'b1001; end //auipc before jump
			2: begin val1 = 10; imm = 12; enable = 1; branch = 1; _type = 4'b0110; end //jump
			3: begin imm = 1; enable = 0; branch = 0; _type = 4'b1001; end //auipc after jump
			4: begin imm = 4; enable = 1; branch = 1; _type = 4'b0110; end //jump backwards (stay on the same instruction)
			default: begin enable = 0; branch = 0; end
		endcase
	end

endmodule